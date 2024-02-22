`timescale 1ns / 1ps

module counter # (parameter WIDTH = 2, parameter MODULE = 8, parameter STEP = 1)(
    input [WIDTH-1:0] id,
    input iclk,
    input irst,
    input ien,
    input idir,
    output reg [WIDTH-1:0] ocount
);

always@(posedge iclk) 
begin
    if (irst) ocount <= 0;
    else if (ien) ocount <= id;
    else if (idir) ocount <= (ocount + STEP) % MODULE;
    else ocount <= (ocount - STEP) % MODULE;
end

endmodule
