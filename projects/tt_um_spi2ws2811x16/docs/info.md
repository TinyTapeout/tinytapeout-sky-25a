<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

Connect your SPI clock to the chip clock, CS to `ui[0]`, COPI (MOSI) to `ui[1]`, and send send entrelaced RGB data for 8 strips, with 8 extra null bytes at the end of the buffer to keep the clock and chip select active for the chip to work.

You will get WS2811 frames on the 8 `uo` pins

The SPI clock should be at around 14MHz ideally, but the WS2811 controller is quite flexible about timing.

## How to test

Connect any microcontroler capable of SPI at ~14MHz, send entrelaced pixel data with 8 bytes of 0 at the end.

Example of frame:

```
R[0]R[1]R[2]R[3]R[4]R[5]R[6]R[7]G[0]G[1]G[2]G[3]G[4]G[5]G[6]G[7]B[0]B[1]B[2]B[3]B[4]B[5]B[6]B[7]\0\0\0\0\0\0\0\0
^Red data for the 8 strips      ^Green data for the 8 strips    ^Blue data for the 8 strips     ^Null bytes to keep the clock running
```

Just add more R[0..7]G[0..7]B[0..7] data before the null bytes to drive more than a single LED on each strip.

## External hardware

IceStick for testing and chceking if the output is fine.
