`timescale 1ns / 1ps

module divider #(DIV = 2) (
    input irst,
    input iclk,
    output oceo
    );
    
wire cnt;
    
counter #(.WIDTH($clog2(DIV)), .STEP(1), .MODULE(DIV)) inst_counter(
    .id(),
    .iclk(iclk),
    .irst(irst),
    .ien(1'b0),
    .idir(1'b1),
    .ocount(cnt));
always@*
    if (cnt == (DIV - 1)) oceo <= ~oceo;
    
endmodule
