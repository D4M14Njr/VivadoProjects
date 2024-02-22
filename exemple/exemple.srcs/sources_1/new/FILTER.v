module FILTER #(size = 3) (
input CLK, CLOCK_ENABLE, IN_SIGNAL,
output reg OUT_SIGNAL, OUT_SIGNAL_ENABLE
);
reg [1:0] IN_SIGNAL_SYNC;
reg [size-1:0] counter;
initial
begin
IN_SIGNAL_SYNC = 0; counter = 0;
OUT_SIGNAL = 0; OUT_SIGNAL_ENABLE = 0;
end
always @(posedge CLK)
begin
IN_SIGNAL_SYNC <= {IN_SIGNAL_SYNC[0], IN_SIGNAL};
counter <= (IN_SIGNAL_SYNC[1] ~^ OUT_SIGNAL) ?
{size{1'd0}} : (CLOCK_ENABLE ? counter + 1 : counter);
if (&(counter) & CLOCK_ENABLE)
OUT_SIGNAL <= IN_SIGNAL_SYNC[1];
OUT_SIGNAL_ENABLE <= &(counter) & CLOCK_ENABLE & IN_SIGNAL_SYNC[1];
end
endmodule
