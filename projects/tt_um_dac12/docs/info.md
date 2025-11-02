<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

A 12 bit dac

## How to test

Plug in pins to esp32-wroom-s3 controller with GPIO 1-3 for clk, rst-n, and ena respectively. GPIO 11-4 for the rightmost ui-in bits and 12-15 fro the 4 leftmost bits of ui-in. Test by seeing the DAC can replicate values 1024, 2048, and 4095 on a wave analyzer or serial output of the esp32-wroom-s3.

## External hardware

esp32-wroom-s3
