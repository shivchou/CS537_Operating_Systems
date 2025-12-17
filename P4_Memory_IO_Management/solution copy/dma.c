#include "types.h"
#include "user.h"
#include "dma.h"

void ssd_dma_read(volatile uint *ssd_ctrl, ssd_dma_desc desc)
{
    // Task 4

    // clear polling location
    *(desc.poll_vaddr) = 0;

    // ensure polling clear is visible
    asm volatile("mfence" ::: "memory");

    ssd_ctrl[12] = desc.src; // set read device addr

    ssd_ctrl[13] = desc.dst; // set host buffer addr

    ssd_ctrl[14] = desc.length; // set read length

    ssd_ctrl[15] = desc.poll_paddr; // set host polling addr for read completion

    // memory fence before starting read
    asm volatile("mfence" ::: "memory");

    ssd_ctrl[11] = 1; // start read

    while (*(desc.poll_vaddr) != 1)
    {
        asm volatile("pause" ::: "memory");
        // Busy wait
    }

    // memory fence to ensure reading is complete
    asm volatile("mfence" ::: "memory");
}

void ssd_dma_write(volatile uint *ssd_ctrl, ssd_dma_desc desc)
{
    // Task 4
    // clear polling address
    *(desc.poll_vaddr) = 0;

    // ensure that we cleared 
    asm volatile("mfence" ::: "memory");

    ssd_ctrl[22] = desc.src; // set write addr

    ssd_ctrl[23] = desc.dst; // set write host buffer addr

    ssd_ctrl[24] = desc.length; // set write length

    ssd_ctrl[25] = desc.poll_paddr; // set polling addr for write completion

    // memory fence before starting write 
    asm volatile("mfence" ::: "memory");

    ssd_ctrl[21] = 1; // start write

    while (*(desc.poll_vaddr) != 1)
    {
        asm volatile("pause" ::: "memory");
        // Busy wait
    }

    // memory fence to ensure write is complete 
    asm volatile("mfence" ::: "memory");
}