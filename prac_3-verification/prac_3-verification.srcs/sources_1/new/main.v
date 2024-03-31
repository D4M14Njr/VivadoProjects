module main(
    input [15:0] inp,
    input en_button,
    input reset,
    input clk,
    output [7:0] an,
    output [7:0] seg);

integer i;

reg [7:0] mask = 8'b01111110;
reg [31:0] display = 0;
reg [2:0] first_digit = 0;
reg hold = 0;
reg error;

wire [31:0] result_out;
wire [2:0] current_state;
wire output_enable;
wire led_clk, calc_clk;
wire deb_en, deb_reset;
wire error_out;

fsm f(
    .data(inp),
    .input_enable(deb_en && !output_enable),
    .reset(deb_reset),
    .clk(calc_clk),
    .data_out(result_out),
    .output_enable(output_enable),
    .error_out(error_out),
    .current_state(current_state));
    
seven_segment_led led(
    .AN_MASK(mask),
    .NUMBER(display),
    .RESET(1'b0),
    .CE(1'b1),
    .clk(led_clk),
    .error_in(error),
    .AN(an),
    .SEG(seg));

debouncer #(8) deb1( // change it to 128
    .clk(calc_clk), 
    .in_signal(en_button),
    .CLOCK_ENABLE(1'b1),
    .out_signal(),
    .out_signal_enable(deb_en));
    
debouncer #(8) deb2( // change it to 128
    .clk(calc_clk), 
    .in_signal(reset),
    .CLOCK_ENABLE(1'b1),
    .out_signal(),
    .out_signal_enable(deb_reset));


clk_div #(4) div1( // change it to 2048
    .clk(clk),
    .clk_d(led_clk));

clk_div #(2) div2( // change it to 4
    .clk(clk),
    .clk_d(calc_clk));

always@(posedge clk)
begin
    if (deb_reset) 
    begin
        mask = 8'b01111110;
        hold = 0;
        error = 0;
    end
    if (output_enable & ~hold) 
    begin
        hold = 1;
        if (error_out)
        begin
            mask = 8'b0000_0000;
            display = 32'b0;
            error = 1;
        end
        else
        begin
            first_digit = 0;
            for (i = 0; i < 32; i = i + 1)
                if (result_out[i])
                    first_digit = i / 4;
            
            display = result_out;
            mask = 8'b1111_1111 << (first_digit + 3'b1);
        end
    end
    else if (~hold)
    begin
        first_digit = 0;
        for (i = 0; i < 16; i = i + 1)
            if (inp[i])
                first_digit = i / 4;

        mask = {1'b0, 7'b1111111 << (first_digit + 3'b1)};
        case(current_state)
            3'b001: display = {16'ha000, inp};
            3'b010: display = {16'hb000, inp};
            3'b011: display = {16'hc000, inp};
            3'b100: display = {16'hd000, inp};
        endcase
    end
end

endmodule
