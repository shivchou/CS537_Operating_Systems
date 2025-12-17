#include "types.h"
#include "stat.h"
#include "user.h"
#include "dma.h"
#include "task.h"
#include "memlayout.h"

int
main(int argc, char **argv)
{
  volatile uint* vaddr_hp1 = (volatile uint*)hpmap(0x1E000000, 4*1024*1024);
  volatile uint* vaddr_hp2 = (volatile uint*)hpmap(0x1E400000, 4*1024*1024);
  volatile uint* vaddr_ssd = (volatile uint*)iomap(SSD_Base, SSD_Size);
  
  uint addr = 819204;
  uint length = 64;
  ssd_dma_read(vaddr_ssd, (ssd_dma_desc){addr, 0x1E000000, length, 0x1E400000, vaddr_hp2});
  printf(1, "XV6_TEST: %d %d %d %d %d %d %d %d\n", vaddr_hp1[0], vaddr_hp1[1], vaddr_hp1[2], vaddr_hp1[3], vaddr_hp1[4], vaddr_hp1[5], vaddr_hp1[6], vaddr_hp1[7]);
  
  exit();
}

