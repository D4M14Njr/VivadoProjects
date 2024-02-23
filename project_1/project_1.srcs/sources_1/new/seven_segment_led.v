module seven_segment_led(
    input [7:0] AN_MASK,
    input [31:0] NUMBER,
    input RESET,
    input clk,
    output [7:0] AN,
    output reg [7:0] SEG);

reg [7:0] AN_REG = 0;
wire [3:0] NUMBER_SPLITTER [0:7];
reg [2:0] digit_pos = 0;

genvar i;
generate
    for (i = 0; i < 8; i = i + 1)
    begin
        assign NUMBER_SPLITTER[i] = NUMBER[((i+1)*4-1)-:4];
    end
endgenerate

assign AN = AN_REG | AN_MASK;

always@(posedge clk or posedge RESET)
    if (RESET) digit_pos = 0;
    else digit_pos = digit_pos + 1;

always@(digit_pos)
begin
    case(NUMBER_SPLITTER[digit_pos])
        4'h0: SEG <= 8'b11000000;
        4'h1: SEG <= 8'b11111001;
        4'h2: SEG <= 8'b10100100;
        4'h3: SEG <= 8'b10110000;
        4'h4: SEG <= 8'b10011001;
        4'h5: SEG <= 8'b10010010;
        4'h6: SEG <= 8'b10000010;
        4'h7: SEG <= 8'b11111000;
        4'h8: SEG <= 8'b10000000;
        4'h9: SEG <= 8'b10010000;
        4'ha: SEG <= 8'b10001000;
        4'hb: SEG <= 8'b10000011;
        4'hc: SEG <= 8'b11000110;
        4'hd: SEG <= 8'b10100001;
        4'he: SEG <= 8'b10000110;
        4'hf: SEG <= 8'b10001110;
        default: SEG <= 8'b11111111;
    endcase
    
    AN_REG <= ~(8'd1 << digit_pos);
end

endmodule
