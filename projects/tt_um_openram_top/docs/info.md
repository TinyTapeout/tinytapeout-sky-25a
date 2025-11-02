<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

A simple design with a 16x32 OpenRAM generated 1rw macro using two phased clocking to avoid potential hold violations.

Supports clocks up to 250Mhz

## How to test

```verilog
assign web = ui_in[6]; //
assign csb = ui_in[5]; // chip select
assign sclkb = ui_in[4]; // phased clock b
assign sclka = ui_in[3]; // phased clock a
assign scan_mode = ui_in[2]; //1 scan reg chain, 0 scan phase chain
assign scan_enable = ui_in[1]; //scan chain enable
assign scan_in = ui_in[0]; //input value
```

uio_in[3:0] are for byte write masking