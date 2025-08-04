/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_acidonitroso_programmable_threshold_voltage_sensor (
    input  wire       VGND,
    input  wire       VDPWR,    // 1.8v power supply
//    input  wire       VAPWR,    // 3.3v power supply
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    inout  wire [7:0] ua,       // Analog pins, only ua[5:0] can be used
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);



 wire [7:0] int_y;
 wire [7:0] int_n;

decoder_p decoder_p(
		    .in[0](ui_in[0]),
		    .in[1](ui_in[1]),
		    .in[2](ui_in[2]),
		    .y_d(int_y),
		    .n_d(int_n),
		    .VPWR(VDPWR),
                    .VGND(VGND)
);

analog analog(
	      .in0(ua[2]),
	      .out(ua[1]),
	      .Vref(ua[0]),
	      .y_d[7](int_y[7]),
	      .y_d[6](int_y[6]),
	      .y_d[5](int_y[5]),
	      .y_d[4](int_y[4]),
	      .y_d[3](int_y[3]),
	      .y_d[2](int_y[2]),
	      .y_d[1](int_y[1]),
	      .y_d[0](int_y[0]),
	      .n_d[7](int_n[7]),
	      .n_d[6](int_n[6]),
	      .n_d[5](int_n[5]),
	      .n_d[4](int_n[4]),
	      .n_d[3](int_n[3]),
	      .n_d[2](int_n[2]),
	      .n_d[1](int_n[1]),
	      .n_d[0](int_n[0]),
	      .Vdd(VDPWR),
	      .Vss(VGND)

);

assign uo_out[0] = VGND;
assign uo_out[1] = VGND;
assign uo_out[2] = VGND;
assign uo_out[3] = VGND;
assign uo_out[4] = VGND;
assign uo_out[5] = VGND;
assign uo_out[6] = VGND;
assign uo_out[7] = VGND;

assign uio_out[0] = VGND;
assign uio_out[1] = VGND;
assign uio_out[2] = VGND;
assign uio_out[3] = VGND;
assign uio_out[4] = VGND;
assign uio_out[5] = VGND;
assign uio_out[6] = VGND;
assign uio_out[7] = VGND;

assign uio_oe[0] = VGND;
assign uio_oe[1] = VGND;
assign uio_oe[2] = VGND;
assign uio_oe[3] = VGND;
assign uio_oe[4] = VGND;
assign uio_oe[5] = VGND;
assign uio_oe[6] = VGND;
assign uio_oe[7] = VGND;

endmodule
