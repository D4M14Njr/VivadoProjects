// динимический одноступенчатый RS-триггер

module dyn_rs_latch(
    input r, s,
    input c,
    output reg q);
    
initial q = 0;

always@(posedge c)
    q = ~(~(q & ~(c & r)) & ~(c & s));

endmodule