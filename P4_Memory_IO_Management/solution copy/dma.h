typedef struct ssd_dma_desc{
    uint src;
    uint dst;
    uint length;
    uint poll_paddr;
    volatile uint* poll_vaddr;
} ssd_dma_desc;

void ssd_dma_read(volatile uint* ssd_ctrl, ssd_dma_desc desc);
void ssd_dma_write(volatile uint* ssd_ctrl, ssd_dma_desc desc);
