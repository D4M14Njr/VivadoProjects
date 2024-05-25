module synchronizer(
    input in, clk,
    output out);

reg a, b;

always@(posedge clk)
begin
    b <= a;
    a <= in;
end

assign out = b;

endmodule
