module led_controller(
    input button_in, clk,
    output reg led_out = 0);

wire out_signal_enable;   

debouncer #(8) dbnc(
    .clk(clk),
    .in_signal(button_in),
    .CLOCK_ENABLE(1'b1),
    .out_signal(),
    .out_signal_enable(out_signal_enable));

always@(posedge clk) 
    if (out_signal_enable)
        led_out = ~led_out;

endmodule
