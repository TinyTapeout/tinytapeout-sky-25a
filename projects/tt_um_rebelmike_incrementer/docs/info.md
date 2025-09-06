<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

16 standard cell library flip-flops are wired to 16 custom half adder cells, to make a 16 bit counter.

## How to test

Provide a clock signal on clk.  in0 is the input to the LSB of the counter, so the counter will increment only if in0 is high.  The count is reset when rst_n is low.

## External hardware

None
