`timescale 1ns / 1ps

module func_pri(
    input [4:0] in,
    output f);
    
wire [31:0] w;
                                 
dc #(5) dc(.Ena(1'b1), .a(in), .Y(w));

cd cd(
    .a({w[0]|w[1]|w[3]|w[4]|w[7]|
        w[8]|w[9]|w[11]|w[13]|w[16]|
        w[17]|w[19]|w[20]|w[22]|w[23]|
        w[25]|w[27]|w[28]|w[29]|w[30], 1'b1}),
    .Y(f));
    
endmodule