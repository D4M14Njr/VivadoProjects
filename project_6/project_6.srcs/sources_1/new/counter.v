`timescale 1ns / 1ps

module counter #(WIDTH = 2, MODULE = 8, STEP = 1) (
    input clk,
    input reset,
    input dir,
    output reg [WIDTH - 1 : 0] cnt);

always@(posedge clk) begin
    if(reset)
        cnt <= 0;
    else if(dir)
        cnt <= (cnt + STEP) % MODULE;
    else
        cnt <= (cnt - STEP) % MODULE;
end

endmodule
