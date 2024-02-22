`timescale 1ns / 1ps

// синхронный JK-триггер 

module jk_flipflop(
    input j, k, c,
    output reg q);
    
initial q = 0;

always @(posedge c)
    q = ~(~(j & ~q & c) & ~(~k & q & c) & ~(q & ~c));
    
endmodule
