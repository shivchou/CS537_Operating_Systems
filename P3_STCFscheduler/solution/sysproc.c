#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"


int
sys_fork(void)
{
  return fork();
}

int sys_clone(void)
{
  int fn, stack, arg;
  argint(0, &fn);
  argint(1, &stack);
  argint(2, &arg);
  return clone((void (*)(void*))fn, (void*)stack, (void*)arg);
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  if (n == 0) {
    yield();
    return 0;
  }
  acquire(&tickslock);
  ticks0 = ticks;
  myproc()->sleepticks = n;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  myproc()->sleepticks = -1;
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_remain(void)
{
  int new_time;

  if(argint(0, &new_time) < 0)
  {
    return -1;
  }

  return remain(new_time);
}

int
sys_exec2(void)
{
  int time_to_completion;
  char *path;
  uint uargv; // This holds the user-space address of the argv array
  char *argv[MAXARG];
  int i;
  uint uarg;

  // --- 1. CORRECTLY FETCH ARGUMENTS ---
  // arg 0: int, arg 1: string, arg 2: pointer (which is an int)
  if (argint(0, &time_to_completion) < 0 || 
      argstr(1, &path) < 0 || 
      argint(2, (int*)&uargv) < 0) {
    return -1;
  }

  // Basic validation
  if (time_to_completion <= 0) {
    return -1;
  }

  // --- 2. MOVE THE KERNEL LOGIC HERE ---
  struct proc *curproc = myproc();
  int old_completion_time = curproc->expectedComplete;

  // Set the new completion time
  curproc->expectedComplete = time_to_completion;

  // If the new time is larger, give another process a chance to run
  if (time_to_completion > old_completion_time) {
    yield();
  }
  
  // --- 3. PROCEED WITH THE ORIGINAL EXEC LOGIC ---
  // This part correctly fetches the string array for argv
  memset(argv, 0, sizeof(argv));
  for(i=0; ; i++){
    if(i >= NELEM(argv))
      return -1; // Too many arguments
    if(fetchint(uargv + 4*i, (int*)&uarg) < 0)
      return -1; // Failed to fetch a pointer from the argv array
    if(uarg == 0){
      argv[i] = 0; // End of array
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1; // Failed to fetch the argument string
  }

  // Finally, call the real exec implementation
  return exec(path, argv);
}

int
sys_give_cpu(void)
{
  return give_cpu();
}