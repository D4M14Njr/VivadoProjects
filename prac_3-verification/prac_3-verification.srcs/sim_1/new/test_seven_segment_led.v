`timescale 1ns / 1ps

module test_seven_segment_led;

reg clk = 0;
reg [7:0] mask;
reg [31:0] number;
reg [2:0] minus_pos;
reg negative;
reg reset = 0;
wire [7:0] an;
wire [7:0] seg;

seven_segment_led si(
    .AN_MASK(mask),
    .NUMBER(number),
    .RESET(reset),
    .clk(clk),
    .minus_pos(minus_pos),
    .negative(1),
    .AN(an),
    .SEG(seg));

initial
begin
    mask = 8'b1111_1000;
    number = 32'h0000_0af2;
    minus_pos = 0;
    negative = 0;
    #155
    mask = 8'b0111_1100;
    number = 32'ha000_0065;
    minus_pos = 0;
    negative = 0;
    #155
    mask = 8'b1111_1000;
    number = 32'h0000_00d1;
    minus_pos = 2;
    negative = 1;
    #155 reset = 1;
end

always #5 clk = ~clk;

endmodule
