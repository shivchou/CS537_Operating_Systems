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
  volatile uint* vaddr_dpu2 = (volatile uint*)iomap(DPU_Base2, DPU_Size2);
  volatile uint* vaddr_ssd = (volatile uint*)iomap(SSD_Base, SSD_Size);
  
  uint length = 128;
  uint addr1 = 8192;
  uint addr2 = 8320;
  ssd_dma_read(vaddr_ssd, (ssd_dma_desc){addr1, 0x1E000000, length, 0x1E400000, vaddr_hp2});
  ssd_dma_read(vaddr_ssd, (ssd_dma_desc){addr2, 0x1E001000, length, 0x1E400000, vaddr_hp2});

  for (int i=0; i<length; i++)
  {
    vaddr_dpu2[0x1000/sizeof(int)+i] = vaddr_hp1[i];
    vaddr_dpu2[0x2000/sizeof(int)+i] = vaddr_hp1[i+1024];
  }
  uint vector_value = dpu_vector(vaddr_dpu1, length, 0x1000, 0x2000, 0x1E400000, vaddr_hp2);

  printf(1, "XV6_TEST: %d\n", vector_value);
  
  exit();
}
