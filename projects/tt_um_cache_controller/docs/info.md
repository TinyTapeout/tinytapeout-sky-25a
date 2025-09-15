<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements a simple direct-mapped cache memory controller that manages data storage and retrieval for 4 cache blocks. The CPU sends an 8-bit address along with a read/write signal through input pins. On a write, the data is stored in the cache and marked dirty. On a read, if the address matches a valid cache block, data is returned from the cache to the output pins. If the block is not present, the controller simulates a cache miss by loading a placeholder value.

The design fits within Tiny Tapeout SkyWater 130nm process constraints with 8 input/output pins, handling cache logic and interfacing efficiently. The core cache runs synchronously with the injected clock and reset signals.

## How to test

To test the design, drive the input pins (`ui_in`) with the address and read/write control bits. For example, set the MSB high to indicate a write operation and provide the lower address bits for caching. Then observe the output pins (`uo_out`) for read data results. 

Simulation testbench and cocotb tests are included to verify basic cache operations like read hits, write hits, and read misses.

## External hardware

No external hardware is required for this design. The project targets the Tiny Tapeout chip fabrication program and is tested purely via simulation and chip fabrication.

