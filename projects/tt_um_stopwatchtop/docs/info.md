<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The design is a digital stopwatch that counts seconds and minutes using the global Tiny Tapeout clock (~12 MHz).
A clock divider generates a 1 Hz enable pulse, which increments the seconds counter. When seconds reach 59, they reset to 0 and minutes increment. Both values (minutes and seconds) are converted into BCD format and driven onto a 4-digit multiplexed 7-segment display.

Control is provided through input pins:
      ui_in[0] → Start stopwatch
      ui_in[1] → Stop stopwatch

The output pins (uo_out and uio_out) are connected to the 7-segment display’s segment and digit-select lines.

## How to test

Apply reset (rst_n = 0 for a few clock cycles, then rst_n = 1).
Drive ena = 1 (project enable).
Set ui_in[0] = 1 to start counting; clear it afterwards.
Observe seconds and minutes incrementing on the display.
Set ui_in[1] = 1 to stop counting.
Outputs can also be monitored in simulation by watching:
      uo_out[6:0] → segment bits
      uo_out[7] → decimal point
      uio_out[3:0] → active digit select

## External hardware

To see the stopwatch visually, connect:
      uo_out[6:0] → segment lines (a–g) of a common-anode 7-segment display
      uo_out[7] → decimal point (optional)
      uio_out[3:0] → digit enable lines (an0–an3)
