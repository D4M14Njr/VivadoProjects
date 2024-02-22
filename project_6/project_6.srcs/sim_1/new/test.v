`timescale 1ns / 1ps

module test;

reg clk;

wire cnt_d;

divider #(3) div(
    .clk(clk),
    .cnt_d(cnt_d)
);

always #10 clk = ~clk;

initial begin
    clk = 0;
end

endmodule
