module counter #(MODULE = 3, STEP = 1) (
    input clk,
    input reset,
    input dir,
    output reg [$clog2(MODULE)-1:0] cnt);

initial cnt = 0;

always@(negedge clk) 
begin
    if (reset)
        cnt = 0;
    else if (dir)
        cnt = (cnt + STEP) % MODULE;
    else
        cnt = (MODULE + (cnt - STEP)) % MODULE;
end

endmodule