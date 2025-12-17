#define FUSE_USE_VERSION 30
#include <stdint.h>
#include <stdio.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <libgen.h>
#include <stdlib.h>
#include <fuse.h>
#include <assert.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#include "wfs.h"


/* --------------------------------------------------------------------------
 * CS537 P6 Filesystem Project Starter
 *
 * You will implement the mini WFS filesystem in FOUR STAGES:
 *  1. FILE IT UP           : Basic filesystem (superblock, inode alloc, data blocks,
 *                            create files/directories, read/write, readdir, unlink).
 *  2. Show me the Big Picture : statfs reporting global filesystem statistics.
 *  3. Tick Tok Tick Tok    : Correct atime/mtime/ctime handling on operations.
 *  4. Colour Colour ...    : Extended attribute user.color and colored ls output.
 *
 * This file provides the skeleton you must complete. Every TODO marker corresponds
 * to required functionality. Keep code modular; do not monolithically grow one
 * function. You are encouraged to add helper functions and files as needed.
 * --------------------------------------------------------------------------
 */

/* --------------------------- Globals / Mount ------------------------------ */
void *mregion; // mapped disk image
int wfs_error; // last error to return through FUSE

struct color_entry { const char *name; uint8_t code; };
static const struct color_entry color_table[] = {
    {"none",    WFS_COLOR_NONE},
    {"red",     WFS_COLOR_RED},
    {"green",   WFS_COLOR_GREEN},
    {"blue",    WFS_COLOR_BLUE},
    {"yellow",  WFS_COLOR_YELLOW},
    {"magenta", WFS_COLOR_MAGENTA},
    {"cyan",    WFS_COLOR_CYAN},
    {"white",   WFS_COLOR_WHITE},
    {"black",   WFS_COLOR_BLACK},
    {"orange",  WFS_COLOR_ORANGE},
    {"purple",  WFS_COLOR_PURPLE},
    {"gray",    WFS_COLOR_GRAY},
};

int parse_color_name(const char *s, uint8_t *out_code) {
    if (!s || !out_code) return 0;
    char buf[32]; size_t n = 0;
    while (s[n] && n + 1 < sizeof(buf)) { buf[n] = (char)tolower((unsigned char)s[n]); n++; }
    buf[n] = '\0';
    for (size_t i = 0; i < sizeof(color_table)/sizeof(color_table[0]); i++) {
        if (strcmp(buf, color_table[i].name) == 0) { *out_code = color_table[i].code; return 1; }
    }
    return 0;
}

/* Return the color name decorated with ANSI escape codes so terminals
 * show the name itself in that color. Note: this means any consumer
 * of the xattr will receive the escape sequences. If you want raw
 * names for scripting, keep a separate helper returning undecorated
 * names. */
typedef struct { const char *ansi; const char *name; } wfs_color_info;

static inline const wfs_color_info* wfs_color_from_code(uint8_t code) {
    static const wfs_color_info table[] = {
        [WFS_COLOR_NONE]    = { "",               "none"    },
        [WFS_COLOR_RED]     = { "\033[31m",       "red"     },
        [WFS_COLOR_GREEN]   = { "\033[32m",       "green"   },
        [WFS_COLOR_BLUE]    = { "\033[34m",       "blue"    },
        [WFS_COLOR_YELLOW]  = { "\033[33m",       "yellow"  },
        [WFS_COLOR_MAGENTA] = { "\033[35m",       "magenta" },
        [WFS_COLOR_CYAN]    = { "\033[36m",       "cyan"    },
        [WFS_COLOR_WHITE]   = { "\033[37m",       "white"   },
        [WFS_COLOR_BLACK]   = { "\033[30m",       "black"   },
        [WFS_COLOR_ORANGE]  = { "\033[38;5;208m", "orange"  },
        [WFS_COLOR_PURPLE]  = { "\033[35m",       "purple"  },
        [WFS_COLOR_GRAY]    = { "\033[90m",       "gray"    },
    };
    if (code < WFS_COLOR_MAX) return &table[code];
    return &table[WFS_COLOR_NONE];
}

// Helper: strip ANSI color sequences from names (useful when colorizing ls output)
void strip_ansi_codes(const char *in, char *out, size_t out_len)
{
    // error checking: missing argument
    if (!in || !out || out_len == 0) {
        return; 
    }

    size_t i = 0;
    size_t j = 0;

    // if escape is 1 we are iterating through escape char sequence
    // if escape is 0 we are iterating through normal char sequence 
    int escape = 0;
    while(in[i] != '\0' && j < out_len -1) {
        if (in[i] == '\033') {
            // start of ansi escape sequence
            escape = 1;
            i++;
            continue;
        }
        if (escape) {
            // skip characters until we find m (end of code)
            if (in[i] == 'm') {
                escape = 0;
            }
            i++;
            continue;
        }
        // copy normal characters
        out[j++] = in[i++];
    }
    // need to add terminating char
    out[j] = '\0';
}

