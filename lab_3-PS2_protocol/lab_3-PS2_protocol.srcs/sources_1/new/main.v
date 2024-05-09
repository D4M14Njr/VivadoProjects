module main(
    input PS2_dat,
    input PS2_clk,
    input clk,
    output [7:0] an,
    output [7:0] seg,
    output reg [2:0] result_led);

reg [7:0] mask = 8'b00011110;
reg [31:0] display = 0;
reg [4:0] first_one = 5'd16;
reg [2:0] digit_pos = 0;
reg error = 0;

reg [16:0] number = 0;

wire [1:0] i, j;
wire [31:0] result_out;
wire fsm_r_o;
wire led_clk, calc_clk;
wire [1:0] error_out;
wire mode;

wire kb_r_o;
wire [6:0] kb_out;

PS2_manager ps2_m(
    .clk(clk),
    .PS2_dat(PS2_dat),
    .PS2_clk(PS2_clk),
    .ready_output(kb_r_o),
    .out(kb_out));

fsm f(
    .data(number),
    .first_one(first_one),
    .input_enable(kb_r_o & (kb_out[5:4] == 2'b01) & ~fsm_r_o),
    .reset(kb_r_o & (kb_out[5:4] == 2'b10)),
    .clk(calc_clk),
    .mode(mode),
    .float_data_out(result_out),
    .ready_output(fsm_r_o),
    .i(i), .j(j),
    .error_out(error_out));

seven_segment_led led(
    .AN_MASK(mask),
    .NUMBER(display),
    .RESET(1'b0),
    .clk(led_clk),
    .minus_pos(digit_pos),
    .negative(number[16]),
    .error_in(error_out),
    .AN(an),
    .SEG(seg));

clk_div #(4) div1( // change it to 4096
    .clk(clk),
    .clk_d(led_clk));

clk_div #(2) div2( // change it to 20
    .clk(clk),
    .clk_d(calc_clk));



always@(posedge clk)
begin
    if (mode) begin
        mask <= 0;
        if (error_out == 0)
            display <= result_out;
    end
    else begin
        case({i, j})
            4'b0000: display <= {16'ha110, number[15:0]};
            4'b0001: display <= {16'ha120, number[15:0]};
            4'b0010: display <= {16'ha130, number[15:0]};
            4'b0100: display <= {16'ha210, number[15:0]};
            4'b0101: display <= {16'ha220, number[15:0]};
            4'b0110: display <= {16'ha230, number[15:0]};
            4'b1000: display <= {16'ha310, number[15:0]};
            4'b1001: display <= {16'ha320, number[15:0]};
            4'b1010: display <= {16'ha330, number[15:0]};
            4'b0011: display <= {16'hb100, number[15:0]};
            4'b0111: display <= {16'hb200, number[15:0]};
            4'b1011: display <= {16'hb300, number[15:0]};
        endcase

        if (kb_r_o)
            case(kb_out[6:4])
                3'b000:
                    if (digit_pos < 3'b100) begin
                        if (|(kb_out[3:0]) | digit_pos != 0) begin
                            number <= {number[16], number[11:0], kb_out[3:0]};
                            mask <= {mask[7:5], mask[4:0] << 1};
                            digit_pos <= digit_pos + 1;
                            if (digit_pos == 0)
                                casex(kb_out[3:0])
                                    4'b000x: first_one <= 0;
                                    4'b00xx: first_one <= 1;
                                    4'b0xxx: first_one <= 2;
                                    4'bxxxx: first_one <= 3;
                                endcase
                            else
                                first_one <= first_one + 4;
                        end
                    end
                3'b001:
                    if (~fsm_r_o) begin
                        number <= 0;
                        first_one <= 5'd16;
                        digit_pos <= 0;
                        if (j == 2'b11)
                            mask <= 8'b0011_1110;
                        else
                            mask <= 8'b0001_1110;
                    end
                3'b010: begin
                    number <= 0;
                    first_one <= 5'd16;
                    digit_pos <= 0;
                    mask <= 8'b0001_1110;
                end
                3'b011: begin
                    number <= {number[16], 4'b0, number[15:4]};
                    if (digit_pos != 0) begin
                        first_one <= first_one - 4;
                        digit_pos <= digit_pos - 1;
                        mask <= {mask[7:5], 1'b1, mask[4:1]}; 
                    end
                    else if (number[15:0] == 0)
                        first_one <= 5'd16;
                end
                3'b100: begin
                    number <= {~number[16], number[15:0]};
                    if (|(number[15:0]))
                        if (number[16])
                            mask <= {mask[7:5], 1'b1, mask[3:0]};
                        else
                            mask <= {mask[7:5], mask[4:0] << 1};
                end
            endcase
    end
end

always@*
begin
    if (mode) begin
        case(i)
            2'b00: result_led <= 3'b001;
            2'b01: result_led <= 3'b010;
            2'b10: result_led <= 3'b100;
            default: result_led <= 3'b000;
        endcase
    end
    else result_led <= 3'b000;
end

endmodule
