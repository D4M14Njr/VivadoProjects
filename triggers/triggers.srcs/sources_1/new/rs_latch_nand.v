// ����������� ��������������� RS-������� 
// �� ��������� �-��

module rs_latch_nand(
    input r, s,
    output reg q);

initial q = 0;

always @*
    q = ~(~s & ~(q & ~r));

endmodule
