module clk_div #(DIV = 2) (
    input clk,
    output reg clk_d);

wire [$clog2(DIV/2)-1:0] cnt;
    
counter #(.STEP(1), .MODULE(DIV/2)) cntr(
    .clk(clk),
    .reset(1'd0),
    .dir(1'd1),
    .enable(1'd1),
    .cnt(cnt));

initial clk_d = 0;

always@(posedge clk)
    if (cnt == 0) 
        clk_d = ~clk_d;

endmodule