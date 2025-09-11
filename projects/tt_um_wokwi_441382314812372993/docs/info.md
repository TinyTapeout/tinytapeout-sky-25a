<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This circuit performs 4-bit addition and subtraction. A dedicated input pin acts as a control signal. When the reset pin is set to low (0), the circuit behaves as an adder. When set to high (1), it becomes a subtractor by converting the second input to its two's complement before adding.

## How to test

To test the circuit, provide two 4-bit numbers as inputs using the designated input pins. Use the separate control pin to switch between addition (low) and subtraction (high). The result of the operation will be displayed in binary on the output pins.

## External hardware

The binary output is converted to a decimal format using a BCD (Binary Coded Decimal) to 7-segment display decoder. The resulting decimal number is then shown on a 7-segment display for easy reading.
