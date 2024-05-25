`timescale 1ns / 1ps

// асинхронный одноступенчатый RS-триггер 
// на элементах или-не с управляемым q0

module rs_latch_nor_wis(
    input r, s,
    input q0,
    output reg q);

always @*
    q = ~(r | ~(q0 | s));

endmodule