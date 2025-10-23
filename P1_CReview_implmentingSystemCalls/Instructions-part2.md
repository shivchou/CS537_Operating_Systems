---
title: CS 537 Project 2
layout: default
---

# CS537 Fall 2025, Project 1 Part 2 -- xv6 System Calls

## Updates
* TBD

## Learning Objectives

In this assignment, you will create a system call in xv6 which returns the name of the current working directory of the process.

* Understand the xv6 OS, a simple UNIX operating system.
* Learn to build and customize the xv6 OS
* Understand how system calls work in general
* Understand how to implement a new system call
* Understand how to pass information between a user program and the operating system and vice versa.
* Be able to navigate a larger codebase and find the information needed to make changes.


## Project Overview

In this project you will add a new system call to the xv6 operating system. More specifically, you will have to create a system call named getcwd (implemented in a kernel function called sys_getcwd) with the following signature:

`int getcwd(char * buf, int size)`

Where `buf` is a pointer to a character buffer and `size` is the size of the buffer.  The system call should populate the buffer with a null-character terminated string of the process's current working directory.

In addition, you will need to create an xv6 user program called `pwd`, that when called, prints the process's current working directory to the screen.

### Task 1: Download and Run xv6

The xv6 operating system is present inside `solution/part2` folder in your repository. This directory also contains instructions on how to get the operating system up and running in the `README.md` file.

- Simply use `git clone` to acquire a fresh copy of p1 and make your changes to the `solution/part2` folder as mentioned above and commit and push your changes to the main branch before the deadline.

You may find it helpful to go through some of these videos from earlier semesters:

1.  [Discussion video](https://www.youtube.com/watch?v=vR6z2QGcoo8&ab_channel=RemziArpaci-Dusseau) - Remzi Arpaci-Dusseau. 
2. [Discussion video](https://mediaspace.wisc.edu/media/Shivaram+Venkataraman-+Psychology105+1.30.2020+5.31.23PM/0_2ddzbo6a/150745971) - Shivaram Venkataraman.
3. [Some background on xv6 syscalls](https://github.com/remzi-arpacidusseau/ostep-projects/blob/master/initial-xv6/background.md) - Remzi Arpaci-Dusseau.

### Task 2: Modify the `proc` struct and the chdir() system call

You will need to modify the `proc` struct to hold the name of the current working directory.  The struct already has a field which holds a reference to the inode of the current working directory.  Typically, the directory tree would be walked from from the root inode to the current working directory inode to build the absolute path name.  Because we have not yet covered these concepts in the course, instead, your program should store the name "/" if the process is the first user process, store the same value as the parent process if a new process is forked (i.e. inhherit from the parent process), or store the value that is passed to the `chdir` system call whenever it is called.

You will have to find where in the code the first process is created, where a process is forked from another process, and where the `chdir` system call is implemented in order to make these changes.

### Task 3: Create the getcwd system call

You will have to add a new system call and modify the system call table and handler to contain the new call.

When getcwd() is called, the os code implementing the system call should receive the pointer to a character buffer and the size of that buffer and then populate it from the current working directory's name which is stored in the current process's proc struct.  To see an example of how arguments are passed into a system call and populated for the user program to use, you may want to look at the implementation of the `read` system call and then how it is called in the `usertests.c` program.


### Task 4: Add `pwd` user level program
#### Adding a user-level program to xv6

As an example we will add a new user level program called `test` to the xv6 operating system.

```
// test.c
{
  printf(1, "The process ID is: %d\n", getpid());
  exit();
}
```
    

Now we need to edit the Makefile so our program compiles and is included in the file system when we build xv6. Add the name of your program to `UPROGS` in the Makefile, following the format of the other entries.

Run `make qemu-nox` again and then run `test` in the xv6 shell. It should print the PID of the process.

You will need to write a new user-level program called `pwd` which prints the current working directory.

#### pwd

You will need to add a userprogram called `pwd` that effectively demonstrates the functionality of the getcwd system call.  The userlevel program should use a buffer of size 16, call the getcwd system call and print out what is returned.

## Project Details

*   Your project should (hopefully) pass the tests we supply.
*   **Your code will be tested in the CS537-Docker environment.**
*   Include a file called README.md describing the implementation in the solution directory. This file should include your name, your cs login, you wisc ID and email, and the status of your implementation. If it all works then just say that. If there are things which don't work, let us know. Please **list the names of all the files you changed in `solution/part2`**, with a brief description of what the change was. This will **not** be graded, so do not sweat it.
*   Please note that `solution/part2` already has a file called README, do not modify or delete this.  If you remove the xv6 README, it will cause compilation errors.

## Suggested Workflow
- Add a `getcwd` system call which returns some string constant.
- Create a user program (pwd.c) to call this system call and print the returned value.
- Modify the proc struct to hold a character array with some constant value and modify the getcwd system call to return this value.
- Make changes to OS so the proc struct holds the proper value for the first process and whenever a fork occurs.
- Modify the chdir system call to update the proc struct of the current working directory's name to the string that was passed to chdir (if it is a a valid change of directory).

## Notes and Hints
- Take a look at "sysfile.c" and "sysproc.c" to find tips on how to implement syscall logic. 
- `proc.c` and `proc.h` are files you can look into to get an understanding of how process related structs look like. You can use the proc struct to store information.
- It is important to remember that the flavour of C used in xv6 differs from the standard C library (stdlib.c) that you might be used to. For example, in the small userspace example shown above, notice that printf takes in an extra first argument(the file descriptor), which differs from the standard printf you might be used to. It is best to use `grep` to search around in xv6 source code files to familiarize yourself with how such functions work.
- `user.h` contains a list of system calls and userspace functions (defined in `ulib.c`) available to you, while in userspace. It is important to remember that these functions can't be used in kernelspace and it is left as an exercise for you to figure out what helper functions are necessary(if any) in the kernel for successful completion of this project.
- You will need to add a new system call, but also modify the chdir() system call to store changes to a process's current directory.
- To exit xv6 and the qemu virtual machine type `ctrl-a` and then `x`.
