`timescale 1ns / 1ps

module testbench;

reg [4:0] args;
reg clk;
wire func1_res, func2_res, func3_res;
reg [0:31] reference_reg, error_reg_func1, error_reg_func2, error_reg_func3;

func_mux func_1 (.in(args), .f(func1_res));  
func_dc func_2 (.in(args), .f(func2_res));
func_pri func_3 (.in(args), .f(func3_res));

initial
    begin
        reference_reg = 32'hd9d4db5e;  
        args = 0;
        clk = 0;
        error_reg_func1 = 0;
        error_reg_func2 = 0;
        error_reg_func3 = 0;
    end
    
always #10 clk = ~clk;

always@(posedge clk)
    begin
        error_reg_func1[args] = func1_res ~^ reference_reg[args];
        error_reg_func2[args] = func2_res ~^ reference_reg[args];
        error_reg_func3[args] = func3_res ~^ reference_reg[args]; 
        
        args = args + 1'b1;
        if(args == 5'd0) 
            $finish;
    end
  
endmodule