`timescale 1ns / 1ps

module test;

reg clk = 0;
always #5 clk <= ~clk;

wire [3:0] data_out;
wire empty, full, valid;

fifo_one_clk uut (
    .clk(clk), 
    .enable(1), 
    .reset(0), 
    .write_mode(1), 
    .read_mode(0),
    .data_in(4'h9),
    .data_out(data_out),
    .full(full), 
    .empty(empty), 
    .valid(valid));

endmodule
