`timescale 1ns / 1ps

// двухступенчатый синхронный RS-триггер

module ts_rs_latch(
    input r, s,
    input c,
    output reg q);

reg res;

initial 
begin
    res = 0;
    q = 0;
end

always@(posedge c)
begin
    res = ~(~(res & ~(c & r)) & ~(c & s));
    q = ~(~(q & ~(~(c & c) & ~res)) & ~(~(c & c) & res));
end

endmodule
