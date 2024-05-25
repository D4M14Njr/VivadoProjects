`timescale 1ns / 1ps

// асинхронный одноступенчатый RS-триггер 
// на элементах или-не

module rs_latch_nor(
    input r, s,
    output reg q);

initial q = 0;

always @*
    q = ~(r | ~(q | s));

endmodule