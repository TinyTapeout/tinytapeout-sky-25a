<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

Mode is selected with ui_in[2:0] (exclusive; only these three bits choose the active block).

All other pins either feed the active block or are ignored by the top.

The top builds a full 8-bit uo_out value for each mode and forces all unused bits to 0.

Bidirectional pads are inputs only in this design: uio_out = 0x00 and uio_oe = 0x00, so there is no contention on uio[*].

clk drives PWM, RAM, FDC registers, and the turn-signal timing. rst_n is active-low (internally inverted for FDC which expects active-high).

Pin summary:

Dedicated inputs: ui_in[7:0]

ui_in[2:0] = mode (exclusive)

Other ui_in bits are used as control/address in some modes (see mode map).

Bidirectional (used as inputs only): uio_in[7:0]

Dedicated outputs: uo_out[7:0] (all bits defined per mode; unused bits = 0)

Mode map (ui_in[2:0]):
000 Basic gates
Inputs: uio_in[0]=a, uio_in[1]=b
Outputs: uo_out = {00, ~a, NOR, NAND, XOR, OR, AND}

001 2:1 MUX + 1:4 DEMUX
Inputs: uio_in[0]=d0, uio_in[1]=d1, uio_in[2]=din,
ui_in[3]=sel_mux, ui_in[5:4]=sel_demux
Outputs: uo_out = {000, y_demux[3:0], y_mux}

010 PWM (8-bit)
Inputs: uio_in[7:0]=duty
Outputs: uo_out = {duty[7:1], pwm}

011 HEX to 7-segment
Inputs: uio_in[3:0]=hex
Outputs: uo_out = {0, seg[6:0]} where seg={a,b,c,d,e,f,g}, 1=ON

100 Mini-ALU (4-bit)
Inputs: uio_in[3:0]=A, uio_in[7:4]=B, ui_in[5:3]=op
op: 000 add, 001 sub, 010 AND, 011 OR,
100 XOR, 101 NOTA, 110 PASSA, 111 PASSB
Outputs: uo_out = {000, flag, Y[3:0]} (flag = carry or !borrow)

101 FDC (frequency discriminator)
Inputs: uio_in[0]=VCO (external square wave); uses global clk and rst_n
Outputs: uo_out = {000, D_out[4:0]}

110 RAM 16x4 (synchronous read, 2-cycle pipelined WE)
Inputs: ui_in[7]=WE, ui_in[6:3]=ADDR, uio_in[3:0]=DATA_IN
Outputs: uo_out = {0000, DATA_OUT[3:0]}

111 Direccionales (turn signals)
Inputs: ui_in[4:3]=dir (01 left, 10 right, 11 both)
Outputs: uo_out = {0, right[2:0], 0, left[2:0]}

## How to test

General: set mode with ui_in[2:0], then drive the listed inputs and read uo_out[7:0].

GATES (000): drive a,b on uio_in[1:0]; check uo_out matches {00, ~a, NOR, NAND, XOR, OR, AND}.

MUX/DEMUX (001): set d0,d1,din on uio_in[2:0]; sel_mux on ui_in[3]; sel_demux on ui_in[5:4]; observe uo_out[0] (mux) and uo_out[4:1] (demux one-hot).

PWM (010): write duty to uio_in[7:0]; measure uo_out[0] with a scope; duty cycle ≈ duty/256; uo_out[7:1] shows duty[7:1].

HEX7 (011): write hex nibble to uio_in[3:0]; uo_out[6:0] emits segment bits (active-high). Invert externally if your display is common-anode.

ALU (100): set A=uio_in[3:0], B=uio_in[7:4], op=ui_in[5:3]; read Y on uo_out[3:0] and carry/!borrow on uo_out[4].

FDC (101): feed a square wave into uio_in[0]; uo_out[4:0] changes with frequency; rst_n resets state.

RAM (110): write by setting ADDR=ui_in[6:3], DATA_IN=uio_in[3:0], WE=ui_in[7]=1 for a few clocks (internal WE pipeline); read with WE=0 and same ADDR; after one clock uo_out[3:0] shows DATA_OUT.

Direccionales (111): dir=ui_in[4:3]; left pattern on uo_out[2:0]; right pattern on uo_out[6:4].

Safety notes:

uio_out and uio_oe are always 0; uio_in can be tied to switches or sources without bus contention.

Use series resistors for LEDs (330 to 1000 ohms).

Keep input levels within IO voltage (e.g., 3.3 V).

## External hardware

8 LEDs + 8 resistors (to view uo_out[7:0])

DIP switches / jumpers / PMOD-Switch (to drive uio_in[7:0])

Single 7-segment display + resistors (HEX7 mode)

Function generator (0 to VDD square) for FDC input on uio_in[0]

Logic analyzer or oscilloscope (PWM duty, RAM timing, FDC response)
