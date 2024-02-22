`timescale 1ns / 1ps

module func_dc(
    input [4:0] in,
    output f);
    
wire [3:0] w0, w1, w2, w3, w4, w5, w6, w7, w8, w9;

dc dc0(.Ena(~in[4]), .a({in[3], in[2]}), .Y(w0));
dc dc1(.Ena(in[4]), .a({in[3], in[2]}), .Y(w1));
   
dc dc2(.Ena(w0[0]), .a({in[1], in[0]}), .Y(w2));
dc dc3(.Ena(w0[1]), .a({in[1], in[0]}), .Y(w3));
dc dc4(.Ena(w0[2]), .a({in[1], in[0]}), .Y(w4));
dc dc5(.Ena(w0[3]), .a({in[1], in[0]}), .Y(w5));
   
dc dc6(.Ena(w1[0]), .a({in[1], in[0]}), .Y(w6));
dc dc7(.Ena(w1[1]), .a({in[1], in[0]}), .Y(w7));
dc dc8(.Ena(w1[2]), .a({in[1], in[0]}), .Y(w8));
dc dc9(.Ena(w1[3]), .a({in[1], in[0]}), .Y(w9));

assign f = w2[0]|w2[1]|w2[3]| 
           w3[0]|w3[3]| 
           w4[0]|w4[1]|w4[3]| 
           w5[1]| 
           w6[0]|w6[1]|w6[3]| 
           w7[0]|w7[2]|w7[3]| 
           w8[1]|w8[3]| 
           w9[0]|w9[1]|w9[2];

endmodule