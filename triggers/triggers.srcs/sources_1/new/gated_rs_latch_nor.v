`timescale 1ns / 1ps

// ���������� ��������������� RS-������� �� ���-��

module gated_rs_latch_nor(
    input [1:0] in,
    input c,
    output reg q);

initial q = 0;

always @*
    q = (c | q) & (c | ~(in[1] | ~(q | in[0])));

endmodule
