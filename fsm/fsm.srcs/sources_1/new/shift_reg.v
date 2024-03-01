`timescale 1ns / 1ps

module shift_reg(
    input clk,
    input en,
    input [2:0] mode,
    input [3:0] data,
    output reg [3:0] out
    );

always@(posedge clk)
begin
    if (en)
        if (mode == 0)
        begin
            out <= out << 1;
        end
        else if (mode == 1)
        begin
            out <= {out[2:0], out[3]};
        end
        else if (mode == 2)
        begin
            out <= data;
        end
end
endmodule;
