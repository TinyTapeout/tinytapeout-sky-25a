<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This proyect is a LCD 16x2 display controller, it has some hardcoded message, when you wire the pins to the screen for the 4 bits data mode (all the pins have the same name that the display does), it should be ready and display a funny message on the screen

## How to test

Connect the clock to a 50MHz source, the reset is active in one, wire the rest of the pins to the lcd screen (they have the same names and are detailed at the end of this part) and hold the reset a bit and then let it go, and the screen should display a funny message

Outputs
  uo[0]: "rs" register select
  uo[1]: "en" enable
  uo[2]: "data_0"
  uo[3]: "data_1"
  uo[4]: "data_2"
  uo[5]: "data_3"

Inputs
  ui[0]: "clk" 50 MHz clock
  ui[1]: "reset"

## External hardware

It needs a 16x2 LCD Display (HD44780)
