#include "types.h"
#include "stat.h"
#include "user.h"
#include "memlayout.h"

int
main(int argc, char **argv)
{
  volatile uint* vaddr_ssd = (volatile uint*)iomap(SSD_Base, SSD_Size);

  volatile char* t = (char*)((uint)vaddr_ssd);
  char info[40];
  for (int i = 0; i< 40; i++)
  {
    info[i] = t[i];
  }
  printf(1, "XV6_TEST: %s\n", info);
  
  exit();
}

