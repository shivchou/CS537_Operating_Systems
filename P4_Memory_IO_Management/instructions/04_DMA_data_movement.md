Task 4:

In this task, you should write codes to correctly trigger Direct Memory Access launched by SSD device.

File ```dma.c``` and ```dma.h``` defines the DMA functions you call from user space. 

These two functions take two arguments, the base address of SSD control region and a simple DMA descriptor consisting of: 1) Data starting address on the device 2) Buffer address on the host 3) Transfer length 4) Host polling address where devices writes completion event.

Complete these two functions according to the register table listed below:

| Register | Definition                              |
|----------|-----------------------------------------|
| 11       | Set to 1 to start DMA read. |
| 12       | DMA read device address |
| 13       | DMA read host buffer address |
| 14       | DMA read legnth |
| 15       | Host polling address for the DMA read completion |
| 21       | Set to 1 to start DMA write. |
| 22       | DMA write device address |
| 23       | DMA write host buffer address     |
| 24       | DMA write legnth |
| 25       | Host polling address for the DMA write completion |

Notice: Device writes 1 to polling address to indicate an event completion.

Test 8-9 will test your DMA read function from SSD and print the readed values.