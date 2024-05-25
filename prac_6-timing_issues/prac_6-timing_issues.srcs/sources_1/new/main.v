`timescale 1ns / 1ps

module main(
    input clk,
    output [5:0] pll_clk, mmcm_clk);

clk_wiz_0 pll(
    .clk_in1(clk),
    .clk_out1(pll_clk[0]),
    .clk_out2(pll_clk[1]),
    .clk_out3(pll_clk[2]),
    .clk_out4(pll_clk[3]),
    .clk_out5(pll_clk[4]),
    .clk_out6(pll_clk[5]));
   
clk_wiz_1 mmcm(
    .clk_in1(clk),
    .clk_out1(mmcm_clk[0]),
    .clk_out2(mmcm_clk[1]),
    .clk_out3(mmcm_clk[2]),
    .clk_out4(mmcm_clk[3]),
    .clk_out5(mmcm_clk[4]),
    .clk_out6(mmcm_clk[5]));

endmodule
