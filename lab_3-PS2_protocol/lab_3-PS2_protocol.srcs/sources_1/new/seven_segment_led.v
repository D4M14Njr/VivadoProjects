module seven_segment_led(
    input [7:0] AN_MASK,
    input [31:0] NUMBER,
    input RESET,
    input clk,
    input [2:0] minus_pos,
    input negative,
    input [1:0] error_in,
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

always@(posedge clk)
    digit_pos <= RESET ? 0: digit_pos + 3'b1;   

always@*
begin
    if (error_in == 2'b01) // ������� InFError
        case (digit_pos)
            3'b111: SEG <= 8'b11111001;
            3'b110: SEG <= 8'b10101011;
            3'b101: SEG <= 8'b10001110;
            3'b100: SEG <= 8'b10000110;
            3'b011: SEG <= 8'b10101111;
            3'b010: SEG <= 8'b10101111;
            3'b001: SEG <= 8'b10100011;
            3'b000: SEG <= 8'b10101111;
            default: SEG <= 8'b11111111;
        endcase
    else if (error_in == 2'b10) // ������� nAnError
        case (digit_pos)
            3'b111: SEG <= 8'b10101011;
            3'b110: SEG <= 8'b10001000;
            3'b101: SEG <= 8'b10101011;
            3'b100: SEG <= 8'b10000110;
            3'b011: SEG <= 8'b10101111;
            3'b010: SEG <= 8'b10101111;
            3'b001: SEG <= 8'b10100011;
            3'b000: SEG <= 8'b10101111;
            default: SEG <= 8'b11111111;
        endcase
    else if (negative & digit_pos == minus_pos) SEG <= 8'b10111111; //  �����
    else    
        case (NUMBER_SPLITTER[digit_pos])
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