int get_inode_from_path(char *path, struct wfs_inode **inode)
{
    // error checking: no path or inode 
    if (!path || !inode) {
        return -ENOENT;
    }

    // if does not start with / we should add /
    if (path[0] != '/') {
        char tmp[1024];
        snprintf(tmp, sizeof(tmp), "/%s", path);
        path = strdup(tmp);
    }

    // get the inode
    *inode = retrieve_inode(0); 
    if (!*inode) {
        return -ENOENT;
    }

    // check if its root path 
    if (strcmp(path, "/") == 0) {
        return 0; 
    }

    // make copy of path so we can edit
    char * pathCopy = strdup(path);
    if (!pathCopy) {
        return -ENOENT;
    }

    // find the start of the path (don't include /)
    char* start = pathCopy;
    if(start[0] == '/') {
        start ++;
    }

    char* currPath = strtok(start, "/");
    // iterate through path 
    while (currPath != NULL) {
        // current segment is null 
        if (strlen(currPath) == 0) {
            currPath = strtok(NULL, "/"); 
            continue; 
        }

        // check if inode is a directory
        if (!S_ISDIR((*inode)->mode)) {
            free(pathCopy);
            return -ENOENT;
        }

        int isFound = 0;
        off_t offset = 0;

        // iterate through entries to find fiel
        while (offset < (*inode)->size) {
            // need to iterate through all bytes in directory
            char* pointer = data_offset(*inode, offset, 0);
            // error checking: no pointer
            if (!pointer) {
                free(pathCopy);
                return -ENOENT;
            }

            // cast to entry so we can get name and num
            struct wfs_dentry* entry = (struct wfs_dentry*)pointer;
            
           // check that entry exists and matches currPath
            if (entry->num != 0 && strcmp(entry->name, currPath) == 0) {
                // find inode it points to
                *inode = retrieve_inode(entry->num);
                if (!*inode) {
                    free(pathCopy);
                    return -ENOENT;
                }
                // update found 
                isFound = 1;
                break;
            }

            // move to next entry
            offset += sizeof(struct wfs_dentry);
        }

        // we did nto find entry
        if (!isFound) {
            free(pathCopy);
            return -ENOENT;
        }

        // next path 
        currPath = strtok(NULL, "/"); 
    }

    free(pathCopy);
    // we found it!
    return 0;
}
void free_bitmap(uint32_t position, uint32_t* bitmap) {
    /*TODO: Clear the bit at 'position' in the bitmap */
    uint32_t wordIndex = position / 32;
    uint32_t bitIndex = position % 32;
    
    // need to and the word with the opposite of bit mask
    uint32_t mask = 1U << bitIndex;
    bitmap[wordIndex] &= ~mask; 
}

struct wfs_inode *retrieve_inode(int inum) {
    //(void)inum;
    /* TODO:
     * Use superblock fields (i_blocks_ptr, BLOCK_SIZE stride) to compute a pointer to inode 'inum
     * Also validate 'inum' via the inode bitmap before returning. */
    struct wfs_sb* sb = (struct wfs_sb*)mregion;
    
    // validate inum (inode number)
    if (inum < 0 || inum >= sb->num_inodes) {
        return NULL; 
    }

    // check if inode is allocated in bitmap 
    uint32_t *bitmap = (uint32_t*)((char*)mregion + sb->i_bitmap_ptr);
    uint32_t wordIndex = inum / 32;
    uint32_t bitIndex = inum % 32;

    // check that inode is allocated (bit is not set)
    if (!((bitmap[wordIndex] >> bitIndex) & 1)) {
        return NULL; // inode not allocated
    }

    // calculate address
    off_t inode_offset = sb->i_blocks_ptr + (inum * BLOCK_SIZE);
    return (struct wfs_inode*)((char*)mregion + inode_offset);
}

ssize_t allocate_block(uint32_t* bitmap, size_t len) {
    // loop through 32 bit word in the bitmap 
    for (uint32_t i = 0; i < len; i++) {
        uint32_t bm_region = bitmap[i];
        // check if all blocks are used 
        if (bm_region == 0xFFFFFFFF) {
            continue;
        }
        // check each bit in this word 
        for (uint32_t k = 0; k < 32; k++) {
            if (!((bm_region >> k) & 0x1)) { // it is free
                // allocate
                bitmap[i] = bitmap[i] | (0x1 << k);
                return 32*i + k;
                //return block_region + (BLOCK_SIZE * (32*i + k));
            }
        }
    }
    return -1; // no free blocks found
}

