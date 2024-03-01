`timescale 1ns / 1ps

module new_test;
    
wire jk_flipflop_res;
reg [1:0] r;
reg clk;

jk_flipflop trt(.c(clk), .j(r[1]), .k(r[0]), .q(jk_flipflop_res));

initial
begin
    clk = 0;
    r = 0;
    #80
    $finish;
end

always #5 clk = ~clk;
always #10 r = r + 1;

endmodule
