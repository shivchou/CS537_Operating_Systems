#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

#define IO_addralign_Error 	"XV6_TEST: IO Mapping Physical Address is not aligned to 4KB!\n"
#define IO_sizealign_Error	"XV6_TEST: IO Mapping size is not aligned to 4KB!\n"
#define IO_addrspace_Error	"XV6_TEST: IO Mapping Physical Address is not within device space!\n"
#define IO_userspace_Error	"XV6_TEST: IO Mapping Virtual Address exceeds user space!\n"
#define HP_addralign_Error 	"XV6_TEST: HP Mapping Physical Address is not aligned to 4MB!\n"
#define HP_sizealign_Error	"XV6_TEST: HP Mapping size is not aligned to 4MB!\n"
#define HP_addrspace_Error	"XV6_TEST: HP Mapping Physical Address is not within huge page space!\n"
#define HP_userspace_Error	"XV6_TEST: HP Mapping Virtual Address exceeds user space!\n"

int
sys_iomap(void)
{
  // Task 1
  uint paddr; // physical address
  uint size; // size
  uint vaddr; // virtual address 

  struct proc *currproc = myproc(); // current process

  // error checking: paddr and size cannot be negative  
  if(argint(0, (int*)&paddr) < 0) {
    return -1;
  }
  if(argint(1, (int*)&size) < 0) {
    return -1; 
  }

  // error checking: paddr has to be aligned to 4KB
  if(paddr % PGSIZE != 0) {
    cprintf(IO_addralign_Error);
    return -1; 
  }

  // error checking: size must be aligned to 4KB
  if(size % PGSIZE != 0) {
    cprintf(IO_sizealign_Error);
    return -1; 
  }

  // error checking: paddr not in device space
  if(!(paddr >= DEVSPACE)) {
    cprintf(IO_addrspace_Error);
    return -1; 
  }

  // allocate VA in user space starting from current  process size
  vaddr = PGROUNDUP(currproc->sz);

  // error checking: vaddr total space (vaddr + size) cannot exceed user space
  // in other words, cannot be in the kernel space
  if ((vaddr + size) > KERNBASE) {
    cprintf(IO_userspace_Error);
    return -1;
  }

  // map physical pages to virtual pages 
  // flags needed: 
  // PTE_W: io needs to write 
  // PTE_U: need to map to user space
  // PTE_PWT
  // PTE_PCD
  // PTE_DEV: need to map devices 
  if(mappages(currproc->pgdir, (char*)vaddr, size, paddr, PTE_W | PTE_U | PTE_PWT | PTE_PCD | PTE_DEV) == -1) {  
    return -1;
  }

  // map pages returned a valid result
  // update the process size
  currproc->sz = vaddr + size; 

  // flush TLB
  lcr3(V2P(currproc->pgdir));
  
  return vaddr;
}

int
sys_hpmap(void)
{
  uint paddr;
  uint size;
  uint vaddr;

  struct proc *currproc = myproc();

  // get arguments, check that they exist 
  if (argint(0, (int*)&paddr) < 0) {
    return -1;
  } 
  if (argint(1, (int*)&size) < 0) {
    return -1;
  }
    

  // error checking: p addr not aligned 
  if (paddr % (1 << PDXSHIFT) != 0) {
    cprintf(HP_addralign_Error);
    return -1;
  }

  // error checking: size not aligned 
  if (size % (1 << PDXSHIFT) != 0) {
    cprintf(HP_sizealign_Error);
    return -1;
  }

  // physical address not within huge page space
  if (paddr < HUGE_PAGE_START || paddr >= HUGE_PAGE_END) {
    cprintf(HP_addrspace_Error);
    return -1;
  }

  // pick next aligned virtual address (aligned to huge page)
  vaddr = HPROUNDUP(currproc->sz);

  // error checking: not in user space 
  if (vaddr + size > KERNBASE) {
    cprintf(HP_userspace_Error);
    return -1;
  }

  // check that mapping returns valid 
  // write and user flags 
  if (hpmappages(currproc->pgdir, (char*)vaddr, size, paddr, PTE_W | PTE_U) < 0)
    return -1;

  currproc->sz = vaddr + size;

  // flush TLB
  lcr3(V2P(currproc->pgdir));

  return vaddr;
}

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

extern void DPU_loop(void);

int
sys_dpu(void)
{
  DPU_loop();
  return 0;
}

extern void SSD_loop(void);

int
sys_ssd(void)
{
  SSD_loop();
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

