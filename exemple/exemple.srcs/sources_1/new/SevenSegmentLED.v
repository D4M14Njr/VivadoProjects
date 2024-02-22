module SevenSegmentLED (
input clk,
input RESET,

input [31:0] NUMBER,

input [7:0] AN_MASK,
output [7:0] AN,

output reg [6:0] SEG
);
reg [7:0] AN_REG = 0;
assign AN = AN_REG | AN_MASK;
reg [2:0] digit_counter;
wire [3:0] NUMBER_SPLITTER [0:7];
genvar i;
generate
for (i = 0; i < 8; i = i + 1)
begin
assign NUMBER_SPLITTER[i] = NUMBER[((i+1)*4-1)-:4];
end
endgenerate
initial begin
digit_counter = 0;
end
always @(posedge clk or posedge RESET)
digit_counter <= RESET ? 0 : digit_counter + 3'b1;

always @ (digit_counter)
begin

case (NUMBER_SPLITTER[digit_counter])
4'h0: SEG <= 7'b1000000;
4'h1: SEG <= 7'b1111001;
4'h2: SEG <= 7'b0100100;
4'h3: SEG <= 7'b0110000;
4'h4: SEG <= 7'b0011001;
4'h5: SEG <= 7'b0010010;
4'h6: SEG <= 7'b0000010;
4'h7: SEG <= 7'b1111000;
4'h8: SEG <= 7'b0000000;
4'h9: SEG <= 7'b0010000;
4'ha: SEG <= 7'b0001000;
4'hb: SEG <= 7'b0000011;
4'hc: SEG <= 7'b1000110;
4'hd: SEG <= 7'b0100001;
4'he: SEG <= 7'b0000110;
4'hf: SEG <= 7'b0001110;
default: SEG <= 7'b1111111;
endcase

case (digit_counter)
3'd0: AN_REG <= 8'b11111110;
3'd1: AN_REG <= 8'b11111101;
3'd2: AN_REG <= 8'b11111011;
3'd3: AN_REG <= 8'b11110111;
3'd4: AN_REG <= 8'b11101111;
3'd5: AN_REG <= 8'b11011111;
3'd6: AN_REG <= 8'b10111111;
3'd7: AN_REG <= 8'b01111111;
default: AN_REG <= 8'b11111111;
endcase
end
endmodule