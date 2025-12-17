#include "types.h"
#include "user.h"

uint dpu_hash(volatile uint *dpu_ctrl, uint x, uint key, uint poll_paddr, volatile uint *poll_vaddr)
{
    // Task 5
    // clear polling location
    *poll_vaddr = 0;

    // ensure polling clear is visible
    asm volatile("mfence" ::: "memory");

    // set input integer
    dpu_ctrl[12] = x;

    // set hash key
    dpu_ctrl[13] = key;

    // set host polling address for hash completion
    dpu_ctrl[14] = poll_paddr;

    // memory fence before starting operation
    asm volatile("mfence" ::: "memory");

    // set to 1 to start hash computing
    dpu_ctrl[11] = 1;

    // wait for completion, complete when poll is set to 1
    while (*poll_vaddr != 1)
    {
        asm volatile("pause" ::: "memory");
    }

    // ensure all operations complete
    asm volatile("mfence" ::: "memory");

    // hash value return
    return dpu_ctrl[15];
}

uint dpu_vector(volatile uint *dpu_ctrl, uint length, uint addr1, uint addr2, uint poll_paddr, volatile uint *poll_vaddr)
{
    // Task 5
    // clear polling location
    *poll_vaddr = 0;

    // ensure polling clear is visible
    asm volatile("mfence" ::: "memory");

    // set vector length
    dpu_ctrl[22] = length;

    // set vector 1 address in DPU memory
    dpu_ctrl[23] = addr1;

    // set vector 2 address in DPU memory
    dpu_ctrl[24] = addr2;

    // set host polling address for vector completion
    dpu_ctrl[25] = poll_paddr;

    asm volatile("mfence" ::: "memory");

    // set to 1 to start vector computing
    dpu_ctrl[21] = 1;

    // wait for completion, complete when 1 in poll addr
    while (*poll_vaddr != 1)
    {
        asm volatile("pause" ::: "memory");
    }

    // memory fence to ensure all operations complete
    asm volatile("mfence" ::: "memory");

    // vector value return 
    return dpu_ctrl[26];
}