struct wfs_inode *allocate_inode(void) {
    /* TODO: Allocate an inode slot by marking the inode bitmap and return a
     * pointer to the inode block within the mapped image (or NULL on failure). */
    // get super block and inode bitmap 
    struct wfs_sb* sb = (struct wfs_sb*)mregion;
    uint32_t * ibitmap =  (uint32_t*)((char*)mregion + sb->i_bitmap_ptr);

    // allocate block for this inode 
    ssize_t inum = allocate_block(ibitmap, sb->num_inodes / 32);
    if (inum < 0) {
        // failure 
        wfs_error = -ENOSPC;
        return NULL; 
    }

    // get pointer to inode
    off_t offset = sb->i_blocks_ptr + (inum * BLOCK_SIZE);
    struct wfs_inode* inode = (struct wfs_inode*)((char*)mregion + offset);

    // zero out 
    memset(inode, 0, BLOCK_SIZE);
    // set num
    inode-> num = inum; 

    return inode;
}

off_t allocate_data_block(void) {
    /* TODO: Use the data bitmap to allocate a free data block and return its
     * on-disk byte OFFSET. Handle error appropriately. */
    // get superblock and data bitmap 
    struct wfs_sb* sb = (struct wfs_sb*)mregion;
    uint32_t* databitmap = (uint32_t*)((char*)mregion + sb->d_bitmap_ptr);

    // allocate the block 
    ssize_t blocknum = allocate_block(databitmap, sb->num_data_blocks / 32);

    // error checking: invalid block number 
    if (blocknum < 0) {
        wfs_error = -ENOSPC; 
        return -1; 
    }

    // calculate offset  
    off_t offset = sb->d_blocks_ptr + (blocknum * BLOCK_SIZE);
    
    // zero out blocks
    memset((char*)mregion + offset, 0, BLOCK_SIZE);

    // return the offset 
    return offset;
}

void free_inode(struct wfs_inode *inode) {
    // error checking: inode exists
    if (!inode) {
        return; // do nothing
    }
    /* TODO: Clear the inode bitmap entry and zero the inode block. */

    struct wfs_sb *sb = (struct wfs_sb*)mregion;
    uint32_t *bitmap =  (uint32_t*)((char*)mregion + sb->i_bitmap_ptr);
    
    // clear the bitmap
    free_bitmap(inode->num, bitmap);

    // zero the inode block 
    memset(inode, 0, BLOCK_SIZE);
}

void free_block(off_t blk_offset) {
    /* TODO: Mark the data block free in the data bitmap and zero it. */
    struct wfs_sb *sb = (struct wfs_sb*)mregion;

    // calculate block number from the offset
    off_t blocknum = (blk_offset - sb->d_blocks_ptr) / BLOCK_SIZE;

    // get data bitmap and free it 
    uint32_t* dbitmap = (uint32_t*)((char*)mregion + sb->d_bitmap_ptr);
    free_bitmap(blocknum, dbitmap);

    // zero out the block 
    memset((char*)mregion + blk_offset, 0, BLOCK_SIZE);
}

/* Return pointer to file offset; alloc if requested. Supports direct + single indirect. */
char *data_offset(struct wfs_inode *inode, off_t offset, int alloc) {
   // (void)inode; (void)offset; (void)alloc;
    /*
    - Translate a file byte offset into a location within the on-disk storage.
    - Support the inode’s addressing model (direct blocks plus a single level of indirection).
    - Enforce capacity limits and report errors appropriately.
    - Optionally provision storage for missing pieces when requested.
    - Return a pointer into the mapped image at the resolved location within a block.
    */
    //wfs_error = -ENOSPC;
    // error checking: invalid inode 
    if (!inode) {
        wfs_error = -EINVAL;
        return NULL;
    }
    
    // calculate block index and offset 
    off_t blockIndex = offset / BLOCK_SIZE;
    off_t blockOffset = offset % BLOCK_SIZE;
    
    off_t currOffset = 0;
    
    // direct blocks: 0 to N_BLOCKS-2
    if (blockIndex < N_BLOCKS - 1) {
        currOffset = inode->blocks[blockIndex];
        
        if (currOffset == 0 && alloc) {
            // allocate new direct block
            currOffset = allocate_data_block();
            if (currOffset < 0) {
                // error checking: invalid offset returned 
                wfs_error = -ENOSPC;
                return NULL;
            }
            inode->blocks[blockIndex] = currOffset;
        }
    } else {
        // indirect block: blocks[N_BLOCKS-1] points to indirect block
        off_t indirect_offset = inode->blocks[N_BLOCKS - 1];
        
        if (indirect_offset == 0) {
            if (!alloc) {
                wfs_error = -EINVAL;
                return NULL;
            }
            // allocate indirect block
            indirect_offset = allocate_data_block();
            if (indirect_offset < 0) {
                wfs_error = -ENOSPC;
                return NULL;
            }
            inode->blocks[N_BLOCKS - 1] = indirect_offset;
        }
        
        // need pointer to indirect block (array of off_t)
        off_t* indirect_block = (off_t*)((char*)mregion + indirect_offset);
        off_t indirect_idx = blockIndex - (N_BLOCKS - 1);
        
        // error checking: index is valid
        if (indirect_idx >= BLOCK_SIZE / sizeof(off_t)) {
            // file too large 
            wfs_error = -EFBIG; 
            return NULL;
        }
        
        currOffset = indirect_block[indirect_idx];
        
        if (currOffset == 0 && alloc) {
            // allocate new data block through indirect
            currOffset = allocate_data_block();
            if (currOffset < 0) {
                wfs_error = -ENOSPC;
                return NULL;
            }
            indirect_block[indirect_idx] = currOffset;
        }
    }
    
    // error checking 
    if (currOffset == 0) {
        wfs_error = -EINVAL;
        return NULL;
    }
    
    // return pointer into the mapped image
    return (char*)mregion + currOffset + blockOffset;
}

