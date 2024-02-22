`timescale 1ns / 1ps

module test_for_wis();
    
wire gated_rs_latch_nand_res;
reg [2:0] r;

gated_rs_latch_nand rl(.r(r[1]), .s(r[0]), .c(r[2]), .q(gated_rs_latch_nand_res));

always #10 r = r + 1;

initial
    begin
        r = 0;
        #80
        $finish;
    end

endmodule
