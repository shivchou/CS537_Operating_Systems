#include "types.h"
#include "stat.h"
#include "user.h"

// Test give_cpu behavior under STCF. Create two children with different
// remaining times. The short job should run first; the long job will call
// give_cpu() to voluntarily give up the CPU and we check that the scheduler
// picks the other runnable process.

int
main(void)
{
  printf(1, "XV6_TEST: give_cpu test started\n");
  remain(300);
  int pid = fork();
  if (pid == 0) {
    remain(200);
    printf(1, "XV6_TEST: child started\n");
    spinwait(100);
    give_cpu(); //will be scheduled to the parent
    spinwait(100);
    printf(1, "XV6_TEST: child finished\n");
    exit();
  }

  // parent waits for both children
  printf(1, "XV6_TEST: scheduled to parent\n");
  wait();
  printf(1, "XV6_TEST: give_cpu test fin\n");
  exit();
}