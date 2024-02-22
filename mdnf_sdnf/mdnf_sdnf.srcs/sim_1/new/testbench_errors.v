`timescale 1ns / 1ps

module testbench_errors();

reg [4:0] args;
reg clk;
wire sdnf_res, mdnf_res;
reg [0:31] reference_reg, error_reg_sdnf, error_reg_mdnf;

sdnf func_1 (.in(args), .f(sdnf_res));  
mdnf func_2 (.in(args), .f(mdnf_res));

initial
    begin
        reference_reg = 32'hd9d4db5e;  
        args = 0;
        clk = 0;
        error_reg_sdnf = 0;
        error_reg_mdnf = 0;
    end
    
always #10 clk = ~clk;

always@(posedge clk)
    begin
        error_reg_sdnf[args] = sdnf_res ~^ reference_reg[args]; 
        error_reg_mdnf[args] = mdnf_res ~^ reference_reg[args];
        args = args + 1'b1;
        if(args == 5'd0) 
            $finish;
    end
  
endmodule