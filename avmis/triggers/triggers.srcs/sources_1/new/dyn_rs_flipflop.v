// двухступенчатый синхронный RS-триггер

module dyn_rs_flipflop(
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
    res = ~(~(res & ~(c & r)) & ~(c & s));

always@(negedge c)
    q = ~(~(q & ~(~(c & c) & ~res)) & ~(~(c & c) & res));

endmodule
