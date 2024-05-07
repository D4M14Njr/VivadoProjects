module debouncer #(size = 3)(
    input clk, 
    input in_signal,
    input CLOCK_ENABLE,
    output reg out_signal,
    output reg out_signal_enable);

reg [1:0] sync_signal;
reg [size-1:0] counter;

initial begin
    sync_signal = 0; counter = 0;
    out_signal = 0; out_signal_enable = 0;
end
always @(posedge clk) begin
    sync_signal <= {sync_signal[0], in_signal};
    counter <= (sync_signal[1] ~^ out_signal) ?
    {size{1'd0}} : (CLOCK_ENABLE ? counter + 1 : counter);
    if (&(counter) & CLOCK_ENABLE)
        out_signal <= sync_signal[1];
    out_signal_enable <= &(counter) & CLOCK_ENABLE & sync_signal[1];
end
endmodule