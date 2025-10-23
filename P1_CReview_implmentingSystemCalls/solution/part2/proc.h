// Per-CPU state
struct cpu {
  uchar apicid;                // Local APIC ID
  struct context *scheduler;   // swtch() here to enter scheduler
  struct taskstate ts;         // Used by x86 to find stack for interrupt
  struct segdesc gdt[NSEGS];   // x86 global descriptor table
  volatile uint started;       // Has the CPU started?
  int ncli;                    // Depth of pushcli nesting.
  int intena;                  // Were interrupts enabled before pushcli?
  struct proc *proc;           // The process running on this cpu or null
};

extern struct cpu cpus[NCPU];
extern int ncpu;

//PAGEBREAK: 17
// Saved registers for kernel context switches.
// Don't need to save all the segment registers (%cs, etc),
// because they are constant across kernel contexts.
// Don't need to save %eax, %ecx, %edx, because the
// x86 convention is that the caller has saved them.
// Contexts are stored at the bottom of the stack they
// describe; the stack pointer is the address of the context.
// The layout of the context matches the layout of the stack in swtch.S
// at the "Switch stacks" comment. Switch doesn't save eip explicitly,
// but it is on the stack and allocproc() manipulates it.
struct context {
  uint edi;
  uint esi;
  uint ebx;
  uint ebp;
  uint eip;
};

enum procstate { UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

#define MAX 128
// Per-process state
struct proc {
  uint sz;                     // Size of process memory (bytes) [data, heap, stack, code]
  pde_t* pgdir;                // Page table [map virtual --> physical mem]
  //manage address space

  char *kstack;                // Bottom of kernel stack for this process 
  enum procstate state;        // Process state
  int pid;                     // Process ID
  struct proc *parent;         // Parent process
  struct trapframe *tf;        // Trap frame for current syscall [return to user space]
  struct context *context;     // swtch() here to run process [registers needed by scheduler to SWITCH processes]
  //kstack, tf, context: manage context switching and kernel execution
  
  void *chan;                  // If non-zero, sleeping on chan [what is the process waiting for?]
  //chan + state: manage sleeping processes
  
  int killed;                  // If non-zero, have been killed [check during sys calls to terminate process]
  
  struct file *ofile[NOFILE];  // Open files 
  struct inode *cwd;           // Current directory !!!
  //used for file management

  char name[16];               // Process name (debugging)

  char cwdName[MAX]; //char array (string) for name of working directory
};

// Process memory is laid out contiguously, low addresses first:
//   text
//   original data and bss
//   fixed-size stack
//   expandable heap
