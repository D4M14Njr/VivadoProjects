`timescale 1ns / 1ps

module divider #(DIV = 2)
(
    input clk,
    output reg cnt_d
);

wire [$clog2(DIV) - 1 : 0] cnt;

counter #(
    .WIDTH($clog2(DIV)),
    .STEP(1),
    .MODULE(DIV)
)
inst_counter
(
    .clk(clk),
    .reset(1'b0),
    .dir(1'b1),
    .cnt(cnt)
);

always@(posedge clk) 
begin
    if(cnt == (DIV-1))
        cnt_d <= ~cnt_d;
end

endmodule