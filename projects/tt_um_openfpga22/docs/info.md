<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project is built on a 2×2 OpenFPGA fabric that contains 4 configurable logic blocks (CLBs), 8 I/O blocks, 9 switch boxes (SBs), and 12 connection boxes (CBs). The CLBs implement user-defined logic, the I/O blocks provide external interfacing, and the SBs and CBs form the programmable routing network that connects logic to I/O. A Verilog design is compiled into a bitstream that configures these resources, allowing the fabric to function as the intended digital circuit.

## How to test

To test the project, load the generated bitstream onto the 2×2 OpenFPGA fabric and drive input signals through the I/O blocks. The outputs can be observed on the corresponding I/O pins and verified against expected results, either in simulation or with external measurement equipment such as a logic analyzer.


## External hardware

No dedicated peripherals are required. The design uses the FPGA’s I/O blocks directly for input and output, with optional use of standard lab equipment such as signal generators for inputs or logic analyzers for outputs during hardware evaluation.
