// Memory layout

#define EXTMEM  0x100000            // Start of extended memory
#define PHYSTOP 0x20000000          // Top physical memory
#define DEVSPACE 0xFE000000         // Other devices are at high addresses

// Key addresses for address space layout (see kmap in vm.c for layout)
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#define V2P(a) (((uint) (a)) - KERNBASE)
#define P2V(a) ((void *)(((char *) (a)) + KERNBASE))

#define V2P_WO(x) ((x) - KERNBASE)    // same as V2P, but without casts
#define P2V_WO(x) ((x) + KERNBASE)    // same as P2V, but without casts

#define HUGE_PAGE_START 0x1E000000  // Start of reserved region - 480 MB
#define HUGE_PAGE_END   0x20000000  // End of reserved region - 512 MB

// Task 2
#define DPU_Base1 0xFE000000  // Region 0: Memory at 0xFE000000
#define DPU_Size1 0x00001000  // size=4K
#define DPU_Base2 0xFE080000  // 0xFE080000
#define DPU_Size2 0x00080000  // size=512K
#define SSD_Base  0xFE100000  // Region 0: Memory at 0xFE100000
#define SSD_Size  0x00001000  // size=4K