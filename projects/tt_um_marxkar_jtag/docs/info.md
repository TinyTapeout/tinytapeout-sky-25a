<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This JTAG TAP controller implements the IEEE 1149.1 TAP state machine with 16 states. It manages shifting, capturing, and updating instruction and data registers through TDI, TMS, and TCLK inputs. The controller supports three instructions: bypass, ID code read, and boundary scan register (BSR) mode. Internal registers store shadow instructions, ID codes, and BSR bits. The TDO output reflects the serial data shifted out of the selected register.

## How to test

Apply an active-high reset through rst_n (active-low).

Drive TMS (ui_in[1]) and TDI (ui_in[0]) with JTAG vectors according to the IEEE 1149.1 TAP state diagram.

Apply a clock on clk (TCLK) to advance state transitions.

Observe uo_out[0] (TDO) for shifted data during Shift-IR or Shift-DR states.

Confirm instruction updates by verifying that IDCODE or BSR registers respond correctly when selected via the instruction register.


