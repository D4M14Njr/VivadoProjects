`timescale 1ns / 1ps

module dc #(width = 2) (
    input Ena,
    input [width - 1:0] a,
    output [2**(width)-1 :0] Y);

assign Y = !Ena ? 0 : 1 << a;

endmodule