# CS537 Fall 2025, Project 3
## Project Administration and Policies

> [!important]
>
> **Due date:** Tuesday, October 21th, 2025, 11:59 PM
>
> Follow all CS537 [project policies](Admin.md)

## Project Workflow

Your solution code will be tested in
the [CS537 Docker container](https://git.doit.wisc.edu/cdis/cs/courses/cs537/useful-resources/cs537-docker).
If you do not already have your container setup, follow the instructions in that repository to create the proper environment.
After following those instructions you should have a `cs537-projects/`
directory where you can clone **all** of the projects for this course.

--------------------------------------------------------------------------------


## Shortest Time-to-Completion First scheduling

In this project, you will implement the **Shortest Time-to-Completion First** scheduler in xv6.

The base xv6 system already includes a simple round-robin multiprocessor scheduler. Your job is to modify the scheduling policy to Shortest Time-to-Completion First.

Learning Objectives:

* Understand the implementation of the xv6 round-robin scheduler.

* Understand how the shortest job first scheduler works. 

* Learn how to add new system calls and modify kernel-level components like the scheduler and process state.

--- 

# Project Details

## Overview of the xv6 Round-Robin Scheduler

As you've learned in lecture, a round-robin scheduler iterates through the list of processes, giving each runnable process a "time quantum" to execute on a processor. This is implemented in xv6 within the `scheduler()` function in `proc.c`.

This `scheduler()` is called for each clock tick. You can find it in the trap handler for the timer interrupt in `trap.c`. It calls `yield()` to yield the CPU to the scheduler. 

In xv6, a maximum of `NPROC` processes can exist, and their corresponding process structures (`struct proc`) are stored in a global array called `ptable`. The scheduler on each CPU core independently runs a loop that scans this table for runnable processes to execute.

Here is the main loop from the `scheduler()` function:
```C

  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process. It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
  }
```

As the comments indicate, this infinite loop iterates over the `ptable`. When it finds a runnable process, it performs a context switch using `switchuvm()` and `swtch()`. `switchuvm()` handles switching the page table and task state segment, while `swtch()` saves the current context (the scheduler's) and restores the process's context, causing the process to resume execution.

You are encouraged to trace this code line by line to fully understand the context switch mechanism.

## Shortest Time-to-Completion First

As introduced in lectures, STCF scheduling is an SJF scheduler with preemption. When a new job is added to the system, the scheduler will calculate the remaining time of the current process and find the shortest job that can be run. This scheduler will give the best turnaround time. 

## Implementation

### Read this before you start coding
The scheduling policy is selected by setting `SCHEDULER=STCF` for the **STCF scheduler** or `SCHEDULER=RR` for the **round-robin scheduler** (default is `RR`) when you make a project. (ex: `make SCHEDULER=STCF qemu-nox`) You can check the current scheduler after booting xv6.

**You should not modify `ulib.c`, `trapasm.S`, `trap.c`, and `work.c`. These files will be overwritten with base files during grading.** You don't need any handler for each timer interrupt to finish this project.

**Try not to print to the console in your implementation.** Writing something in xv6 user mode involves calling `sleep`, which yields the CPU and can affect the scheduling order. I haven’t verified whether `cprintf` is safe yet. Use print statements only if you’re sure they won’t affect scheduling decisions. If you’re not sure, use GDB to debug your code instead.

**Make sure to clone inside docker, especially if you are using a Windows host.** As we've faced in previous projects, line endings can cause a problem. Especially xv6 produces **CRLF** even in linux. `.out` files in tests will have **CRLF** line endings, but this is expected. **Do not set `core.autocrlf` to `true` in git config.**

If you messed up line endings, please remove the `tests` folder and re-clone it from the base repository.

### Steps to implement
1. Implement `fork` to inherit the completion time.

    The **expected completion time** will be calculated based on the parent's completion time when a process calls `fork()`. The initial process's completion time is `0x7fffffff`, which is the maximum value of a signed 32-bit integer. You should save the value as a **signed integer**, not **unsigned**. After `fork()`, the completion time of the new process should **inherit** the parent's completion time. 

    After `fork()`, you should invoke the scheduler to schedule the next process, which will be the **child process**. The child process will have the same remaining time as its parent's expected completion time which is currently the shortest time to completion, and the child process will have larger pid than its parent.

    By default, xv6's process allocation **never** allocates a process with a previously used pid, and pid is always increasing. Based on this, we will use the pid with a **higher value** for **tie-breaking**. This is also mentioned below, when you implement the STCF scheduler.

2. Implement the `remain()` system call.
    ```c
    int remain(int new_time)
    ```

    The `remain` system call should change the current process's **completion time** to `new_time`. 
    `new_time` should be **greater than 0**. If not, do nothing and return **-1**.

    If `new_time` is larger than the current process's expected completion time, invoke the scheduler to determine if another process with a **smaller completion time** is available to run.

    If `new_time` is valid, return 0.

3. Implement the `exec2()` system call.
    ```c
    int exec2(int time_to_complete, char* file, char** argv);
    ```

    The `exec2` system call should change the **completion time** of the current process to `time_to_complete` and then `exec` the new program. 

    `time_to_complete` should be **greater than 0**. If not, do nothing and return **-1**.

    If `time_to_complete` is valid, return the result of the original `exec` system call.

    If `time_to_complete` is larger than the current process's expected completion time, invoke the scheduler to determine if another process with a **smaller completion time** is available to run.

    For the original `exec` system call, it should **keep the completion time**.

4. Manage completion time

    You should save the **scheduled time** of the process (the global `tick`) when the process `fork`s, `sleep`s, or `yield`s. In detail, you should save the time **just before** you call `swtch` to switch context. When a process is yielded, update its **expected completion time** by subtracting the number of global ticks that have passed since it was last scheduled. 

5. Implement the STCF scheduler

    Based on the saved completion time information, your scheduler should pick the job with the **shortest time to completion**.
    If there is a tie, execute the job with the **higher PID value** to promote execution of new jobs. 

    **Scheduling only occurs**:
    * when the **completion time** of the current process is changed by `remain`  or `exec2`
    * when the current process exits.
    * when a **new process** arrives by `fork` 
    * when the current process `yield`s.
 
6. Implement the `give_cpu()` system call
    ```c
    int give_cpu(void)
    ```
    It will yield the CPU and result in a context change. However, STCF will choose the same process again, since it has the shortest time to complete. Therefore, to ensure the CPU is relinquished, the scheduler must select a **different process** to run after a `give_cpu()` call. You should choose the next process to run **based on the STCF policy**, but skip the current process. If no other process is available, the same process can be scheduled again.
    
    This system call always return 0. From the process's perspective, it does nothing; it simply yields the CPU.

## Notes
* You can assume that only one CPU core is running xv6.
* You can assume that the number of processes will not exceed `NPROC`.

## Tips
* Please think before you code. This project is not about writing a lot of code, but about understanding the structure of xv6 operating system, the scheduling policy and how to implement it in xv6. For your information, the sample solution consists only about 100 lines of code changes in total.
* You might want to add a system call to monitor the completion time of a process for debugging. You can name it as `getremain()`, which will never be called in the tests and safely ignored during grading.
  * However, make sure it does not print anything to the console. Printing will call `sleep` implicitly and can change scheduling behavior.
  * `printf`s in the testcases are fine since they are called just before/after the scheduling. It will only consume few ticks (or none), and this few ticks will not affect the behavior of the test. 
* Tick in xv6 is incremented by 10ms. All the time granularity we are using in this project refers to this tick unit.
* You may use `spinwait` in `ulib.c` to simulate a workload. For example, `spinwait(100)` will spin for approximately 1 second (100 * 10ms).
* `spinwait` might not be perfectly aligned to 10ms. It might result a negative value of time to complete. You can safely treat it as normal behavior, since we are using signed integer to save the remaining time to complete. 
* I've added `workload1.c` and `workload2.c` so you can test them yourself. You may add `remain` or `exec2` system calls to see how it works. 