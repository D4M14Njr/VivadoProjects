module PS2_DC(
    input [7:0] keycode,
    output reg [6:0] out);

reg [7:0] NUMBERS [0:15];
parameter [7:0] ENTER_CODE = 8'h5A, 
                RESET_CODE = 8'h2D, 
                BACKSPACE_CODE = 8'h66,
                MINUS_CODE = 8'h4E;

initial begin
    NUMBERS[0] = 8'h45;
    NUMBERS[1] = 8'h16;
    NUMBERS[2] = 8'h1E;
    NUMBERS[3] = 8'h26;
    NUMBERS[4] = 8'h25;
    NUMBERS[5] = 8'h2E;
    NUMBERS[6] = 8'h36;
    NUMBERS[7] = 8'h3D;
    NUMBERS[8] = 8'h3E;
    NUMBERS[9] = 8'h46;
    NUMBERS[10] = 8'h1C;
    NUMBERS[11] = 8'h32;
    NUMBERS[12] = 8'h21;
    NUMBERS[13] = 8'h23;
    NUMBERS[14] = 8'h24;
    NUMBERS[15] = 8'h2B;
    
    out = 0;
end

always@(keycode)
begin
    case(keycode)
        NUMBERS[0] : out = 7'h0;
        NUMBERS[1] : out = 7'h1;
        NUMBERS[2] : out = 7'h2;
        NUMBERS[3] : out = 7'h3;
        NUMBERS[4] : out = 7'h4;
        NUMBERS[5] : out = 7'h5;
        NUMBERS[6] : out = 7'h6;
        NUMBERS[7] : out = 7'h7;
        NUMBERS[8] : out = 7'h8;
        NUMBERS[9] : out = 7'h9;
        NUMBERS[10]: out = 7'hA;
        NUMBERS[11]: out = 7'hB;
        NUMBERS[12]: out = 7'hC;
        NUMBERS[13]: out = 7'hD;
        NUMBERS[14]: out = 7'hE;
        NUMBERS[15]: out = 7'hF;
        
        ENTER_CODE    : out = 7'h1F;
        RESET_CODE    : out = 7'h2F;
        BACKSPACE_CODE: out = 7'h3F;
        MINUS_CODE    : out = 7'h4F;
        
        default: out = 0;
    endcase
end

endmodule
