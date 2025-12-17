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
  volatile uint* vaddr_dpu1 = (volatile uint*)iomap(DPU_Base1, DPU_Size1);
  volatile uint* vaddr_ssd = (volatile uint*)iomap(SSD_Base, SSD_Size);
  
  uint addr = 512;
  uint length = 4;
  ssd_dma_read(vaddr_ssd, (ssd_dma_desc){addr, 0x1E000000, length, 0x1E400000, vaddr_hp2});

  uint key = 12345;
  uint hash_value = dpu_hash(vaddr_dpu1, vaddr_hp1[0], key, 0x1E400000, vaddr_hp2);
  
  printf(1, "XV6_TEST: %d\n", hash_value);
  
  exit();
}
