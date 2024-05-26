`timescale 1ns / 1ps

module minus_test;

reg clk = 0;
always #5 clk <= ~clk;

wire [7:0] AN;        
wire [7:0] CATH;      
wire [2:0] result_led;
reg PS2_dat = 0, PS2_clk = 0;
reg [0:10] release_button = 10'b00000111111;
reg [0:10] NUMBERS [0:15];
parameter [0:10] ENTER_CODE = 11'b00101101011, 
                 RESET_CODE = 11'b01011010011, 
                 BACKSPACE_CODE = 11'b00110011011,
                 MINUS_CODE = 11'b00111001011;

initial begin
    NUMBERS[0] = 11'b01010001001;
    NUMBERS[1] = 11'b00110100001;
    NUMBERS[2] = 11'b00111100011;
    NUMBERS[3] = 11'b00110010001;
    NUMBERS[4] = 11'b01010010001;
    NUMBERS[5] = 11'b00111010011;
    NUMBERS[6] = 11'b00110110011;
    NUMBERS[7] = 11'b01011110001;
    NUMBERS[8] = 11'b00111110001;
    NUMBERS[9] = 11'b00110001001;
    NUMBERS[10] = 11'b00011100001;
    NUMBERS[11] = 11'b00100110001;
    NUMBERS[12] = 11'b01000010011;
    NUMBERS[13] = 11'b01100010001;
    NUMBERS[14] = 11'b00010010011;
    NUMBERS[15] = 11'b01101010011;
end

main ma(
    .PS2_dat(PS2_dat),
    .PS2_clk(PS2_clk),
    .clk(clk),
    .an(AN),
    .seg(CATH),
    .result_led(result_led));

task enter_num;
    input [16:0] inp;
integer i;
reg [2:0] first_digit;
reg [3:0] arr [0:3];
begin
    arr[3] = inp[15:12]; arr[2] = inp[11:8];
    arr[1] = inp[7:4]; arr[0] = inp[3:0];
    first_digit = get_first_digit({1'b0, inp[15:0]});
    for (i = first_digit; i >= 0; i = i - 1) begin
        press(NUMBERS[arr[i]]);
        #100;
    end
    if (inp[16]) begin
        press(MINUS_CODE);
        #100;
    end
end
endtask

task press;
    input [0:10] packet;
integer i;
begin
    for (i = 0; i < 11; i = i + 1) begin        
        @(posedge clk) PS2_dat = release_button[i]; PS2_clk = 0;
        @(posedge clk) PS2_clk = 1;
    end
    for (i = 0; i < 11; i = i + 1) begin        
        @(posedge clk) PS2_dat = packet[i]; PS2_clk = 0;
        @(posedge clk) PS2_clk = 1;
    end
end
endtask

function [2:0] get_first_digit;
    input [16:0] number;
integer i;
reg [2:0] first_digit;
begin
    first_digit = 0;
    for (i = 0; i < 16; i = i + 1)
        if (number[i])
            first_digit = i / 4;
            
    get_first_digit = first_digit + number[16];
end
endfunction

initial
begin
    enter_num(17'b0_0000_1001_0110_0000);
    #100;
    press(MINUS_CODE);
    #100;
    press(MINUS_CODE);
    #100;
    press(MINUS_CODE);
    #100;
    press(BACKSPACE_CODE);
    #100;
    press(BACKSPACE_CODE);
    #100;
    press(BACKSPACE_CODE);
    #100;
    press(BACKSPACE_CODE);

    
end

endmodule
