`timescale 1ns / 1ps

// синхронный одноступенчатый RS-триггер на и-не

module gated_rs_latch_nand(
    input r, s,
    input c,
    output reg q);

initial q = 0;

always @*
    q = ~(~(q & ~(c & r)) & ~(c & s));

endmodule