void fillin_inode(struct wfs_inode* inode, mode_t mode)
{
    inode->mode = mode;
    inode->uid = getuid();
    inode->gid = getgid();
    inode->size = 0;
    inode->nlinks = 1;
    memset(inode->blocks, 0, sizeof(inode->blocks));

    /* TODO PART 3: Initialize time fields to now. */
    inode->atim = time(NULL);
    inode->mtim = time(NULL);
    inode->ctim = time(NULL);
    /* TODO PART 4: Initialize color = none. */
    inode->color = WFS_COLOR_NONE;
}

int add_dentry(struct wfs_inode* parent, int num, char* name)
{
   /*TODO: insert dentry if there is an empty slot.
    We will not do indirect blocks with directories*/
    // error checking: no missing components 
    if (!parent || !name || !S_ISDIR(parent->mode)) {
        return -EINVAL;
    }

    // error checking: valid name length
    size_t length = strlen(name);
    if (length >= MAX_NAME || length == 0) {
        return -EINVAL;
    }

    // look existing entry or empty slot 
    off_t offset = 0;
    while (offset < parent->size) {
        char* pointer = data_offset(parent, offset, 0);

        if(!pointer) {
            break;
        }

        struct wfs_dentry* entry = (struct wfs_dentry*)pointer; 

        // check if entry exists
        if (entry->num != 0 && strcmp(entry->name, name) == 0) {
            return -EEXIST;
        }

        // found empty slot (num == 0)
        if (entry->num == 0) {
            entry->num = num;
            strncpy(entry->name, name, MAX_NAME -1);
            entry->name[MAX_NAME -1] = '\0';
            return 0; 
        }

        offset += sizeof(struct wfs_dentry); 
    }

    // need to add at the end, check if we need new block 
    char* pointer = data_offset(parent, offset, 1);
    if(!pointer) {
        return wfs_error;
    }

    // cast to entry and set name and num 
    struct wfs_dentry *entry = (struct wfs_dentry*)pointer;
    entry->num = num;
    strncpy(entry->name, name, MAX_NAME -1);
    entry->name[MAX_NAME -1] = '\0';

    // update size 
    parent->size += sizeof(struct wfs_dentry);

    // update time 
    time_t now = time(NULL);
    parent->mtim = now;
    parent->ctim = now;

    return 0;
}

int remove_dentry(struct wfs_inode *dir, int inum)
{
    /*TODO: Use inode 0 as a "deleted" inode. 
    So any directory entry could be marked as 0 to indicate it is deleted. 
    Removed dentries can result in "holes" in the dentry list, thus it is
    important to use the first available slot in add_dentry() */
    // error checking: missing component
    if(!dir || !S_ISDIR(dir->mode)) {
        return -EINVAL;
    }

    off_t offset = 0;
    // loop through all entries 
    while (offset < dir->size) {
        // get pointer to entry
        char* pointer = data_offset(dir, offset, 0);
        if(!pointer) {
            break;
        }

        // cast to entry
        struct wfs_dentry* entry = (struct wfs_dentry*)pointer;

        // check if num and inum of entry match
        if (entry->num == inum) {
            // mark as deleted
            entry->num = 0;
            memset(entry->name, 0, MAX_NAME);

            // update time 
            time_t now = time(NULL);
            dir->mtim = now;
            dir->ctim = now;

            return 0; 
        }
        // move to next entry
        offset += sizeof(struct wfs_dentry);
    }

    return -ENOENT;
}

/* --------------------------- FUSE Operations PART 1 ------------------------------ */

