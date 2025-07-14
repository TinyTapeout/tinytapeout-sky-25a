<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

Debounce the inputs, drive an encoder module to adjust seven segments and pwm output. There is ctrl pin to enable countdown in every minute on the seven segments. A 16MHz clock oscillator is required.

## How to test

Twist each encoder and the attached PMOD and LED should change the display value and brightness. Enable the ctrl pin to start the minute countdown.

## External hardware

Use 1x PMOD and 3x LED display attach the output pins, 3x digital encoders attach to the input pins.
