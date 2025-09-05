<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The ALU is designed to perform 32-bit IEEE 754 floating-point arithmetic using a simple byte-serial protocol for input and output. Currently, it only supports 2 different binary operations: addition and subtraction. The ALU has full support for 32-bit IEEE 754 floating-point numbers on these two operations, including for special numbers. However, the ALU only returns quiet NaNs, regardless of whether the input was a signalling NaN.

The ALU begins in an idle state. To initiate an operation, the controller first sets the start signal high. This signals the ALU to leave the idle state and begin receiving operand data. Immediately following this, the ALU uses 8 input pins to obtain the 32-bit operands, one byte at a time over 4 consecutive clock cycles per operand. A total of 8 cycles are required to input both operands. The operands are loaded in little-endian order, with operand A being loaded first (i.e. the loading order is A[0], A[1], A[2], A[3], B[0], B[1], B[2], B[3], then it performs A <op\> B). The operation performed is selected using a 1-bit opcode (0 for addition, 1 for subtraction).

After loading the operands, the ALU transitions to a compute state and executes the specified operation in 1 clock cycle. Once the result is ready and about to be output, the ALU sets the done signal high to indicate that the output is valid and will be streamed. The 32-bit result is then sent out one byte at a time over the 8 output pins across 4 clock cycles. Again, this is outputted in little-endian order (i.e. the output order is Out[0], Out[1], Out[2], Out[3]).

After the final byte is transmitted, the ALU clears the done signal and returns to the idle state.

More information about the design, including block diagrams and timing diagrams, is available here: https://docs.google.com/document/d/13MREwZHKNEruEFnfJ9VPStozTlr_zDc9eXlc8Hb1F6M/edit?usp=sharing

## How to test

The design operates on a clock frequency of 20MHz, or a period of 50ns. Each state will last 1 period.

Use the input ports to input the operands, and the output port to read the result.

## External hardware

Can be connected to any microcontroller. Please refer to the linked doucmentation for pinout and specific details.
