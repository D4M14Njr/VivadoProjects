module main(
    input [3:0] digit,
    input en_button,
    input clk,
    input reset,
    output [7:0] an,
    output [7:0] seg);

reg [7:0] mask = 8'b11111110;
reg [31:0] number = 0;
wire led_clk;
wire deb_en, deb_reset;

seven_segment_led led(
    .AN_MASK(mask),
    .NUMBER(number),
    .RESET(1'b0),
    .clk(led_clk),
    .AN(an),
    .SEG(seg));

debouncer #(8) deb1( // change it to 128
    .clk(clk), 
    .in_signal(en_button),
    .CLOCK_ENABLE(1'b1),
    .out_signal(),
    .out_signal_enable(deb_en));
    
debouncer #(8) deb2(// change it to 128
    .clk(clk), 
    .in_signal(reset),
    .CLOCK_ENABLE(1'b1),
    .out_signal(),
    .out_signal_enable(deb_reset));


clk_div #(6) div(// change it to 1024
    .clk(clk),
    .clk_d(led_clk));
    
always@(posedge clk)
begin
    number = {number[31:4], digit};
    if (deb_reset) 
    begin
        mask = 8'b11111110;
        number = 0;
    end
    if (deb_en)
    begin
        mask = mask << 1;
        number = number << 4;
    end
end

endmodule