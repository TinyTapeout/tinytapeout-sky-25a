<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

There is a FSM that counts how many times the input signal is "ON" in a fixed time window, then it calculates the duty cycle.

## How to test

just put a PWM signal to the input `ui_in[0]` and check the first 7 bits of `uo_out` (the duty cycle value) and the bit `uo_out[7]` (the valid signal). The value 127 corresponds to a duty cycle of 100%.

## External hardware

A signal generator or PWM generator for the input and a logic state analyzer to check the output.
