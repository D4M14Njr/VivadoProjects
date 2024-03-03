`timescale 1ns / 1ps

module main(
    input clk,
    input [127:0] in,
    output [64:0] out);

reg [127:0] ff1;
reg [64:0] ff2;

always@(posedge clk)
begin
    ff1 <= in;
    ff2 <= ff1[127:96] - ff1[95:64] * ff1[63:32] / ff1[31:0];
end

assign out = ff2;

endmodule
