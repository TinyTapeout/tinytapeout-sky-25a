<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This design will take as input a Byte from a UART  receive (RX) line and produce a chirp signal in output.
The Chirp is available as 8-bit digital bus (7 is MSB, 0 is LSB).
The produced chirp will be the digital rapresentation of the input Byte in LoRa - Style modulation at BW 125 kHz, SF8.

<img src="additional/Megnevezetlen diagram.png" >


## How to test
Connect all Hardware.
Connect and enable the 10 MHz clock stimulus.
Power on: assert Reset input low.
Send a UART byte and observe the data output.

## External hardware

UART transceiver (TX only) -> connect to input RX
Clock generator --> connect to clock input (10 MHz clock)
Digital Signal Analyzer --> connect bit 7 down to 0 of output data