int wfs_getattr(const char *path, struct stat *st)
{
    
    struct wfs_inode *inode;

    char cleanPath[1024];
    strip_ansi_codes(path, cleanPath, sizeof(cleanPath));

    int ret = get_inode_from_path(cleanPath, &inode);
 
    
    if(ret < 0) 
    {
        return ret;
    }
    
    //0 out memory to avoid ghosts 
    memset(st, 0, sizeof(struct stat));

    st->st_mode = inode->mode;
    st->st_uid = inode->uid;
    st->st_gid = inode->gid;
    st->st_size = inode->size;
    st->st_ino = inode->num;
    st->st_blocks = (inode->size + BLOCK_SIZE -1) / BLOCK_SIZE;
    st->st_blksize = BLOCK_SIZE;

    //timestamps
    st->st_atime = inode->atim;
    st->st_mtime = inode->mtim;
    st->st_ctime = inode->ctim;

    return 0;
}
int wfs_mknod(const char *path, mode_t mode, dev_t dev)
{
    (void)dev; /* TODO */

    //split path into parent directory and file name
    char* dirCopy = strdup(path); //copy of file path to extract directory
    char* dirPath = dirname(dirCopy);
    char* fileCopy = strdup(path); //copy of file path to extract file name
    char* fileName = basename(fileCopy);

    //find parent dir inode
    struct wfs_inode *parent;
    int ret = get_inode_from_path(dirPath, &parent);
    if(ret < 0)
    {
        free(dirCopy);
        free(fileCopy);
        return ret;
    }
    
    //ensure that parent IS a directory
    if(!S_ISDIR(parent->mode))
    {
        free(dirCopy);
        free(fileCopy);
        return ENOTDIR;
    }

    //allocate new inode for file
    struct wfs_inode *fileInode = allocate_inode();
    if(!fileInode)
    {
        free(dirCopy);
        free(fileCopy);
        return wfs_error;
    }

    fillin_inode(fileInode, S_IFREG | mode); //initialize file's inode

    ret = add_dentry(parent, fileInode->num, fileName); //add an entry for this file to parent directory

    if(ret < 0)
    {
        free_inode(fileInode);
        free(dirCopy);
        free(fileCopy);
        return ret;
    }

    free(dirCopy);
    free(fileCopy);
    return 0;
}
int wfs_mkdir(const char *path, mode_t mode)
{ 
    //split path into parent directory and directory name
    char* parentCopy = strdup(path); //copy of file path to extract parent dir
    char* parentPath = dirname(parentCopy);
    char* dirCopy = strdup(path); //copy of file path to extract file name
    char* dirName = basename(dirCopy);
    
    //find parent dir inode
    struct wfs_inode *parent;
    int ret = get_inode_from_path(parentPath, &parent);
    if(ret < 0)
    {
        free(parentCopy);
        free(dirCopy);
        return ret;
    }
    
    //ensure that parent IS a directory
    if(!S_ISDIR(parent->mode))
    {
        free(parentCopy);
        free(dirCopy);
        return ENOTDIR;
    }

    //allocate new inode for directory
    struct wfs_inode *fileInode = allocate_inode();
    if(!fileInode)
    {
        free(dirCopy);
        free(parentCopy);
        return wfs_error;
    }

    fillin_inode(fileInode, S_IFDIR | mode); //initialize directory's inode

    //add entry to parent directory
    ret = add_dentry(parent, fileInode->num, dirName);

    if(ret < 0)
    {
        free_inode(fileInode);
        free(dirCopy);
        free(parentCopy);
        return ret;
    }

    free(dirCopy);
    free(parentCopy);
    return 0;
}
int wfs_read(const char *path, char *buf, size_t len, off_t off, struct fuse_file_info *fi)
{
    (void)fi; /* TODO */

    //find inode from path

    char cleanPath[1024];
    strip_ansi_codes(path, cleanPath, sizeof(cleanPath));

    struct wfs_inode *inode;
    int ret = get_inode_from_path(cleanPath, &inode);
    if(ret < 0) 
    {
        return ret;
    }

    //ensure this inode is a REGULAR FILE
    if(!S_ISREG(inode->mode)) 
    {
        return EISDIR;
    }

    if(off >= inode->size) 
    {
        return 0;
    }

    if(off + len > inode->size)
    {
        len = inode->size - off;
    }

    size_t bytesRead = 0;
    while(bytesRead < len)
    {
        char* ptr = data_offset(inode, off + bytesRead, 0);
        if(!ptr) 
        {
            break;
        }

        //find how much is left to read
        size_t toRead = BLOCK_SIZE - ((off + bytesRead) % BLOCK_SIZE);
        if(toRead > len - bytesRead)
        {
            toRead = len - bytesRead;
        }

        //copy to buffer
        memcpy(buf + bytesRead, ptr, toRead);

        //update number of bytes read
        bytesRead += toRead;
    }

    //update access time
    if(bytesRead > 0)
    {
        inode->atim = time(NULL);
    }
    return bytesRead;
}
int wfs_write(const char *path, const char *buf, size_t len, off_t off, struct fuse_file_info *fi)
{
    (void)fi; /* TODO */

    char cleanPath[1024];
    strip_ansi_codes(path, cleanPath, sizeof(cleanPath));

    //find inode from path
    struct wfs_inode *inode;
    int ret = get_inode_from_path(cleanPath, &inode);
    if(ret < 0) 
    {
        return ret;
    }

    if(!S_ISREG(inode->mode)) 
    {
        return EISDIR;
    }

    size_t bytesWritten = 0;

    //write
    while(bytesWritten < len)
    {
        char *ptr = data_offset(inode, off + bytesWritten, 1);
        if(!ptr)
        {
            return wfs_error;
        }

        //calculate how much left to write
        size_t toWrite = BLOCK_SIZE - ((off + bytesWritten) % BLOCK_SIZE);
        if(toWrite > len - bytesWritten)
        {
            toWrite = len - bytesWritten;
        }

        memcpy(ptr, buf + bytesWritten, toWrite);
        bytesWritten += toWrite;
    }

    if(off + bytesWritten > inode->size)
    {
        inode->size = off + bytesWritten;
    }

    //update modification and change time
    if(bytesWritten > 0)
    {
        time_t now = time(NULL);
        inode->mtim = now;
        inode->ctim = now;
    }

    return bytesWritten;
}
int wfs_readdir(const char *path, void *buf, fuse_fill_dir_t filler, off_t off, struct fuse_file_info *fi)
{
    (void)off;
    (void)fi;

    // ADDED: clean path
    char cleanPath[1024];
    strip_ansi_codes(path, cleanPath, sizeof(cleanPath));

    //get inode for this directory
    struct wfs_inode *dirInode;  // 

    int ret = get_inode_from_path(cleanPath, &dirInode);
    if(ret < 0) 
    {
        return ret;
    }

    //make sure this is a DIRECTORY
    if(!S_ISDIR(dirInode->mode)) 
    {
        return -ENOTDIR;
    }

    // ADDED: check if caller is ls 
    int is_ls = 0;
    struct fuse_context * context = fuse_get_context();
    if (context) {
        char proc[64];
        snprintf(proc, sizeof(proc), "/proc/%d/comm", context->pid);

        int fd = open(proc, O_RDONLY);
        if (fd >= 0) {
            char comm[32];
            ssize_t n = read(fd, comm, sizeof(comm) - 1);
            close(fd);
            
            if (n > 0) {
                comm[n] = '\0';
                // remove newline and replace with terminating char
                if (comm[n-1] == '\n') {
                    comm[n-1] = '\0';
                }
                is_ls = (strcmp(comm, "ls") == 0);
            }
        }
    }

    //add the self and parent directory representation
    filler(buf, ".", NULL, 0);
    filler(buf, "..", NULL, 0);

    off_t offset = 0;

    while(offset < dirInode->size)  
    {
        char *ptr = data_offset(dirInode, offset, 0);  
        if(!ptr) 
        {
            break;
        }

        struct wfs_dentry *entry = (struct wfs_dentry*)ptr;

        //only non deleted entries
        if(entry->num != 0)
        {
            // get child inode 
            struct wfs_inode *child_inode = retrieve_inode(entry->num);  

            // check if we need to color 
            if (is_ls && child_inode && child_inode->color != WFS_COLOR_NONE) {
                // decorate the name with color codes for ls
                const wfs_color_info *info = wfs_color_from_code(child_inode->color);

                char colored[MAX_NAME + 32];  
                snprintf(colored, sizeof(colored), "%s%s\033[0m", 
                         info->ansi, entry->name);
                filler(buf, colored, NULL, 0);
            } else {
                // for not colored files 
                filler(buf, entry->name, NULL, 0);
            }
        }
        offset += sizeof(struct wfs_dentry);
    }

    //update access time
    dirInode->atim = time(NULL);

    return 0;
}


