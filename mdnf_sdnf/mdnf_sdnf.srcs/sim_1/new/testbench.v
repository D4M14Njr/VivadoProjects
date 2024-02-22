`timescale 1ns / 1ps

module testbench();

wire f_res;
reg [4:0] r;

sdnf func_1(.in(r), .f(f_res));
mdnf func_2(.in(r), .f(f_res));

always #10 r = r + 1;

initial
    begin
        r = 0;
        #320
        $finish;
    end
endmodule