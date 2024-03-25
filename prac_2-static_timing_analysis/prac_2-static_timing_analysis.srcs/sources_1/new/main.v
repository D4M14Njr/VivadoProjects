`timescale 1ns / 1ps

module main(
    input clk,
    input [31:0] a, b, c, d,
    output [64:0] out);

reg [31:0] r_a, r_b, r_c, r_d;
reg [64:0] r_out;

always@(posedge clk)
begin
    r_out <= r_a - r_b * r_c / r_d;
    r_a <= a; r_b <= b; r_c <= c; r_d <= d;
end

assign out = r_out;

endmodule
