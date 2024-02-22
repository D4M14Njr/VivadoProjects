`timescale 1ns / 1ps

module mux #(width = 1)(
    input [width - 1:0] a, [2**(width)-1:0]x,
    output Y);
    
assign Y = x[a];

endmodule