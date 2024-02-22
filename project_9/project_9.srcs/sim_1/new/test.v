`timescale 1ns / 1ps

module test;

reg clk;
reg [3:0] in;
wire [10:0] res;

main m(.a(in[0]), .b(in[1]), .c(in[2]), .d(in[3]), .res(res));

always #10 clk = ~clk;

always@(posedge clk) 
    in = in + 1; 

initial 
begin
    clk = 0;
    in = 0;
end

endmodule
