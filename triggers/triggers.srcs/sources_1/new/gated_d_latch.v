// D-ענטדדונ

module gated_d_latch(
    input d, c,
    output reg q);

initial q = 0;

always @*
    q = ~(~(~c & q) & ~(c & d));

endmodule

