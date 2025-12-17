Task 3:

In this task, you will create a system call to map huge page physical address to user-space virtual address.

Before you perform the mapping, you should modify xv6 virtual memory to support mapping 4MB huge pages.

In vm.c, finish the function 
```c
int hpmappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
```
**Please be very careful with the PTE flags!**

Accordingly, modify function

```c
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
void freevm(pde_t *pgdir)
```

correspondingly to your huge page mapping implementation.

Hint: Compare the page directory of huge page and normal page, what should be changed in freevm()? In deallocuvm(), the huge pages are already reserved, not managed by xv6. Can you directly kfree() the reserved huge pages? What should you do now to clean the PDE?

Then in sysproc.c, finish the function 
```c
int sys_hpmap(void)
```
This function returns a huge page mapped virtual address given physical address input and mapping size. If there is an error, the function returns -1, and error information should be printed with given ```#define```. The mapped virtual address must not exceed user address space.

Requirement: The Physical Address and the Mapping Size must be checked if it's aligned to 4MB. The Physical Address must be within the huge page address space.

Tests: Test case 5-7 will check the error handling of your mapping function.

