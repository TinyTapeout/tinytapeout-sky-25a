<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

A BCD to 7-segment encoder is a digital logic circuit that converts
a Binary-Coded Decimal (BCD) input into signals that can drive a 7-segment display.
BCD represents decimal digits 0–9 in 4-bit binary:

Working Principle
The circuit maps each BCD input to the combination of segments that 
forms the corresponding decimal digit on the 7-segment display.
For example, to display 0, segments a, b, c, d, e, f are ON, and g is OFF.
AND EXTRA GATES INCLUDE CONTROL OF POINT 


## How to test

Outputs
7 segments of the display: a, b, c, d, e, f, g
Each output controls one segment. A high (1) signal lights up the segment, and low (0) turns it off.
Optional DP (decimal point) can also be controlled.

| Decimal | BCD (D3 D2 D1 D0) | a | b | c | d | e | f | g |
|---------|------------------|---|---|---|---|---|---|---|
| 0       | 0000             | 1 | 1 | 1 | 1 | 1 | 1 | 0 |
| 1       | 0001             | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
| 2       | 0010             | 1 | 1 | 0 | 1 | 1 | 0 | 1 |
| 3       | 0011             | 1 | 1 | 1 | 1 | 0 | 0 | 1 |
| 4       | 0100             | 0 | 1 | 1 | 0 | 0 | 1 | 1 |
| 5       | 0101             | 1 | 0 | 1 | 1 | 0 | 1 | 1 |
| 6       | 0110             | 1 | 0 | 1 | 1 | 1 | 1 | 1 |
| 7       | 0111             | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
| 8       | 1000             | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| 9       | 1001             | 1 | 1 | 1 | 1 | 0 | 1 | 1 |

DP can be controled with 4,5 and 7 pins using gates AND, OR with 4, 5 inputs and 7 for select.



## External hardware

List external hardware used in your project (e.g. PMOD, LED display, etc), if any
this uses default hardware, leds and logic input.
