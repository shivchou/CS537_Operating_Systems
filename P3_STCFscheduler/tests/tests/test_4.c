#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
  printf(1, "XV6_TEST: parent start\n");
  int pid[10];
  int remainarray[10] = {100,125,150,75,50,30,140,180,200,130};
  remain(10);
  for (int i = 0; i< 10;i++){
    if ((pid[i] = fork()) == 0) {
      remain(remainarray[i]);
      printf(1, "XV6_TEST: proc %d start\n", i);
      spinwait(remainarray[i]);
      printf(1, "XV6_TEST: proc %d end\n", i);
      exit();
    }
  }
  for (int i=0; i<10; i++){
      wait();
      give_cpu();
      }
  exit();
}