<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

Analog PLL targeted for 2.4GHz output, with a BGR circuit for the charge pump component.

You can find my detailed design process here: https://jyblue1001.github.io/

## How to test

1. Connect OUT_FREQ to a multimeter, as the initial control voltage is 0V, it should be naturally outputting a 2.18GHz signal.
2. Connect REF_FREQ to a 20MHz signal. Either square wave of sinusoid are both are both ok as long as Vpp is 1.8V with respect to ground.
3. Inspect OUT_FREQ, within the settling time of 3us, the PLL output will converge to a 2.4GHZ signal.

NOTE: I doubt it will work exactly as intended. The output frequency may not reach 2.4 GHz. If that’s the case, you might need to increase the input frequency.

## External hardware

1. Signal Generator (For the input)
2. Multimeter (To detect the output frequency)