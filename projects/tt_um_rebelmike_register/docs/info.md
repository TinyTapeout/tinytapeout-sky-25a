<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The project provides 2 32-bit registers that constantly cycle, in the same way as TinyQV's register file.

There's a 4-bit wide interface to the registers, a write enable for each register, and address selection for two read ports.

## How to test

To write a register set its WEN high and clock data in over 8 cycles.
To read a register select its address on one of the read ports and observe the data on the appropriate output over 4 cycles.

## External hardware

None
