#include "types.h"
#include "stat.h"
#include "user.h"
#include "memlayout.h"

int
main(int argc, char **argv)
{
  volatile uint* vaddr_ssd = 0;

  vaddr_ssd = (volatile uint*)iomap(SSD_Base, SSD_Size+1);

  if ((uint)vaddr_ssd == (-1))
    {
        printf(1, "XV6_TEST: MMIO fails!\n");
    }

  exit();
}

