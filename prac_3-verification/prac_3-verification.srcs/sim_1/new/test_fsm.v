`timescale 1ns / 1ps

module test_fsm;

wire [16:0] res;
wire R_O;
wire [2:0] state;
reg R_I = 0;
reg signed [7:0] a, b, c, d, r; 
reg clk = 0;
reg reset = 0;

fsm f(.data(r), .clk(clk), .R_I(R_I), .reset(reset), .res(res), .R_O(R_O), .current_state(state));

initial
begin
    #20
    repeat(3)
    begin
        r = a;
        R_I = 1;
        #10
        R_I = 0;
        #30
        r = b;
        R_I = 1;
        #10
        R_I = 0;
        #30
        r = c;
        R_I = 1;
        #10
        R_I = 0;
        #30
        r = d;
        R_I = 1;
        #10
        R_I = 0;
        #30;
    end
end

initial
begin
    a = 15;
    b = -2;
    c = 3;
    d = 3;
    #180
    a = 7;
    b = 6;
    c = 3;
    d = 1;
    #160
    a = 54;
    b = -38;
    c = -11;
    d = 6;
    #180 reset = 1;
    #20 $finish;
end

always #5 clk = ~clk;

endmodule

