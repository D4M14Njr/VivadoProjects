module debouncer #(MODULE = 8)(
    input clk, 
    input in_signal,
    input CLOCK_ENABLE,
    output reg out_signal,
    output reg out_signal_enable);

wire sync_signal;
wire [$clog2(MODULE)-1:0] counter_res;

initial
begin
    out_signal = 0;
    out_signal_enable = 0;
end

synchronizer sinc(.in(in_signal), .clk(clk), .out(sync_signal));

counter #(.MODULE(MODULE), .STEP(1'b1)) cntr(
    .clk(clk), 
    .reset(sync_signal~^out_signal), 
    .enable(CLOCK_ENABLE), 
    .dir(1'b1), 
    .cnt(counter_res));

always@(posedge clk)
begin
    if (& (counter_res) & CLOCK_ENABLE)
        out_signal <= sync_signal;
end

always@(posedge clk) 
    out_signal_enable <= & (counter_res) & sync_signal & CLOCK_ENABLE;

endmodule
