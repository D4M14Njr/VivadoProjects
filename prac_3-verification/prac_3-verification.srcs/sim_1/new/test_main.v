`timescale 1ns / 1ps

module test_main;

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

main ma (
    .inp(SW),
    .en_button(btn_c_in),
    .reset(btn_reset_in),
    .clk(clk),
    .an(AN),
    .seg(CATH));

localparam TEST_COUNT = 2;
integer i;
reg [5:0] test_register [0:TEST_COUNT-1];
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
begin
    case (ind)
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

function [2:0] get_first_digit;
    input [31:0] number;
integer i;
reg [2:0] first_digit;
begin
    for (i = 0; i < 32; i = i + 1)
        if (number[i])
            first_digit = i / 4;
    get_first_digit = first_digit;
end
endfunction

task test_top_1;
    output reg [7:0] test_register;
begin
    $display("\nСценарий 1. Вычисление значения функции (позитивный сценарий)");
    test_script(
        .a(16'd15), .b(-16'd2), .c(16'd3), .d(16'd3),
        .res_expected(31'd17),
        .error_expected(0),
        .test_register(test_register)); 
end
endtask

task test_top_2;
    output reg [7:0] test_register;
begin
    $display("\nСценарий 2. Деление на ноль (негативный сценарий)");
    test_script(
        .a(16'd4), .b(16'd10), .c(-16'd6), .d(16'd0),
        .res_expected(0), 
        .error_expected(1), 
        .test_register(test_register));       
end
endtask

localparam PRESS = 1, RELEASE = 0;
task test_script;
    input [15:0] a, b, c, d;
    input [31:0] res_expected;
    input error_expected;
    output reg [7:0] test_register;  
reg test_result;      
reg [31:0] res_real;
reg error_real;
begin      
    // Ввод первого числа
    @(posedge clk);
    SW = a;
    #100;
    
    $display("\n1) Проверка ввода первого числа.");
    test_segs({16'ha000, a}, {1'b0, 7'b1111111 << (get_first_digit({16'h0000, a}) + 3'b1)}, 0, test_result);
    test_register[0] = test_result;
    
    btn_c(PRESS, 16);
    btn_c(RELEASE, 16);
    
    // Ввод второго числа
    @(posedge clk);
    SW = b;
    #100;
    
    $display("\n2) Проверка ввода второго числа.");
    test_segs({16'hb000, b}, {1'b0, 7'b1111111 << (get_first_digit({16'h0000, b}) + 3'b1)}, 0, test_result);
    test_register[1] = test_result;
    
    btn_c(PRESS, 16);
    btn_c(RELEASE, 16);
    
    // Ввод третьего числа
    @(posedge clk);
    SW = c;
    #100;
    
    $display("\n3) Проверка ввода третьего числа.");
    test_segs({16'hc000, c}, {1'b0, 7'b1111111 << (get_first_digit({16'h0000, c}) + 3'b1)}, 0, test_result);
    test_register[2] = test_result;
    
    btn_c(PRESS, 16);
    btn_c(RELEASE, 16);
    
    // Ввод четвертого числа
    @(posedge clk);
    SW = d;
    #100;
    
    $display("\n4) Проверка ввода четвертого числа.");
    test_segs({16'hd000, d}, {1'b0, 7'b1111111 << (get_first_digit({16'h0000, d}) + 3'b1)}, 0, test_result);
    test_register[3] = test_result;
    
    btn_c(PRESS, 16);
    btn_c(RELEASE, 16);
    #100;
  
    $display("\n5) Проверка вывода результата на индикаторах.");
    if (error_expected) 
    begin
        test_segs(0, 8'b1110_0000, 1, test_result);
        test_register[4] = test_result;
    end
    else begin
        test_segs(res_expected, 8'b1111_1111 << (get_first_digit(res_expected) + 3'b1), 0, test_result);
        test_register[4] = test_result;
    end

    btn_reset(PRESS, 16);
    btn_reset(RELEASE, 16);
    #100;
    
    $display("\n6) Проверка сброса результата на индикаторах.");
    test_segs({16'ha000, SW}, 8'b01111110, 0, test_result); 
    test_register[5] = test_result;
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
    input error_in;
    output reg test_result;
reg [3:0] i;
begin
    test_result = 1;
    wait(AN == get_an_mask(0));

    $display("Значение: %h", value);
    if (~error_in)
        for (i = 0; i < 8; i = i + 1)
        begin
            @(posedge clk_div);
            if(mask[i] == 0)
            begin
                $display("[%0t] Номер индикатора: %0d", $time, i);
                
                $display("Ожидаемые сигналы на линии катодов: %b", get_cath_mask(value[(i+1)*4-1 -: 4]));
                $display("Фактические сигналы на линии катодов: %b", CATH);
                
                if (CATH != get_cath_mask(value[(i+1)*4-1 -: 4]))
                    test_result = 0;
            end
        end
    else
        for  (i = 0; i < 5; i = i + 1)
        begin
            @(posedge clk_div);
            $display("[%0t] Номер индикатора: %0d", $time, i);
                
            $display("Ожидаемые сигналы на линии катодов: %b", get_error_cath_mask(i));
            $display("Фактические сигналы на линии катодов: %b", CATH);
            
            if (CATH != get_error_cath_mask(i))
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
            for (j = 0; j < 8; j = j + 1)
                if (!test_register[i][j])
                    $display("Ошибка на шаге %0d", j + 1); 
            end        
    end  
    $display("Пройдено сценариев: %0d/%0d", test_counter, TEST_COUNT); 
end
endtask

endmodule
