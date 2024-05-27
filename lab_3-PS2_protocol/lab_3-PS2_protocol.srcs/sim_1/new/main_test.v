`timescale 1ns / 1ps

module main_test;

reg clk = 0;
always #5 clk <= ~clk;

clk_div #(4) div1(
    .clk(clk),
    .clk_d(clk_div));

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

localparam TEST_COUNT = 2;
integer i;
reg [14:0] test_register [0:TEST_COUNT-1];
initial 
begin
    for (i = 0; i < TEST_COUNT; i = i + 1)
        test_register[i] = 0;

    @(posedge clk);
    test_top_1(test_register[0]);
    test_top_2(test_register[1]);

    test_stats();
end    

function [7:0] get_cath_mask;
    input [3:0] number;
begin
	case (number)
        4'h0:  get_cath_mask = 8'b11000000;
        4'h1:  get_cath_mask = 8'b11111001;
        4'h2:  get_cath_mask = 8'b10100100;
        4'h3:  get_cath_mask = 8'b10110000;
        4'h4:  get_cath_mask = 8'b10011001;
        4'h5:  get_cath_mask = 8'b10010010;
        4'h6:  get_cath_mask = 8'b10000010;
        4'h7:  get_cath_mask = 8'b11111000;
        4'h8:  get_cath_mask = 8'b10000000;
        4'h9:  get_cath_mask = 8'b10010000;
        4'ha:  get_cath_mask = 8'b10001000;
        4'hb:  get_cath_mask = 8'b10000011;
        4'hc:  get_cath_mask = 8'b11000110;
        4'hd:  get_cath_mask = 8'b10100001;
        4'he:  get_cath_mask = 8'b10000110;
        4'hf:  get_cath_mask = 8'b10001110;
        default:  get_cath_mask = 8'b11111111;
	endcase
end	
endfunction

function [7:0] get_error_cath_mask;
    input [3:0] ind;
    input [1:0] error_type;
begin
    if (error_type == 1)
    case (ind)
        4'h7: get_error_cath_mask = 8'b11111001;
        4'h6: get_error_cath_mask = 8'b10101011;
        4'h5: get_error_cath_mask = 8'b10001110;
        4'h4: get_error_cath_mask = 8'b10000110;
        4'h3: get_error_cath_mask = 8'b10101111;
        4'h2: get_error_cath_mask = 8'b10101111;
        4'h1: get_error_cath_mask = 8'b10100011;
        4'h0: get_error_cath_mask = 8'b10101111;
        default: get_error_cath_mask = 8'b11111111;
    endcase
    else if (error_type == 2)
    case (ind)
        4'h7: get_error_cath_mask = 8'b10101011;
        4'h6: get_error_cath_mask = 8'b10001000;
        4'h5: get_error_cath_mask = 8'b10101011;
        4'h4: get_error_cath_mask = 8'b10000110;
        4'h3: get_error_cath_mask = 8'b10101111;
        4'h2: get_error_cath_mask = 8'b10101111;
        4'h1: get_error_cath_mask = 8'b10100011;
        4'h0: get_error_cath_mask = 8'b10101111;
        default: get_error_cath_mask = 8'b11111111;
    endcase
end
endfunction

function [7:0] get_an_mask;
    input [2:0] an_number;
begin    
	case (an_number)
        3'd0: get_an_mask = 8'b11111110;
		3'd1: get_an_mask = 8'b11111101;
		3'd2: get_an_mask = 8'b11111011;
		3'd3: get_an_mask = 8'b11110111;
		3'd4: get_an_mask = 8'b11101111;
		3'd5: get_an_mask = 8'b11011111;
		3'd6: get_an_mask = 8'b10111111;
		3'd7: get_an_mask = 8'b01111111;
		default: get_an_mask = 8'b11111111;
	endcase
end
endfunction

function [2:0] get_result_led_mask;
    input [1:0] i;
begin    
    case(i)
        2'b00: get_result_led_mask = 3'b001;
        2'b01: get_result_led_mask = 3'b010;
        2'b10: get_result_led_mask = 3'b100;
        default: get_result_led_mask = 3'b000;
    endcase
end
endfunction

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

task test_top_1;
    output reg [14:0] test_register;
begin
    $display("\nСценарий 1. Вычисление неизвестных уравнения по методу Зейделя (позитивный сценарий)");
    test_script(17'b00000000000000101, 17'b10000000000000001, 17'b00000000000000011, 
                17'b00000000000000001, 17'b10000000000000100, 17'b00000000000000010, 
                17'b00000000000000010, 17'b10000000000000001, 17'b00000000000000101,
                17'b000000000000000101, 17'b000000000000010100, 17'b00000000000001010,
                32'hbf3c3c48, 32'hc08f8785, 32'h3fb2d2d8, 0, test_register); 
end
endtask

task test_top_2;
    output reg [14:0] test_register;
begin
    $display("\nСценарий 2. Ошибка переполнения (негативный сценарий)");
    test_script(16'b0000000000000000, 16'b1000000000000001, 16'b0000000000000011, 
                16'b0000000000000001, 16'b1000000000000100, 16'b0000000000000010, 
                16'b0000000000000010, 16'b1000000000000001, 16'b0000000000000000,
                16'b0000000000000101, 16'b0000000000010100, 16'b0000000000001010,
                32'h0, 32'h0, 32'h0, 1, test_register);        
end
endtask

localparam PRESS = 1, RELEASE = 0;
task test_script;
    input [17:0] a11, a12, a13, a21, a22, a23, a31, a32, a33, b1, b2, b3;
    input [31:0] res_x1_expected;
    input [31:0] res_x2_expected;
    input [31:0] res_x3_expected;
    input [1:0] error_expected;
    output reg [14:0] test_register;  
reg test_result;      
reg [31:0] res_real;
reg error_real;
begin
    @(posedge clk); enter_num(a11); #100;
    $display("\n1) Проверка ввода a11.");
    test_segs({16'ha110, a11[15:0]}, {3'b0, 5'b11111 << (get_first_digit(a11) + 1)}, get_first_digit(a11), a11[16], 0, test_result);
    test_register[0] = test_result;
    press(ENTER_CODE);
    #100;
    
    @(posedge clk); enter_num(a12); #100;
    $display("\n2) Проверка ввода a12.");
    test_segs({16'ha120, a12[15:0]}, {3'b0, 5'b11111 << (get_first_digit(a12) + 1)}, get_first_digit(a12), a12[16], 0, test_result);
    test_register[1] = test_result;
    press(ENTER_CODE);
    #100;
    
    @(posedge clk); enter_num(a13); #100;
    $display("\n3) Проверка ввода a13.");
    test_segs({16'ha130, a13[15:0]}, {3'b0, 5'b11111 << (get_first_digit(a13) + 1)}, get_first_digit(a13), a13[16], 0, test_result);
    test_register[2] = test_result;
    press(ENTER_CODE);
    #100;
    
    @(posedge clk); enter_num(a21); #100;
    $display("\n4) Проверка ввода a21.");
    test_segs({16'ha210, a21[15:0]}, {3'b0, 5'b11111 << (get_first_digit(a21) + 1)}, get_first_digit(a21), a21[16], 0, test_result);
    test_register[3] = test_result;
    press(ENTER_CODE);
    #100;
    
    @(posedge clk); enter_num(a22); #100;
    $display("\n5) Проверка ввода a22.");
    test_segs({16'ha220, a22[15:0]}, {3'b0, 5'b11111 << (get_first_digit(a22) + 1)}, get_first_digit(a22), a22[16], 0, test_result);
    test_register[4] = test_result;
    press(ENTER_CODE);
    #100;
    
    @(posedge clk); enter_num(a23); #100;
    $display("\n6) Проверка ввода a23.");
    test_segs({16'ha230, a23[15:0]}, {3'b0, 5'b11111 << (get_first_digit(a23) + 1)}, get_first_digit(a23), a23[16], 0, test_result);
    test_register[5] = test_result;
    press(ENTER_CODE);
    #100;
    
    @(posedge clk); enter_num(a31); #100;
    $display("\n7) Проверка ввода a31.");
    test_segs({16'ha310, a31[15:0]}, {3'b0, 5'b11111 << (get_first_digit(a31) + 1)}, get_first_digit(a31), a31[16], 0, test_result);
    test_register[6] = test_result;
    press(ENTER_CODE);
    #100;
    
    @(posedge clk); enter_num(a32); #100;
    $display("\n8) Проверка ввода a32.");
    test_segs({16'ha320, a32[15:0]}, {3'b0, 5'b11111 << (get_first_digit(a32) + 1)}, get_first_digit(a32), a32[16], 0, test_result);
    test_register[7] = test_result;
    press(ENTER_CODE);
    #100;
    
    @(posedge clk); enter_num(a33); #100;
    $display("\n9) Проверка ввода a33.");
    test_segs({16'ha330, a33[15:0]}, {3'b0, 5'b11111 << (get_first_digit(a33) + 1)}, get_first_digit(a33), a33[16], 0, test_result);
    test_register[8] = test_result;
    press(ENTER_CODE);
    #100;
    
    @(posedge clk); enter_num(b1); #100;
    $display("\n10) Проверка ввода b1.");
    test_segs({16'hb100, b1[15:0]}, {2'b01, 5'b11111 << (get_first_digit(b1) + 1)}, get_first_digit(b1), b1[16], 0, test_result);
    test_register[9] = test_result;
    press(ENTER_CODE);
    #100;
    
    @(posedge clk); enter_num(b2); #100;
    $display("\n11) Проверка ввода b2.");
    test_segs({16'hb200, b2[15:0]}, {2'b01, 5'b11111 << (get_first_digit(b2) + 1)}, get_first_digit(b2), b2[16], 0, test_result);
    test_register[10] = test_result;
    press(ENTER_CODE);
    #100;
    
    @(posedge clk); enter_num(b3); #100;
    $display("\n12) Проверка ввода b3.");
    test_segs({16'hb300, b3[15:0]}, {2'b01, 5'b11111 << (get_first_digit(b3) + 1)}, get_first_digit(b3), b3[16], 0, test_result);
    test_register[11] = test_result;
    press(ENTER_CODE);
    #100;
    
    @(posedge ma.f.ready_output);
    #100
    
    $display("\n13) Проверка вывода результата на индикаторах.");
    if (error_expected == 0) begin
        test_segs(res_x1_expected, 8'b00000000, 0, 0, 0, test_result);
        $display("\nОжидаемые сигналы на светодиодах, отвечающих за номер результата: %b", get_result_led_mask(0));
        $display("Фактические сигналы на светодиодах, отвечающих за номер результата: %b", result_led);
        test_register[12] = test_result & (result_led == get_result_led_mask(0));
        
        
        press(ENTER_CODE);
        test_segs(res_x2_expected, 8'b00000000, 0, 0, 0, test_result);
        $display("\nОжидаемые сигналы на светодиодах, отвечающих за номер результата: %b", get_result_led_mask(1));
        $display("Фактические сигналы на светодиодах, отвечающих за номер результата: %b", result_led);
        test_register[12] = test_register[12] & test_result &  (result_led == get_result_led_mask(1));

        press(ENTER_CODE);
        test_segs(res_x3_expected, 8'b00000000, 0, 0, 0, test_result);
        $display("\nОжидаемые сигналы на светодиодах, отвечающих за номер результата: %b", get_result_led_mask(2));
        $display("Фактические сигналы на светодиодах, отвечающих за номер результата: %b", result_led);
        test_register[12] = test_register[12] & test_result & (result_led == get_result_led_mask(2));
    end
    else begin
        test_segs(0, 8'b00000000, 0, 0, error_expected, test_result);
        $display("\nОжидаемые сигналы на светодиодах, отвечающих за номер результата: %b", get_result_led_mask(0));
        $display("Фактические сигналы на светодиодах, отвечающих за номер результата: %b", result_led);
        test_register[12] = test_result & (result_led == get_result_led_mask(0));
    end

    press(RESET_CODE);#100;
    $display("\n14) Проверка сброса результата на индикаторах.");
    test_segs({16'ha110, 16'b0}, 8'b00011110, 0, 0, 0, test_result);
    test_register[13] = test_result;
    
    @(posedge clk); enter_num(b1); #100;
    press(BACKSPACE_CODE); #100;
    $display("\n15) Проверка клавиши Backspace.");
    test_segs({16'ha110, 16'b0}, 8'b00011110, 0, 0, 0, test_result);
    test_register[14] = test_result;
end
endtask

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

task test_segs;
    input [31:0] value;
    input [7:0] mask;
    input [2:0] munus_pos;
    input negative;
    input [1:0] error_in;
    output reg test_result;
reg [3:0] i;
begin
    test_result = 1;
    wait(AN == get_an_mask(0));
    @(posedge clk);
    $display("\nЗначение: %h", value);
    if (error_in == 0)
        for (i = 0; i < 8; i = i + 1)
        begin
            @(posedge clk_div);
            if(mask[i] == 0)
            begin
                $display("\n[%0t] Номер индикатора: %0d", $time, i);
                if (negative & (i == munus_pos)) begin
                    $display("Ожидаемые сигналы на линии катодов: %b", 8'b10111111);
                    if (CATH != 8'b10111111)
                        test_result = 0;
                end
                else begin
                    $display("Ожидаемые сигналы на линии катодов: %b", get_cath_mask(value[(i+1)*4-1 -: 4]));
                    if (CATH != get_cath_mask(value[(i+1)*4-1 -: 4]))
                        test_result = 0;
                end
                
                $display("Фактические сигналы на линии катодов: %b", CATH);
            end
        end
    else
        for  (i = 0; i < 8; i = i + 1)
        begin
            @(posedge clk_div);
            $display("\n[%0t] Номер индикатора: %0d", $time, i);
                
            $display("Ожидаемые сигналы на линии катодов: %b", get_error_cath_mask(i, error_in));
            $display("Фактические сигналы на линии катодов: %b", CATH);
            
            if (CATH != get_error_cath_mask(i, error_in))
                test_result = 0;
        end
end
endtask

task test_stats;
integer i, j;
reg [1:0] test_counter;
begin        
    test_counter = 0;
    $display("\n[%0t]: Результаты тестирования:", $time);
    
    for (i = 0; i < TEST_COUNT; i = i + 1)
    begin
        if (&(test_register[i]))
        begin
            $display("Сценарий %0d пройден успешно.", i+1);
            test_counter = test_counter + 1;
        end
        else begin      
            $display("Сценарий %0d НЕ пройден.", i+1); 
            for (j = 0; j < 14; j = j + 1)
                if (!test_register[i][j])
                    $display("Ошибка на шаге %0d", j + 1); 
            end        
    end  
    $display("Пройдено сценариев: %0d/%0d", test_counter, TEST_COUNT); 
end
endtask

endmodule
