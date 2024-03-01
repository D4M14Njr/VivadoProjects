`timescale 1ns / 1ps

module test_for_grs;
    
wire gated_rs_latch_nor_res;
wire gated_rs_latch_nand_res;
reg [2:0] r;


gated_rs_latch_nor grl1 (.in(r[1:0]), .c(r[2]), .q(gated_rs_latch_nor_res));
gated_rs_latch_nand grl2 (.in(r[1:0]), .c(r[2]), .q(gated_rs_latch_nand_res));

always #10 r = r + 1;

initial
begin
    r = 0;
    #80
    $finish;
end

endmodule
