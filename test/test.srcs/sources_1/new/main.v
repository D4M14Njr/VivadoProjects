`timescale 1ns / 1ps

module main(
    input wire [4:0] in,
    output wire f
    );
    
assign f = ~(~((in[4] && in[2] || in[3]) && in[0]) || in[1]);
    
endmodule
