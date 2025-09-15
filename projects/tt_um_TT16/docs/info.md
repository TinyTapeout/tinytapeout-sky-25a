<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The asynchronous FIFO is a memory buffer that allows safe data transfer between two subsystems operating on different clock domains. It uses separate read and write pointers, which are converted to Gray code for synchronization across domains. Full and empty conditions are detected by comparing synchronized pointers, ensuring reliable communication without metastability issues.

## How to test

To test the FIFO, apply write operations with random or sequential data at the write clock domain while simultaneously reading from the read clock domain. Observe that the read data matches the written data in order, with no corruption. Simulation can be run in tools like Vivado, using different clock frequencies for read and write sides to verify asynchronous operation.

## External hardware

No external hardware is required. The FIFO can be fully simulated. However, if tested on an FPGA, LEDs or UART modules may be connected to display write/read status, data values, or FIFO full/empty flags.
