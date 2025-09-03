<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This is a variable-delay chain for setup timing violation experiments.
There are eight delay chains between ui_i[i] and uo_o[i].
Each delay chain has 9 stages.
Each stage has an input sin and an output sout.
The output is defined by sout = FF( MUX( TEST, FF(sin) , DELAY_P( FF(sin) ) ))
where DELAY_P is a 2*P back-to-back inverters,
where TEST is a test control input,
where FF(sin) is an input flip-flop,
where FF(MUX(...)) is an output flip-flop.

P varies with each stage, such that the 9 stages hold 1, 2, 4, 8, 16, 32, 64, 96 and 128 inverter pairs, respectively.

To initialize this module, set TEST to low and load it a sequence of alternating 0 and 1 onto sin. 
After 18 clock cycles, the input FF holds a 0 and the output FF holds a 1.

Next, set TEST to 1 and issue two clock edges.
The first edge is the arming cycle and moves a new value into sin (0->1).
The output of sin drives the delay line DELAY_P and will finally be captured by the output flip-flop.
The second edge is the measuring cycle and captures the output of the delay line.

A setup violation will be observed if the second edge comes too soon after the first edge.

Because the 8 chains do not have identical routing, small variations in setup violation time should be observed.

## How to test

Doing measurements with this module requires a carefully controlled glitchy clock, such as generated with ChipWhisperer.
This module can drive experiments on setup timing violations with evaluation of the impact of P&R, temperature, voltage, etc.

## External hardware

Chipwhisperer or a glitchy clock generator must be used to create a glitchy clock.
