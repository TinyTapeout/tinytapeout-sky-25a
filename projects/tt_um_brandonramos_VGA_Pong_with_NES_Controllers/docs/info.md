<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project is designed to play Pong with two players using NES controllers which output to a VGA compatible monitor. 

## How to test

<!---Explain how to use your project-->
You will need two NES controllers which will take in 3 wires (not including power and ground). Hook up the connections as shown in the bidirectional I/O.

You will also need the hook up the output to a VGA breakout board. I created my own using a perfboard and some resistors but you can use the TinyTapeout VGA PMOD, just ensure that you hook up r0,r1 on the VGA PMOD both to r from the output as my design only uses 1 bit for each signal.

## External hardware
- VGA PMOD or your own VGA breakout board
- 2 NES controllers
- VGA compatible monitor

<!---List external hardware used in your project (e.g. PMOD, LED display, etc), if any -->
