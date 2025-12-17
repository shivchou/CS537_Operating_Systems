#include "types.h"
#include "stat.h"
#include "user.h"
#include "memlayout.h"

int
main(int argc, char **argv)
{
  volatile uint* vaddr_hp1 = 0;

  vaddr_hp1 = (volatile uint*)hpmap(0x21000000, 4*1024*1024);

  if ((uint)vaddr_hp1 == (-1))
    {
        printf(1, "XV6_TEST: Huge Page Mapping fails!\n");
    }

  exit();
}
