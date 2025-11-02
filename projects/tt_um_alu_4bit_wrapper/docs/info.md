<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements a 4-bit Arithmetic Logic Unit (ALU) with flags, designed for integration in the Tiny Tapeout sky25a shuttle. The ALU performs arithmetic, logical, shift, and comparison operations on two 4-bit operands (A[3:0] and B[3:0]).

The design also generates status flags:
- Carry (unsigned overflow/borrow)
- Zero (result is zero)
- Negative (sign bit of result)
- Overflow (signed overflow)

This makes it suitable as a basic CPU building block or as a teaching/demo chip.

## How to test

1. Connect 8 toggle switches to ui_in[7:0] (for A and B).
2. Connect 4 toggle switches to uio_in[3:0] (for ALU_Sel).
3. Connect 8 LEDs (with resistors ~330 Ω) to uo_out[7:0].
    - LED
    - LEDs [7:4] = Flags (Carry, Zero, Neg, Ovf)