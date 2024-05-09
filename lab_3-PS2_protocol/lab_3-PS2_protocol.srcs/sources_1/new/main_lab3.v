//module main(
//    input [15:0] inp,
//    input en_button,
//    input reset,
//    input clk, PS2_clk,
//    output [7:0] an,
//    output [7:0] seg,
//    output reg [2:0] result_led);

//reg [3:0] k;
//reg [7:0] mask = 8'b00011110;
//reg [31:0] display = 0;
//reg [3:0] first_one = 0;
//reg [2:0] minus_pos = 0;
//reg error = 0;
//reg [15:0] number = 0;

//wire [1:0] i, j;
//wire [31:0] result_out;
//wire output_enable;
//wire led_clk, calc_clk;
//wire deb_en, deb_reset;
//wire [1:0] error_out;
//wire mode;


//fsm f(
//    .data(inp),
//    .first_one(first_one),
//    .input_enable(deb_en && !output_enable),
//    .reset(deb_reset),
//    .clk(calc_clk),
//    .mode(mode),
//    .float_data_out(result_out),
//    .output_enable(output_enable),
//    .i(i), .j(j),
//    .error_out(error_out));

//seven_segment_led led(
//    .AN_MASK(mask),
//    .NUMBER(display),
//    .RESET(1'b0),
//    .clk(led_clk),
//    .minus_pos(minus_pos),
//    .negative(inp[15]),
//    .error_in(error_out),
//    .AN(an),
//    .SEG(seg));

//debouncer #(128) deb1( // change it to 128
//    .clk(calc_clk), 
//    .in_signal(en_button),
//    .CLOCK_ENABLE(1'b1),
//    .out_signal(),
//    .out_signal_enable(deb_en));
    
//debouncer #(128) deb2( // change it to 128
//    .clk(calc_clk), 
//    .in_signal(reset),
//    .CLOCK_ENABLE(1'b1),
//    .out_signal(),
//    .out_signal_enable(deb_reset));


//clk_div #(4096) div1( // change it to 4096
//    .clk(clk),
//    .clk_d(led_clk));

//clk_div #(20) div2( // change it to 11
//    .clk(clk),
//    .clk_d(calc_clk));

//wire PS2_r_o;
//wire [3:0] PS2_out;

//PS2_manager ps2m(
//    .clk(clk),
//    .PS2_dat(inp),
//    .PS2_clk(PS2_clk),
//    .ready_output(PS2_r_o),
//    .out(PS2_out));

//always@(posedge clk)
//begin
//    case(out) 
//        6'h2F:
//        6'h3F:
//        default:
//    endcase
//    if((|(number[15:12])))
        
//end

//always@(posedge clk)
//begin
//    if (mode) begin
//        mask = 8'b0000_0000;
//        if (error_out == 0)
//            display <= result_out;
//    end
//    else begin
//        first_one = 4'd15;
//        for (k = 1'b0; k < 4'd15; k = k + 1'b1)
//            if (inp[k])
//                first_one = k;
        
//        if (first_one == 4'd15)
//            minus_pos = inp[15];
//        else
//            minus_pos = first_one / 3'd4 + inp[15];
        
//        if (j == 2'b11)
//            mask = {2'b01, 5'b11111 << (minus_pos + 1'b1)};
//        else
//            mask = {3'b0, 5'b11111 << (minus_pos + 1'b1)};

//        case({i, j})
//            4'b0000: display <= {16'ha110, 1'b0, inp[14:0]};
//            4'b0001: display <= {16'ha120, 1'b0, inp[14:0]};
//            4'b0010: display <= {16'ha130, 1'b0, inp[14:0]};
//            4'b0100: display <= {16'ha210, 1'b0, inp[14:0]};
//            4'b0101: display <= {16'ha220, 1'b0, inp[14:0]};
//            4'b0110: display <= {16'ha230, 1'b0, inp[14:0]};
//            4'b1000: display <= {16'ha310, 1'b0, inp[14:0]};
//            4'b1001: display <= {16'ha320, 1'b0, inp[14:0]};
//            4'b1010: display <= {16'ha330, 1'b0, inp[14:0]};
//            4'b0011: display <= {16'hb100, 1'b0, inp[14:0]};
//            4'b0111: display <= {16'hb200, 1'b0, inp[14:0]};
//            4'b1011: display <= {16'hb300, 1'b0, inp[14:0]};
//        endcase
//    end
//end

//always@*
//begin
//    if (mode) begin
//        case(i)
//            2'b00: result_led <= 3'b001;
//            2'b01: result_led <= 3'b010;
//            2'b10: result_led <= 3'b100;
//            default: result_led <= 3'b000;
//        endcase
//    end
//    else result_led <= 3'b000;
     
//end

//endmodule
