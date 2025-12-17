Task 1:

In this task, you will create a system call to map IO physical address to user-space virtual address.

Complete the ```#define``` in memlayout.h file.

In sysproc.c, finish the function 
```c
int sys_iomap(void)
```
This function returns a mapped virtual address in user space given the physical address input and the mapping size. If there is an error, the function returns -1, and error information should be printed with given ```#define```.

In vm.c, you should also modify function ```int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)``` to support deallocation of your mapped virtual address.

You should manage the user space virtual memory correctly, and choose the correct PTE flags for your mappages().

Hint: You will use the function mappages() in vm.c file. You may use lcr3(V2P(p->pgdir)); to flush the TLB after you perform the mapping. A new PTE_DEV flag is defined in mmu.h for device space flag. Think about PTE flags more, what's the attributes of IO, when you should distinguish device page and use PTE_DEV, etc. Check mmu.h file for PGROUNDUP() and PGROUNDDOWN(). Where you should perform the ROUND function? For deallocuvm(), what does this function do? What is different for IO page when cleaning the page table?

Requirement: The Physical Address and the Mapping Size must be checked if it's aligned to 4KB. The Physical Address must be in the device address space. The mapped virtual address must not exceed user address space defined in xv6.

Tests: Test case 1-3 will check the error handling of your mapping function.

