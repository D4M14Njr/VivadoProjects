`timescale 1ns / 1ps

// ���������� ��������������� RS-������� �� �-��

module gated_rs_latch_nand(
    input r, s,
    input c,
    output reg q);

initial q = 0;

always @*
    q = ~(~(q & ~(c & r)) & ~(c & s));

endmodule