int wfs_unlink(const char *path)
{ 
    //split path into parent directory and file name
    char* dirCopy = strdup(path); //copy of file path to extract directory
    char* dirPath = dirname(dirCopy);

    //get file inode
    struct wfs_inode *inode;
    int ret = get_inode_from_path((char*)path, &inode);
    if(ret < 0)
    {
        free(dirCopy);
        return ret;
    }

    //make sure this is a  REGULAR FILE
    if(!S_ISREG(inode->mode))
    {
        free(dirCopy);
        return EISDIR;
    }

    //save the inode number
    int inodeNum = inode->num;

    //get parent directory
    struct wfs_inode *parent;
    ret = get_inode_from_path(dirPath, &parent);
    if(ret < 0)
    {
        free(dirCopy);
        return ret;
    }

    //remove this entry from the directory --> DELETE
    remove_dentry(parent, inodeNum);

    inode->nlinks--; //decrement link count

    //check if more links. if no, free inode
    if(inode->nlinks == 0)
    {
        //free data blocks
        for(int i = 0; i < N_BLOCKS - 1; i++)
        {
            if(inode->blocks[i] != 0)
            {
                free_block(inode->blocks[i]);
            }
        }

        //free indirect block
        if(inode->blocks[N_BLOCKS-1] != 0)
        {
            off_t *indirect = (off_t*) ((char*)mregion + inode->blocks[N_BLOCKS-1]);
            for(size_t i = 0; i < BLOCK_SIZE / sizeof(off_t); i++)
            {
                if(indirect[i] != 0)
                {
                   free_block(indirect[i]);
                }
            }
            free_block(inode->blocks[N_BLOCKS - 1]);
        }
        free_inode(inode);
    }
    
    free(dirCopy);
    return 0;
}
int wfs_rmdir(const char *path)
{ 
    //get inode from path
    struct wfs_inode* inode;
    int ret = get_inode_from_path((char*)path, &inode);
    if (ret < 0) 
    {
        return ret;
    }
    
    //ensure that parent IS a directory
    if(!S_ISDIR(inode->mode))
    {
        return ENOTDIR;
    }

    //check that directory is empty
    off_t offset = 0;
    while(offset < inode->size)
    {
        char* ptr = data_offset(inode, offset, 0);
        if(!ptr) 
        {
            break;
        }

        struct wfs_dentry *entry = (struct wfs_dentry*)ptr;

        //make sure this directory is empty before deleting
        if(entry->num != 0)
        {
            return ENOTEMPTY;
        }
        offset += sizeof(struct wfs_dentry);
    }
    //save inode number
    int inodeNum = inode->num;

    //get parent directory
    char* pathCopy = strdup(path);
    char* parentPath = dirname(pathCopy);
    
    struct wfs_inode* parent;
    ret = get_inode_from_path(parentPath, &parent);
    free(pathCopy);
    
    if (ret < 0) 
    {
        return ret;
    }

    ret = remove_dentry(parent, inodeNum);

    if (ret < 0) {
        return ret;
    }

    //free directory data blocks
    for(int i = 0; i < N_BLOCKS; i++)
    {
        if(inode->blocks[i] != 0)
        {
            free_block(inode->blocks[i]);
        }
    }

    free_inode(inode);
   
    return 0;
}

