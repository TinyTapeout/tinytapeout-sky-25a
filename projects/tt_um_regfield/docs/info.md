<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The module has limited use as a functional module; it's just one big sensor made out of flip-flops.
This is a register field design, consisting of 8 chains of 64 flip-flops.
In between each register, two back-to-back inverters are placed to avoid hold violations.
The objective of this design is to study the impact of EM pulses on a field of initialized flip-flops.

## How to test

You load a specific pattern into the flops in 64 cycles.
Next, an EM pulse (and optional clock cycle) is injected using a Chipshouter (or similar) setup 
Then, the pattern is scanned out to study impact on the values.

## External hardware

EM pulses require the use of an external probe such as Chipshouter.
