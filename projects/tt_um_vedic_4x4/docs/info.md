<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements a 4x4 Vedic Multiplier based on the Urdhva Tiryagbhyam sutra from Vedic mathematics. It hierarchically uses four 2x2 Vedic multipliers to calculate the product of two 4-bit numbers (A[3:0] × B[3:0]). The result is an 8-bit product output on P[7:0].

## How to test

Ensure all Verilog files are in the correct directories.
Navigate to the test/ folder.

Use make to run the cocotb testbench:

cd test make

The testbench sets input values and verifies output through assertions.

You can modify the test.py file to check different inputs and behaviors.

## External hardware

Not applicable — this project runs entirely in simulation and does not require external hardware.
