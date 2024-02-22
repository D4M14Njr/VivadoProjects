`timescale 1ns / 1ps

module cd #(width = 1) (
    input [2**(width)-1:0] a,
    output reg [ width - 1:0] Y);

integer n;

always @(a)
begin
    Y = 0;
    for(n = 0; n <= 2**(width)-1; n = n + 1)
        if(a[n]) Y = n;
end

endmodule