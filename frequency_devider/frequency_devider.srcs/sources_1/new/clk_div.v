module clk_div #(DIV = 2) (
    input clk,
    output reg clk_d);

wire [$clog2(DIV)-1:0] cnt;
    
counter #(.STEP(1), .MODULE(DIV)) cntr(
    .clk(clk),
    .reset(1'd0),
    .dir(1'd1),
    .cnt(cnt));

initial clk_d = clk;

always@(negedge clk)
    if (cnt == 0)
        clk_d = ~clk_d;
        
always@(posedge clk)
    if (cnt == DIV/2 + 1)
        clk_d = ~clk_d;

endmodule