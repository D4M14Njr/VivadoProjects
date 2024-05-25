`timescale 1ns / 1ps

module mealy_fsm_test;

reg [26:0] commands = 27'o411_002_100;
wire res1, res2;
reg [2:0] r;
reg clk = 0;

mealy_fsm #(0) fsm1(.a(r[2]), .b(r[1]), .c(r[0]), .d(res1), .clk(clk));
moore_fsm #(0) fsm2(.a(r[2]), .b(r[1]), .c(r[0]), .d(res2), .clk(clk));

always@(negedge clk)
begin 
    r <= commands[26:24];
    commands = commands << 3;
end
always #5 clk = ~clk;

initial #105 $finish;

endmodule
