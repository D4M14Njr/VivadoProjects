`timescale 1ns / 1ps

module test;

wire [5:0] pll_clk, mmcm_clk;
reg clk = 0;

always #5 clk = ~clk;

main uut(
    .clk(clk),
    .pll_clk(pll_clk),
    .mmcm_clk(mmcm_clk));

endmodule
