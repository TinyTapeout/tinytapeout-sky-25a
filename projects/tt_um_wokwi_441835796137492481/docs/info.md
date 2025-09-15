<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The first flip-flop (LSB) toggles every time it receives a clock pulse.

This gives us the least significant bit (Q0).

Each following flip-flop toggles when the previous flip-flop’s output goes from 1 → 0 (falling edge).

So the second flip-flop toggles half as fast as the first.

The third toggles half as fast as the second, and so on.

This ripple effect continues through all 8 flip-flops.

So:

Q0 toggles on every clock (counts 0,1,0,1...).

Q1 toggles every 2 clocks.

Q2 toggles every 4 clocks.

…

Q7 toggles every 128 clocks.

Together, the 8 outputs represent an 8-bit binary number.

## How to test

CLK (Default Pin) → Main clock signal that drives all flip-flops.

RESET (Default Pin) → Global reset input. When active, it clears all flip-flops to 0.

Now the control inputs:

IN0 (SET of Counter with RS Flip-Flop)
→ Works with IN1 as part of an RS (Reset–Set) latch behavior. If high, it can set the counter to a defined state.

IN1 (RESET of Counter with RS Flip-Flop)
→ Works with IN0. If high, it resets the counter (like a manual clear).

IN2 (Select RESET: IN1 or RESET DEFAULT)
→ Chooses which reset source is active:

If IN2 = 0 → Reset comes from RESET default pin.

If IN2 = 1 → Reset comes from IN1 (RS flip-flop reset).

IN3 (Select binary counter with Flip-Flop RS or D)
→ Selects the flip-flop type used for the counter:

IN3 = 0 → Use RS flip-flop behavior.

IN3 = 1 → Use D flip-flop behavior (often simpler for synchronous counters).

IN6 (DATA Shift Register)
→ Provides the serial data input for the shift register mode.

IN7 (Select Binary Counter or Shift Register)
→ Determines the circuit mode:

IN7 = 0 → Operate as binary counter (up counter using flip-flops).

IN7 = 1 → Operate as shift register (data shifted bit by bit through the 8 flip-flops).


## External hardware

For test you can use the basics input and output,  use LED and basic digital inputs.
You can test with Basic CLOCK
