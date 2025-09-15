<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

Hook up ADALM2k to input port 1 and watch as the output LED lights up based on the input. While the ADALM2k charges the input port, the current from the ADALM2k charges the 8 bit width register, when the register reaches threshold, the register releases a pulse that can be seen in the output LED. The input pin requires a constant input signal that increases the "voltage" in the accumulator. Once the Accumulator hits its threshold, the Accumulator will fire an impulse that can be seen as an output LED lighting up.

## How to test

Test it by using the ADALM2k with wired leads and a constant DC input voltage.

## External hardware

ADALM2k is the external hardware with jumper wires or leads to connect the ADALM2k to the PCB with the ASIC Chip on it.
