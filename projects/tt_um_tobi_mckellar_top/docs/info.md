<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

Measures the difference in capacitive time constant when a finger is applied to a touch pad.

## How to test

You will need a capacitive touch pad PCB. Alternatively, make your own out of tinfoil!
Connect one side of the capacitor to ground, and pull the other up to 3V3 via a large (~1MOhm resistor).
The pulled up side should also be connected to UIO0.
Reset the ASIC and then put your finger on the pad and observe UO0 rise and fall with your finger presses.

## External hardware

Capacitive touch pad PCB
