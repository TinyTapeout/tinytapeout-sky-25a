## How it works

Hold violations can kill a design. It famously happened with Efabless' early OpenMPW shuttles.
But there is a classic technique that can make a design entirely resitant to hold violations.
As always, there are some trade-offs and that's why it's rarely used in production chips.
But it can become handy when you can't trust your PDK liberty files (maybe you designed
some standard cells and couldn't characterize them) or your EDA tools (you replaced some
step in the place & route flow with a custom version).

In a design with classic two-stage flip-flops, changes happen synchronously on the positive
edge of the clock. Every flip-flop locks its internal state to the current input, and
simultaneously releases this new internal state to its output. When clock skew occurs, i.e.
the clock signal doesn't reach every flip-flop at the same time, it may happen that a
flip-flop captures the _new_ value of its input. It's called a hold violation, and unlike
setup violations it can't be fixed during bring-up by reducing the clock frequency.
Static timing analyzers work hard to prevent it from happening in the first place.

The technique to prevent hold violations altogether is to supply every flip-flop with two
independent clock signals that trigger alternately, and capture the input on the edge of
one but release it on the edge of the other. Should we see a hold violation during bring-up,
we can increase time between the two events and make it disappear. For more details, see
Chapter 10 from Weste & Harris, 4th Ed. (especially around Figure 10.21 or search for
"nonoverlapping").

This repo contains an example design with two-phase nonoverlapping clocks, obtained by
patching the flip-flops in the GL verilog code. The original design is
[Simon's Caterpillar](https://github.com/htfab/tt09-caterpillar) from TT09,
available in the `src/orig_rtl` directory, and it's synthesized into the GL verilog
in `src/orig_gl`. The patcher script, `src/patcher.py`, is intended to be inserted into
the flow to run right after synthesis, but for added clarity I've added the patched
GL verilog into `src/patched_gl` and it's used as the input of the actual hardening flow.

The patcher does two operations on the GL verilog:
- It replaces every flip-flop with a sequence of two latches. Even before the replacement
  a flip-flop was composed of two latches that were transparent when clk1 was low resp.
  high. But replacing it with two separate latches allows us to set one latch to be
  transparent while clk1 is high while the other one is transparent while clk2 is high.
  The two clocks being nonoverlapping means that they shouldn't be both high at the
  same time.
- It adds a scan chain running through every flip-flop in the design to make the debugging
  of tricky timing situations easier.

The project configuration was changed to use a custom SDC file that sets every path as
a false path, effectively disabling the static timing analyzer and any attempts to
achieve timing closure during the flow. And the second clock is routed just as a regular
signal. Despite all this, the design should still work. But I wouldn't do it with
a project that needs high speed or even a specific clock rate. Simon's Caterpillar
was chosen because it's complex enough but only needs a kHz-range clock and it
has enough free pins for the second clock phase and the scan chain.

## How to test

Generate two 50 kHz clocks, both with 25% duty cycle, with phases of 0° and 180°.
Supply one clock on the `clk` pin, the other on `ui[5]`.

To test the scan chain, pull `ui[6]` high and send a data stream on `ui[7]`.
The output will be available on `uo[7]` with a delay of 305 clock ticks.

To test the game, you will need the Simon Says PMOD. Set up `ui[7:5]` to be
driven by the RP2xxx but `ui[4:0]` should be driven by the PMOD.
Run the clock as described above but pull `ui[6]` low to disable the scan chain.
Reset the project, then follow the
[original test procedure](https://github.com/htfab/tt09-caterpillar/blob/main/docs/info.md).

## External hardware

Simon Says PMOD (only needed for the full test)
