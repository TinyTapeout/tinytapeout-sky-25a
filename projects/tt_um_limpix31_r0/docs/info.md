<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

It's an ASIC version of the original [r0](https://github.com/LIMPIX31/r0) project, optimized for a smaller area.

**r0** lets you accurately measure human reaction time by interfacing with only a VGA-compatible monitor and a single
button. The precision is ±1 microsecond.

The state is not synchronized with vsync, so the monitor may start displaying green from an arbitrary line. This forces
you to watch the entire monitor instead of just the upper-left corner waiting for the first green pixel.

## How to test

1. Connect your monitor with Tiny VGA and the button (with pull-up resistor) to `ui[0]`.
2. Make sure that the LFSR debug block looks like noise in the idle state.
3. Press the button once to get ready.
4. and as soon as you see green on the monitor, press the button as quickly as possible.
5. Check the results of your reaction speed
6. Try press earlier, the screen will turn red, which means that your reaction was false.

## External hardware

* Tiny VGA
* Pulled-up button to `ui[0]`