/* TODO PART 2: statfs implementation */
int wfs_statfs(const char *path, struct statvfs *st)
{
    // get superblock 
    struct wfs_sb *sb = (struct wfs_sb*)mregion;

    // get bitmaps
    uint32_t *ibitmap = (uint32_t *)((char*)mregion +sb->i_bitmap_ptr);
    uint32_t *dbitmap = (uint32_t *)((char*)mregion +sb->d_bitmap_ptr);

    // count free inodes
    uint32_t freeInodes = 0;
    for (uint32_t i = 0; i < sb->num_inodes / 32; i++) {
        uint32_t word = ibitmap[i];
        // count the number of 0 bits
        for (uint32_t bit = 0; bit < 32; bit++) {
            if (!((word >> bit) & 0x1)) {
                freeInodes ++; 
            }
        }
    }

    // count free blocks 
    uint32_t freeDatablocks = 0; 
    for (uint32_t i = 0; i < sb->num_data_blocks / 32; i++) {
        uint32_t word = dbitmap[i];
        // count the number of 0 bits
        for (uint32_t bit = 0; bit < 32; bit++) {
            if (!((word >> bit) & 0x1)) {
                freeDatablocks ++; 
            }
        }
    }

    // filling int he fields (from man pages )
    st->f_bsize = BLOCK_SIZE;           // Filesystem block size
    st->f_frsize = BLOCK_SIZE;          // Fragment size
    st->f_blocks = sb->num_data_blocks; // Size of fs in f_frsize units
    st->f_bfree = freeDatablocks;          // Number of free blocks
    st->f_bavail = freeDatablocks;         // Free blocks available to unprivleged users
    st->f_files = sb->num_inodes;       // Number of inodes
    st->f_ffree = freeInodes;          // Number of free inodes
    st->f_favail = freeInodes;         // Number of free inodes for unprivileged users
    // f_fsid  don't need
    // f_flag  don't need 
    st->f_namemax = MAX_NAME - 1;       // Maximum filename length

    return 0;
}

/* TODO PART 3: ensure time updates in read/write/readdir/add/remove operations
Atime: successful read of file data or directory list;
Mtime/Ctime: upon content/metadata change */

