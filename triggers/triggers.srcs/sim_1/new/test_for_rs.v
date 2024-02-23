`timescale 1ns / 1ps

module test_for_rs;
    
wire gated_d_latch_res;
reg [1:0] r;

gated_d_latch tr(.c(r[1]), .d(r[0]), .q(gated_d_latch_res));

always #10 r = r + 1;

initial
begin
    r = 0;
    #40
    $finish;
end

endmodule
