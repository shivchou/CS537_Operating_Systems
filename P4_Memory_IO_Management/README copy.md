# CS 537 Project 4 Memory & IO Management

## Learning Objectives:

1. Learn how to create system calls to map physical address to virtual address.

2. Understand how to manage page tables for huge page memory.

3. Understand basic concepts of device, memory-mapped IO, and Direct Memory Access.

In this project, we will emulate the process of controlling peripheral devices by mapping its memory region into your virtual memory. We will also transfer data between huge page memory and device through Direct Memory Access (DMA) and perform data processing on the device.

Topic: Memory-mapped IO, Huge Page, Direct Memory Access, and device control.

You will need to:

1. Create system call to map the bus physical address of a device into user space virtual address.

2. Read and write device-attached memory or device data through memory mapped IO (MMIO).

3. Create system call to map Huge Page memory into page table.

4. Transfer data between device and huge page based on device-controlled Direct Memory Access.

5. Perform computing tasks on device based on MMIO.

---

## Background

### Peripheral devices

Peripheral devices such as the Graphic Processing Unit (GPU), Solid State Drive (SSD), Network Interface Card (NIC) are ubiquitous in today's computers. Usually these devices are connected to computers via Bus. To enable CPU's access to these devices, usually BIOS assigns Bus physical address to the registers or memory of a peripheral device during booting and maps device address space to Bus address space. Then CPU can perform IO read or write to devices through Memory-Mapped IO. Also, a device can have multiple BUS memory-mapped regions for different functions or data region. 

In xv6, memory space starting from 0xFE000000 to 0xFFFFFFFF is reserved for device space. These physical addresses can be assigned to devices. In this project, we prepare two toy devices under Peripheral Component Interconnect (PCI) bus for you to work with.

After you compile the xv6, use `ls`, and you will see a new application `lspci` in the root directory, this command can list PCI devices and display their information. (This is a simplified version simulating a real `lspci` command in linux. 😀)

Type the `lspci` command. Then you can see the devices you have under this computer. Usually a peripheral device is identified with a unique ID [Bus]:[Device].[Function].

Try use `lspci` with arguments (use `lspci -h` for help) to find the details of these devices. For example, their bus physical address and size of each region. You will need these details in this project.

### Direct Memory Access

In early stage of computer system, IO can only be performed by the CPU. Devices can not have access to the main memory. This causes a series of problems: 1) high CPU overhead since CPU is occupied with IO, 2) low throughput due to small granularity of CPU instructions.

Later, DMA technique is introduced to allow devices to perform direct data transfer with the main memory without CPU's involvment. Nowadays, high-speed devices such as GPUs, SSDs and NICs are all equipped with DMA controller to enable high throughput IO.

DMA is designed for transferring large and contiguous blocks of data, so high-speed devices usually use huge page memory for DMA.

### Polling

Usually there are two mechanisms for devices to notify CPU of an event: interrupt and polling. In the first approach, the device asserts an interrupt signal to inform the CPU that an event has occurred. Upon detecting this signal, the CPU suspends the current execution, saves the context, and jumps to the appropriate Interrupt Service Routine (ISR) to handle the event. However, the interrupt introduces context-switching overhead and incurs high latency.

For many high-speed device, the polling approach is favored for its high throughput and low latency. The CPU continuously monitors a specific address which the device will modify with dedicated values when an event occurs. In this mechanism, the CPU is occupied, but the latency can be minimized. Moreover, polling eliminates the interrupt handling overheads which limits the maximum throughput the system can achieve.







