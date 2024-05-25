// асинхронный одноступенчатый RS-триггер 
// на элементах и-не с управляемым q0

module rs_latch_nand_wis(
    input r, s,
    input q0,
    output reg q);

always @*
    q = ~(~s & ~(q0 & ~r));

endmodule