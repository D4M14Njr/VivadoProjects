`timescale 1ns / 1ps

module mdnf(
    input [4:0] in,
    output f
    );
    
assign f = (!in[2] && in[0]) || (!in[4] && !in[2] && !in[1]) || 
           (in[4] && in[2] && !in[0]) || (in[3] && !in[1] && in[0]) || 
           (!in[3] && !in[1] && !in[0]) || (!in[3] && in[1] && in[0]);
    
endmodule
