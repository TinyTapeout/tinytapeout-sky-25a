<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

* An 8 bit lfsr powers a random number generator between 1 and 6. Psuedo random number generated using the last three bits of the lfsr.
* When the user turns the dipswitch at locaiton 0 (LSB) to on the number given on the next clock cycle is locked in as the dice roll.
* To roll a number number reset the 0 dipswitch (LSB) to off, and turn it back on again.
* When dipswitch is off dice outputs 0 to seven segment display.
* Note: if the dipswitch at locaiton 0 (LSB) is turned on at startup 0 will be returned / show on the seven segment display until it is turned off and back on again.

## How to test

Test by varying timing of dipswitch 0's (LSB) input to on and off.

## External hardware

Uses on board dipswitches, and 7 segment display.

## Fun Images
sixSidedDie Dot File
![alt text](https://github.com/tgrillz/tt_um_sixSidedDie/blob/main/docs/sixSidedDie-Dot.png?raw=true)

eightBitlfsr Dot File
![alt text](https://github.com/tgrillz/tt_um_sixSidedDie/blob/main/docs/eighytBitlfsr-Dot.png?raw=true)

sevenSeg Dot Files
![alt text](https://github.com/tgrillz/tt_um_sixSidedDie/blob/main/docs/sevenSeg-Dot.png?raw=true)
