<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This is basically a 12 hour clock (that displays minutes and hours) with an AM/PM indicator. This works by incrementing in seconds (which is not an output) and checking when to turn over the minute/hour.

## How to test

To test, you have to have a clock signal, reset signal, and ena signal going in where ena is pulsing every second. These signals are ui_in[7:5] so they are manually going in so that there is more flexibility.

## External hardware

List external hardware used in your project (e.g. PMOD, LED display, etc), if any
There isn't any notable external hardware unless you want to connect it to an LED display to see the time/output.
