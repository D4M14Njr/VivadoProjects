module main(
    input [7:0] inp,
    input en_button,
    input reset,
    input clk,
    output [7:0] an,
    output [7:0] seg);

//integer i;

reg [7:0] mask = 8'b01111110;
reg signed [7:0] number;
reg [7:0] operand;
reg [16:0] result;
reg [31:0] display = 0;
reg negative = 0;
reg [2:0] first_digit = 0;
reg hold = 0;

wire [16:0] res;
wire [2:0] current_state;
wire R_O;
wire led_clk;
wire deb_en, deb_reset;

fsm f(
    .data(number),
    .R_I(deb_en),
    .reset(deb_reset),
    .clk(new_clk),
    .res(res),
    .R_O(R_O),
    .current_state(current_state));

seven_segment_led led(
    .AN_MASK(mask),
    .NUMBER(display),
    .RESET(1'b0),
    .clk(led_clk),
    .minus_pos(first_digit),
    .negative(negative),
    .AN(an),
    .SEG(seg));

debouncer #(128) deb1( // change it to 128
    .clk(clk), 
    .in_signal(en_button),
    .CLOCK_ENABLE(1'b1),
    .out_signal(),
    .out_signal_enable(deb_en));
    
debouncer #(128) deb2( // change it to 128
    .clk(clk), 
    .in_signal(reset),
    .CLOCK_ENABLE(1'b1),
    .out_signal(),
    .out_signal_enable(deb_reset));


clk_div #(2048) div( // change it to 2048
    .clk(clk),
    .clk_d(led_clk));

clk_div #(4) div2( // change it to 4
    .clk(clk),
    .clk_d(new_clk));

always@(posedge clk)
begin
    if (deb_reset) 
    begin
        mask <= 8'b01111110;
        hold <= 0;
    end
    
    if (R_O) 
    begin
        result = res;
        hold = 1;
        if (res[16])
        begin
            result = ~result + 1'b1;
            negative = 1;
        end
        else negative = 0;
        
        if (|(result[15:12]))
            first_digit = 3;
        else if (|(result[11:8]))
            first_digit = 2;
        else if (|(result[7:4]))
            first_digit = 1;
        else
            first_digit = 0;
        
        first_digit = first_digit + negative;
        
//        for (i = 0; i < 16; i = i + 1)
//            if (result[i])
//                first_digit = i / 4 + negative;
        
        display = {16'b0, result[15:0]};
        mask = 8'b1111_1111 << (first_digit + 3'b1);
    end
    
    if (~hold)
    begin
        operand = inp;
        number = inp;
        
        if (operand[7])
            begin
                operand = ~operand + 1'b1;
                negative = 1;
            end
        else negative = 0;
        
        if (|(operand[7:4]))
            first_digit = 1;
        else first_digit = 0;
        
        first_digit = first_digit + negative;
         
//        for (i = 0; i < 8; i = i + 1)
//            if (operand[i])
//                first_digit = i / 4 + negative;

        mask = {1'b0, 7'b1111111 << (first_digit + 3'b1)};
        case(current_state)
            3'b001: display = {24'ha00000, operand};
            3'b010: display = {24'hb00000, operand};
            3'b011: display = {24'hc00000, operand};
            3'b100: display = {24'hd00000, operand};
        endcase
    end
end

endmodule
