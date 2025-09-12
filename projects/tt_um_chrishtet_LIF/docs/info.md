<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works
A leaky-integrate-and-fire (LIF) neuron implemented in 8-bit signed Q4.4 fixed-point. 
It’s designed to be tapeout-friendly (adds/subs/shifts only, no multiplies) with saturating arithmetic and a refractory period.

Per clock (when en=1), it 
  - Integrates input current into a membrane potential V.
  - Applies leak (exponential decay toward 0 via arithmetic right-shift).
  - Checks threshold on the next potential (V_next) and emits a a spike signal and set V to Max if crossed.
  - Resets and holds during a programmable refractory window so it won’t spike again immediately.

## How to test
Using input CLk, Reset, and Current

## External hardware
  ADALM2000
