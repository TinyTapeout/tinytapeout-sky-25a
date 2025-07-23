<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project drives a WS2812B RGB LED matrix (or strip) using the SPI protocol. Each 3 byte SPI frame gets displayed on each sequential LED in the matrix. This allows for animations to be displayed given the color composition of each pixel on each frame. For an 8x8 matrix, the expected refresh rate is roughly 300hz.

The simple write-only SPI peripheral is designed for a CPHA (clock phase) and CPOL (clock polarity) of 0 and a baudrate of 1Mhz. Each frame should consist of pulling CS low, writing 3 bytes, and pulling CS high. 

After a pixel's worth of data has been recieved into the SPI register, it is latched and the LED driver is signalled to start sending data.

## How to test

Connect Wires:

- Set up outputs: 
    - Connect `uo[0]` to the input pin (`DIN`) of a WS2812B LED matrix
    - Optionally connect `uo[1]` and `uo[2]` to status LEDs for debugging purposes

- Set up the SPI connection:
    - Connect `SCK` to `ui[0]`
    - Connect `SDI` (or `MOSI`) to `ui[1]`
    - Connect `CS` to `ui[2]`

Display Data:

An example micropython script can be found [here](https://github.com/daniel-theunissen/led-matrix-driver/tree/main/pico-examples)

Set up a SPI peripheral with `CPHA` = `CPOL` = 0 and a baudrate of `1Mhz`. Send 3 bytes of data in GRB format. The correct color should show up on the first LED in the matrix.

## External hardware

- WS2812B RGB LED matrix or strip
    - Up to 64 LEDs have been tested, more may or may not work
- Some SPI master device
    - Tested using a Pi Pico
