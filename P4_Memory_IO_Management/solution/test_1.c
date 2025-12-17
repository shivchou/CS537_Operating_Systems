#include "types.h"
#include "stat.h"
#include "user.h"
#include "memlayout.h"

int
main(int argc, char **argv)
{
  volatile uint* vaddr_ssd = 0;

  vaddr_ssd = (volatile uint*)iomap(SSD_Base+1, SSD_Size);

  if ((uint)vaddr_ssd == (-1))
    {
        printf(1, "XV6_TEST: IO Mapping fails!\n");
    }

  exit();
}

