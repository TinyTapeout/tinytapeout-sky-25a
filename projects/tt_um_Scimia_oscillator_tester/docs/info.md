<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This simple design aims to receive an input clock signal (any square wave) and measures its frequency

## How to test

simply connect an external oscillator or square wave generator to the input pin ui_in[0] at least 10 times slower than the system clock and the 8bit result (expressed in kHz) to the uo_out pins

## External hardware

Just an external wave generator or oscilator and a logic analyzer to check the results
