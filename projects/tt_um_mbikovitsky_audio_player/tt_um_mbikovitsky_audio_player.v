`default_nettype none

module tt_um_mbikovitsky_audio_player (
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

   wire [15:0] o_digital;
   digital_top top (.VGND(VGND),
                    .VPWR(VDPWR),
                    .clk(clk),
                    .rst_n(rst_n),
                    .ui_in(ui_in),
                    .uo_out(uo_out),
                    .uio_in(uio_in),
                    .uio_out(uio_out),
                    .uio_oe(uio_oe),
                    .o_digital(o_digital)
                    );

   wire dac_1_buf_0;
   dac dac_1 (.VDD(VDPWR),
              .VSS(VGND),
              .out(dac_1_buf_0),
              .a0(o_digital[8]),
              .a1(o_digital[9]),
              .a2(o_digital[10]),
              .a3(o_digital[11]),
              .a4(o_digital[12]),
              .a5(o_digital[13]),
              .a6(o_digital[14]),
              .a7(o_digital[15])
              );
   buffer buffer_0 (.VDD(VDPWR),
                    .VSS(VGND),
                    .in(dac_1_buf_0),
                    .out(ua[0])
                    );

   wire dac_2_buf_2;
   dac dac_2 (.VDD(VDPWR),
              .VSS(VGND),
              .out(dac_2_buf_2),
              .a0(o_digital[0]),
              .a1(o_digital[1]),
              .a2(o_digital[2]),
              .a3(o_digital[3]),
              .a4(o_digital[4]),
              .a5(o_digital[5]),
              .a6(o_digital[6]),
              .a7(o_digital[7])
              );
   buffer buffer_2 (.VDD(VDPWR),
                    .VSS(VGND),
                    .in(dac_2_buf_2),
                    .out(ua[1])
                    );

endmodule