/* TODO PART 4: xattr user.color + colored names when process name == "ls" */
int wfs_setxattr(const char *path, const char *name, const char *value, size_t size, int flags)
{
    // error checking: not user color 
    if (strcmp(name, "user.color") != 0) {
        return -ENOTSUP;
    }

    // clean path from ansi codes
    char cleanPath[1024];
    strip_ansi_codes(path, cleanPath, sizeof(cleanPath));

    // get inode 
    struct wfs_inode *inode;
    int returnValue = get_inode_from_path(cleanPath, &inode);
    // error checking: get inode from path return value
    if (returnValue != 0) {
        return returnValue;
    }

    // parse color name, might need to add null terminator 
    char colorName[32];
    size_t length;
    // length is min of size and color name 
    if (size < sizeof(colorName) -1) {
        length = size;
    } else {
        length = sizeof(colorName) -1; 
    }
    // safe copy
    memcpy(colorName, value, length);
    // add terminating char
    colorName[length] = '\0'; 

    // get color code
    uint8_t colorCode;
    if (!parse_color_name(colorName, &colorCode)) {
        return -EINVAL;
    }

    // handle the flags 
    if (flags & 1) {
        // cannot create if color != none
        if (inode->color != WFS_COLOR_NONE) {
            return -EEXIST;
        }
    }
    if(flags & 2) {
        // cannot replace is color is currently none 
        if (inode->color == WFS_COLOR_NONE) {
            return -ENODATA;
        }
    }
    
    // set color code
    inode->color = colorCode;

    // update time 
    inode->ctim = time(NULL);

    return 0;
}


int wfs_getxattr(const char *path, const char *name, char *value, size_t size)
{
    // error checking: user.color
    if (strcmp(name, "user.color") != 0) {
        return -ENOTSUP;
    }

    // clean the path 
    char cleanPath[1024];
    strip_ansi_codes(path, cleanPath, sizeof(cleanPath));

    // get inode
    struct wfs_inode *inode;
    int returnValue = get_inode_from_path(cleanPath, &inode);
    // error checking: get inode from path return value
    if (returnValue != 0) {
        return returnValue;
    }

    

    // get color info
    const wfs_color_info *info = wfs_color_from_code(inode->color);
    // get name 
    const char *plainName = info->name;
    size_t nameLength = strlen(plainName);
    
    // check size
    if (size == 0) {
        return nameLength; 
    }
    if (size < nameLength + 1) {
        return -ERANGE;
    }

    // copy plain name to value
    strcpy(value, plainName);

    return nameLength;
}


int wfs_removexattr(const char *path, const char *name)
{
    // error checking: user.color
    if(strcmp(name, "user.color") != 0) {
        return -ENOTSUP;
    }

    // clean path 
    char cleanPath[1024];
    strip_ansi_codes(path, cleanPath, sizeof(cleanPath));

    // get the inode
    struct wfs_inode *inode;
    int returnValue = get_inode_from_path(cleanPath, &inode);
    // error checking: get inode from path return value
    if (returnValue != 0) {
        return returnValue;
    }

    // check if color is currently set
    if(inode->color == WFS_COLOR_NONE) {
        return -ENODATA;
    }

    // remove the color
    inode->color = WFS_COLOR_NONE;

    // update ctime
    inode->ctim = time(NULL);

    return 0;
}

static struct fuse_operations wfs_ops = {
    .getattr = wfs_getattr,
    .mknod = wfs_mknod,
    .mkdir = wfs_mkdir,
    .read = wfs_read,
    .write = wfs_write,
    .readdir = wfs_readdir,
    .unlink = wfs_unlink,
    .rmdir = wfs_rmdir,
    .statfs = wfs_statfs,
    .setxattr = wfs_setxattr,
    .getxattr = wfs_getxattr,
    .removexattr = wfs_removexattr,
};

/* ------------------------------ Mount Entry ------------------------------- */
int main(int argc, char *argv[])
{
    int fuse_stat;
    struct stat sb;
    int fd;
    char* diskimage = strdup(argv[1]);

    // shift args down by one for fuse
    for (int i = 2; i < argc; i++) {
        argv[i-1] = argv[i];
    }
    argc -= 1;

    // open the file
    if ((fd = open(diskimage, O_RDWR, 0666)) < 0) {
        perror("open failed main\n");
        return 1;
    }

    // stat so we know how large the mmap needs to be
    if (fstat(fd, &sb) < 0) {
        perror("stat");
        return 1;
    }

    // setup mmap
    mregion = mmap(NULL, sb.st_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if (mregion == NULL) {
        printf("error mmaping file\n");
        return 1;
    }

    assert(retrieve_inode(0) != NULL);
    fuse_stat = fuse_main(argc, argv, &wfs_ops, NULL);

    munmap(mregion, sb.st_size);
    close(fd);
    return fuse_stat;
}
