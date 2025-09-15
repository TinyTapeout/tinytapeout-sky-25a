<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The project generates a Pulse Width Modulated (PWM) waveform with a user-defined duty cycle. An internal counter continuously increments with each clock cycle. The duty cycle value, provided as input, is compared against this counter. Whenever the counter value is less than the duty cycle value, the output stays HIGH; otherwise, it goes LOW. This produces a PWM signal where the ON time (duty cycle) can be adjusted.

## How to test

Provide a clock signal to the design. Set the duty cycle input value (e.g., 25%, 50%, 75%) via input pins. Observe the PWM output waveform on an oscilloscope or logic analyzer. A low duty cycle will give shorter ON pulses. A high duty cycle will give longer ON pulses. Verify that the output waveform changes according to the duty cycle input.

## External hardware

Oscilloscope or Logic Analyzer (to observe the PWM waveform)
