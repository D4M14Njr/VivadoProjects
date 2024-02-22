`timescale 1ns / 1ps

module test;

reg clk = 0;
wire clk_d;

clk_div #(5) div(.clk(clk), .clk_d(clk_d));

always #5 clk = ~clk;

endmodule