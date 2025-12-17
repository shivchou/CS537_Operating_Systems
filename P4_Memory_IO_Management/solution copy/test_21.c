#include "types.h"
#include "stat.h"
#include "user.h"
#include "dma.h"
#include "task.h"
#include "memlayout.h"

int
main(int argc, char **argv)
{
  // Map huge pages for buffers and polling
  volatile uint* vaddr_hp1 = (volatile uint*)hpmap(0x1E000000, 4*1024*1024);
  volatile uint* vaddr_hp2 = (volatile uint*)hpmap(0x1E400000, 4*1024*1024);
  volatile uint* vaddr_hp3 = (volatile uint*)hpmap(0x1E800000, 4*1024*1024);
  
  // Map SSD control region
  volatile uint* vaddr_ssd = (volatile uint*)iomap(SSD_Base, SSD_Size);
  
  // Write test data to first buffer
  vaddr_hp1[0] = 12345;
  vaddr_hp1[1] = 67890;
  vaddr_hp1[2] = 11111;
  vaddr_hp1[3] = 22222;
  
  uint device_addr = 786432;  // Address on SSD
  uint length = 16;  // 4 integers = 16 bytes
  
  // Write data from host buffer (hp1) to SSD
  // src should be device_addr, dst should be host buffer physical addr
  ssd_dma_write(vaddr_ssd, (ssd_dma_desc){device_addr, 0x1E000000, length, 0x1E400000, vaddr_hp2});
  printf(1, "XV6_TEST: Write completed\n");
  
  // Clear the third buffer to ensure we're reading fresh data
  vaddr_hp3[0] = 0;
  vaddr_hp3[1] = 0;
  vaddr_hp3[2] = 0;
  vaddr_hp3[3] = 0;
  
  // Read data back from SSD to third buffer
  // src should be device_addr, dst should be host buffer physical addr
  ssd_dma_read(vaddr_ssd, (ssd_dma_desc){device_addr, 0x1E800000, length, 0x1E400000, vaddr_hp2});
  printf(1, "XV6_TEST: Read completed\n");
  
  // Verify the data matches
  printf(1, "XV6_TEST: Expected %d, Got %d\n", vaddr_hp1[0], vaddr_hp3[0]);
  printf(1, "XV6_TEST: Expected %d, Got %d\n", vaddr_hp1[1], vaddr_hp3[1]);
  printf(1, "XV6_TEST: Expected %d, Got %d\n", vaddr_hp1[2], vaddr_hp3[2]);
  printf(1, "XV6_TEST: Expected %d, Got %d\n", vaddr_hp1[3], vaddr_hp3[3]);
  
  // Check if all values match
  if (vaddr_hp3[0] == 12345 && vaddr_hp3[1] == 67890 && 
      vaddr_hp3[2] == 11111 && vaddr_hp3[3] == 22222) {
    printf(1, "XV6_TEST: DMA read after write - PASSED\n");
  } else {
    printf(1, "XV6_TEST: DMA read after write - FAILED\n");
  }
  
  exit();
}