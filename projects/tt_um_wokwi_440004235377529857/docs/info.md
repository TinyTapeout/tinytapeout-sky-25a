<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The 4-bits added is built using 4 textbook "full adder with carry in and carry out" circuits.
The first block carry input is tied to ground, but the carry out is available as an output.

The output of the circuit is latched using DSR flip-flops, so the result is updated on every clock rising edge.
Also, you can reset the valur using the reset pin, which is tied to the flip-flops reset input.

## How to test

Generate different 4-bits for A and B operands (see input pins) using the dip switch, wattch the resulting binary number correspondig to the sum of these numbers.
If the resulting sum is greater than 15 (0xf), then there will be a carry bit that can also be considered the 5th bit of the result.
PLease note that the carry out is not latched, so it will not be stored between clock cycles.

## External hardware

This project uses only basic logic. The result can be verifies using LEDs.
