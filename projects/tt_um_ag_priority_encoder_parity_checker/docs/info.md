<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The priority encoder with parity checker module does priority encoding of a 9-bit binary input into a 4-bit binary code and displays the decimal 
equivalent of that code on the 7-segment display. Additionally it also does parity checking and outputs the resultant parity bit.

It has 2 modes of operation for priority encoding and for parity checking:

For priority encoding:
1. Bit towards MSB takes precedence (when `uio_in[1]` is low).
2. Bit towards LSB takes precedence (when `uio_in[1]` is high).

For parity checking:
1. Parity bit is 1 when input has even number of 1s and 0 otherwise (when `uio_in[2]` is low).
2. Parity bit is 1 when input has odd number of 1s and 0 otherwise (when `uio_in[2]` is high).

The following table summarizes the modes:

| `uio_in[1]` | `uio_in[2]` | Mode                 |
|-------------|-------------|----------------------|
| 0           | X           | MSB priority encode  |
| 1           | X           | LSB priority encode  |
| X           | 0           | Even parity flag     |
| X           | 1           | Odd parity flag      |

For all the modes listed above the expected inputs and generated outputs are:

| `ui + uio_in[0]`   | `uio_out[7:4]`      | `uio_out[3]` | `uo_out`   |
|--------------------|---------------------|--------------|------------|
| 9-bit Binary input | 4-bit Priority code | Parity bit   | 7-seg code |

The parity bit controls the DP pin of the 7-segment display.

## How to test

1. Set `uio_in[1]` low and observe that the priority code of `{uio_in[0], ui_in}` with MSB having higher priority is output on the output pins 
   (`uio_out[7:4]`) and on the 7-segment display connected to `uo_out`.
2. Set `uio_in[1]` high and observe that the priority code of `{uio_in[0], ui_in}` with LSB having higher priority is output on the output pins 
   (`uio_out[7:4]`) and on the 7-segment display connected to `uo_out`.
3. Set `uio_in[2]` low and observe that the parity bit `uio_out[3]` is getting set when the input `{uio_in[0], ui_in}` has even number of 1s.
   The DP on 7-segment display should light up when parity bit is 1.
4. Set `uio_in[2]` high and observe that the parity bit `uio_out[3]` is getting set when the input `{uio_in[0], ui_in}` has odd number of 1s.
   The DP on 7-segment display should light up when parity bit is 1.
