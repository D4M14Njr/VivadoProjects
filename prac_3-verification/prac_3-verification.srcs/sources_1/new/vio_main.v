`timescale 1ns / 1ps

module vio_main(
    input clk,
    output [7:0] an,
	output [7:0] seg);

wire en_button, reset;
wire [7:0] inp;
vio_0 vio (
    .clk(clk),
    .probe_in0(an),
    .probe_in1(seg),
    .probe_out0(en_button),
    .probe_out1(reset),
    .probe_out2(inp)
);
    
main ma(
	.inp(inp),
	.en_button(en_button),
	.reset(reset),
	.clk(clk),
	.an(an),
	.seg(seg)
);
    
endmodule

