`timescale 1ns / 1ps

module testbench();

reg [5:0] args;
reg clk;
wire res;
reg [0:31] reference_reg, error_reg;

initial
begin
    reference_reg = 31'h440444;
    args = 5'b00000;
    clk = 0;
    error_reg = 0;
end

always #10 clk = ~clk;

always@(posedge clk)
begin
    error_reg[args] = res ~^ reference_reg[args];
    args = args + 1;
    if(args == 6'd33)
        $finish;
end

main mod_f (.in(args[4:0]), .f(res));

endmodule
