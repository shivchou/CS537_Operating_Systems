#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
  printf(1, "XV6_TEST: parent start\n");
  int pid[3];
  int remainarray[3] = {100,150,140};
  remain(10);
  for (int i = 0; i< 3;i++){
    if ((pid[i] = fork()) == 0) {
      remain(remainarray[i]);
      printf(1, "XV6_TEST: proc %d start\n", i);
      if (i == 0)
        give_cpu();
      spinwait(remainarray[i]);
      printf(1, "XV6_TEST: proc %d end\n", i);
      exit();
    }
  }
  for (int i=0; i<3; i++){
      wait();
      give_cpu();
      }
  exit();
}