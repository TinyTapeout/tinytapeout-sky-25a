<!---

This file is used to generate your project datasheet.
Please fill in the information below and delete any unused sections.

You can also include images in this folder and reference them in the markdown.
Each image must be less than 512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The PDM peripheral outputs a bit clock signal for a PDM microphone,
and decodes the returned density signal into Pulse Code Modulation (PCM) words.

## Register map

| Address | Name    | Access | Description                                                         |
|---------|---------|--------|---------------------------------------------------------------------|
| 0x00    | ENABLE  | R/W    | Clock gate (0-1).                                                   |
| 0x04    | PERIOD  | R/W    | PDM clock period (0-255).                                           |
| 0x08    | SELECT  | R/W    | PDM data pin number (0-7).                                          |
| 0x0c    | SAMPLE  | R      | PCM sample, result of conversion.                                   |

### ENABLE
Bit 0: Enable clock generation.

### PERIOD
Number of system clock cycles per PDM clock cycle.
For example, to generate a 1 MHz clock signal, set this to 64.

### SELECT
Which input pin to sample data on.

### SAMPLE
16-bit signed integer.
Clears interrupt when read.


## How to test

Connect PDM microphone using DATA and CLK.
Configure the clock rate using `PERIOD`, and turn the clock on using `ENABLE`.

## External hardware

A PDM microphone is needed. It is most practical to use a microphone on a breakout board.
We have tested with [AdaFruit PDM MEMS microphone breakout](https://www.adafruit.com/product/3492),
which has a MP34DT01-M microphone.
