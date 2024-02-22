`timescale 1ns / 1ps

// T-ענטדדונ 

module t_flipflop_ds(
    input t,
    output reg q
    );
    
initial q = 0;

always @(negedge t)
    q <= ~q;
    
endmodule
