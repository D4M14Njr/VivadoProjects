`timescale 1ns / 1ps

module main_test;

reg clk = 0;
always #5 clk <= ~clk;

clk_div #(4) div1(
    .clk(clk),
    .clk_d(clk_div));

reg signed [15:0] SW = 0;
reg btn_c_in = 0;
reg btn_reset_in = 0;
wire [7:0] AN;
wire [7:0] CATH;
wire [2:0] result_led;

main ma (
    .inp(SW),
    .en_button(btn_c_in),
    .reset(btn_reset_in),
    .clk(clk),
    .an(AN),
    .seg(CATH),
    .result_led(result_led));

localparam TEST_COUNT = 2;
integer i;
reg [12:0] test_register [0:TEST_COUNT-1];
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
    input [31:0] number;
integer i;
reg [2:0] first_digit;
begin
    first_digit = 0;
    for (i = 0; i < 15; i = i + 1)
        if (number[i])
            first_digit = i / 4;
            
    get_first_digit = first_digit + number[15];
end
endfunction

task test_top_1;
    output reg [13:0] test_register;
begin
    $display("\nСценарий 1. Вычисление неизвестных уравнения по методу Зейделя (позитивный сценарий)");
    test_script(16'b0000000000000101, 16'b1000000000000001, 16'b0000000000000011, 
                16'b0000000000000001, 16'b1000000000000100, 16'b0000000000000010, 
                16'b0000000000000010, 16'b1000000000000001, 16'b0000000000000101,
                16'b0000000000000101, 16'b0000000000010100, 16'b0000000000001010,
                32'hbf3c3c48, 32'hc08f8785, 32'h3fb2d2d8, 0, test_register); 
end
endtask

task test_top_2;
    output reg [13:0] test_register;
begin
    $display("\nСценарий 2. Ошибка переполнения (негативный сценарий)");
    test_script(16'b0000000000000000, 16'b1000000000000001, 16'b0000000000000011, 
                16'b0000000000000001, 16'b1000000000000100, 16'b0000000000000010, 
                16'b0000000000000010, 16'b1000000000000001, 16'b0000000000000000,
                16'b0000000000000101, 16'b0000000000010100, 16'b0000000000001010,
                32'h00000000, 32'h00000000, 32'h00000000, 1, test_register);        
end
endtask

localparam PRESS = 1, RELEASE = 0;
task test_script;
    input [15:0] a11, a12, a13, a21, a22, a23, a31, a32, a33, b1, b2, b3;
    input [31:0] res_x1_expected;
    input [31:0] res_x2_expected;
    input [31:0] res_x3_expected;
    input [1:0] error_expected;
    output reg [13:0] test_register;  
reg test_result;      
reg [31:0] res_real;
reg error_real;
begin
    @(posedge clk); SW = a11; #100;
    $display("\n1) Проверка ввода a11.");
    test_segs({16'ha110, 1'b0, a11[14:0]}, {3'b0, 5'b11111 << (get_first_digit(a11) + 1)}, get_first_digit(a11), a11[15], 0, test_result);
    test_register[0] = test_result;
    btn_c(PRESS, 16); btn_c(RELEASE, 16);
    
    @(posedge clk); SW = a12; #100;
    $display("\n2) Проверка ввода a12.");
    test_segs({16'ha120, 1'b0, a12[14:0]}, {3'b0, 5'b11111 << (get_first_digit(a12) + 1)}, get_first_digit(a12), a12[15], 0, test_result);
    test_register[1] = test_result;
    btn_c(PRESS, 16); btn_c(RELEASE, 16);
    
    @(posedge clk); SW = a13; #100;
    $display("\n3) Проверка ввода a13.");
    test_segs({16'ha130, 1'b0, a13[14:0]}, {3'b0, 5'b11111 << (get_first_digit(a13) + 1)}, get_first_digit(a13), a13[15], 0, test_result);
    test_register[2] = test_result;
    btn_c(PRESS, 16); btn_c(RELEASE, 16);
    
    @(posedge clk); SW = a21; #100;
    $display("\n4) Проверка ввода a21.");
    test_segs({16'ha210, 1'b0, a21[14:0]}, {3'b0, 5'b11111 << (get_first_digit(a21) + 1)}, get_first_digit(a21), a21[15], 0, test_result);
    test_register[3] = test_result;
    btn_c(PRESS, 16); btn_c(RELEASE, 16);
    
    @(posedge clk); SW = a22; #100;
    $display("\n5) Проверка ввода a22.");
    test_segs({16'ha220, 1'b0, a22[14:0]}, {3'b0, 5'b11111 << (get_first_digit(a22) + 1)}, get_first_digit(a22), a22[15], 0, test_result);
    test_register[4] = test_result;
    btn_c(PRESS, 16); btn_c(RELEASE, 16);
    
    @(posedge clk); SW = a23; #100;
    $display("\n6) Проверка ввода a23.");
    test_segs({16'ha230, 1'b0, a23[14:0]}, {3'b0, 5'b11111 << (get_first_digit(a23) + 1)}, get_first_digit(a23), a23[15], 0, test_result);
    test_register[5] = test_result;
    btn_c(PRESS, 16); btn_c(RELEASE, 16);
    
    @(posedge clk); SW = a31; #100;
    $display("\n7) Проверка ввода a31.");
    test_segs({16'ha310, 1'b0, a31[14:0]}, {3'b0, 5'b11111 << (get_first_digit(a31) + 1)}, get_first_digit(a31), a31[15], 0, test_result);
    test_register[6] = test_result;
    btn_c(PRESS, 16); btn_c(RELEASE, 16);
    
    @(posedge clk); SW = a32; #100;
    $display("\n8) Проверка ввода a32.");
    test_segs({16'ha320, 1'b0, a32[14:0]}, {3'b0, 5'b11111 << (get_first_digit(a32) + 1)}, get_first_digit(a32), a32[15], 0, test_result);
    test_register[7] = test_result;
    btn_c(PRESS, 16); btn_c(RELEASE, 16);
    
    @(posedge clk); SW = a33; #100;
    $display("\n9) Проверка ввода a33.");
    test_segs({16'ha330, 1'b0, a33[14:0]}, {3'b0, 5'b11111 << (get_first_digit(a33) + 1)}, get_first_digit(a33), a33[15], 0, test_result);
    test_register[8] = test_result;
    btn_c(PRESS, 16); btn_c(RELEASE, 16);

    @(posedge clk); SW = b1; #100;
    $display("\n10) Проверка ввода b1.");
    test_segs({16'hb100, 1'b0, b1[14:0]}, {2'b01, 5'b11111 << (get_first_digit(b1) + 1)}, get_first_digit(b1), b1[15], 0, test_result);
    test_register[9] = test_result;
    btn_c(PRESS, 16); btn_c(RELEASE, 16);
    
    @(posedge clk); SW = b2; #100;
    $display("\n11) Проверка ввода b2.");
    test_segs({16'hb200, 1'b0, b2[14:0]}, {2'b01, 5'b11111 << (get_first_digit(b2) + 1)}, get_first_digit(b2), b2[15], 0, test_result);
    test_register[10] = test_result;
    btn_c(PRESS, 16); btn_c(RELEASE, 16);

    @(posedge clk); SW = b3; #100;
    $display("\n12) Проверка ввода b3.");
    test_segs({16'hb300, 1'b0, b3[14:0]}, {2'b01, 5'b11111 << (get_first_digit(b3) + 1)}, get_first_digit(b3), b3[15], 0, test_result);
    test_register[11] = test_result;
    btn_c(PRESS, 16); btn_c(RELEASE, 16);
    
    #2000;
  
    $display("\n13) Проверка вывода результата на индикаторах.");
    if (error_expected == 0) begin
        test_segs(res_x1_expected, 8'b00000000, 0, 0, 0, test_result);
        test_register[12] = test_result & (result_led == get_result_led_mask(0));
        $display("%b, %b", result_led, get_result_led_mask(0));
        btn_c(PRESS, 16); btn_c(RELEASE, 16);
        test_segs(res_x2_expected, 8'b00000000, 0, 0, 0, test_result);
        test_register[12] = test_register[12] & test_result &  (result_led == get_result_led_mask(1));

        btn_c(PRESS, 16); btn_c(RELEASE, 16);
        test_segs(res_x3_expected, 8'b00000000, 0, 0, 0, test_result);
        test_register[12] = test_register[12] & test_result & (result_led == get_result_led_mask(2));
    end
    else begin
        test_segs(0, 8'b00000000, 0, 0, error_expected, test_result);
        test_register[12] = test_result & (result_led == get_result_led_mask(3));
    end

    btn_reset(PRESS, 16);
    btn_reset(RELEASE, 16);
    #100;
    
    $display("\n14) Проверка сброса результата на индикаторах.");
    test_segs({16'ha110, 1'b0, SW[14:0]}, {3'b0, 5'b11111 << (get_first_digit(SW) + 1)}, get_first_digit(SW), SW[15], 0, test_result);
    test_register[14] = test_result;
end
endtask

localparam ENABLE = 1, RESET = 0;
task btn_c;  
    input signal_in;
    input [4:0] ticks;
begin
    @(posedge clk); 
    jitter(ENABLE);
    btn_c_in = ~signal_in;
    @(posedge clk) btn_c_in = signal_in;
    $display("[%0t]: Сигнал %b подан на линию.", $time, signal_in);
    
    repeat(ticks + 1)
        @(posedge clk);  
end
endtask

task btn_reset;  
    input signal_in;
    input [4:0] ticks;
begin
    @(posedge clk);
    jitter(RESET);
    btn_reset_in = ~signal_in;
    @(posedge clk) btn_reset_in = signal_in;
    $display("\n[%0t]: Сигнал %b подан на линию btn_reset_in.", $time, signal_in);
 
    repeat(ticks + 1)
        @(posedge clk);  
end
endtask

task jitter;
    input btn;
begin
    $display("Дребезг на кнопке");
    $srandom(33985);
    if(btn == ENABLE)
        repeat($urandom_range(50,0))
        begin
            btn_c_in = $random;
            #3;
        end
    else if(btn == RESET)
        repeat($urandom_range(50,0))
        begin
            btn_reset_in = $random;
            #3;
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

    $display("Значение: %h", value);
    if (error_in == 0)
        for (i = 0; i < 8; i = i + 1)
        begin
            @(posedge clk_div);
            if(mask[i] == 0)
            begin
                $display("[%0t] Номер индикатора: %0d", $time, i);
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
            $display("[%0t] Номер индикатора: %0d", $time, i);
                
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
