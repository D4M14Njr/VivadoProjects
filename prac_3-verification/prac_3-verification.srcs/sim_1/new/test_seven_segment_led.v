`timescale 1ns / 1ps

module test_seven_segment_led;

reg clk;
initial clk = 0;
always #5 clk <= ~clk;

reg [31:0] NUMBER = 0;
reg [7:0] AN_MASK;

wire [7:0] AN; 
wire [7:0] CATH; 

seven_segment_led si (
    .AN_MASK(AN_MASK),
    .NUMBER(NUMBER),
    .RESET(0),
    .CE(1),
    .clk(clk),
    .error_in(0),
    .AN(AN),
    .SEG(CATH));

initial
begin
    test_seven_segments(8'b00101100);
    test_show_stats();
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

reg [7:0] test_an_register; 
reg [15:0] test_digit_register;
reg test_an_mask_register;

task test_seven_segments;
    input [7:0] mask_value;
reg [3:0] i;
reg [3:0] number; 

begin     
    $display("\n[%0t]: Тест отображения цифр на индикаторах, принципа работы динамической индикации и анодной маски.", $time);
    test_an_register = 1;
    test_digit_register = 1;
    test_an_mask_register = 1;
    
    AN_MASK = mask_value;
    $display("Битовая маска: %b", AN_MASK);
    
    wait(si.digit_pos == 7);
    @(posedge clk);
    
    number = 0;
    repeat(16)
    begin
        for (i = 0; i < 8; i = i + 1)
            NUMBER[ ((i+1)*4)-1 -: 4 ] <= number;
        
        @(posedge clk);
        $display("\n[%0t]: Тест для цифры: %h", $time, number);
        for (i = 0; i < 8; i = i + 1)
        begin
            $display("Текущий анод: %d", i);
            
            test_digit_register[number] <= CATH == get_cath_mask(number);
            $display("Ожидаемые сигналы на линии катодов: %b", get_cath_mask(number));
            $display("Фактические сигналы на линии катодов: %b", CATH);
            
            test_an_register[number] <= si.AN_REG == get_an_mask(i);
            $display("Ожидаемые сигналы на линии анодов (ДО применения анодной маски): %b", get_an_mask(i));
            $display("Фактические сигналы на линии анодов (ДО применения анодной маски): %b", si.AN_REG);

            test_an_mask_register <= AN == (get_an_mask(i) | AN_MASK);
            $display("Ожидаемые сигналы на линии анодов (ПОСЛЕ применения анодной маски): %b", get_an_mask(i) | AN_MASK);
            $display("Фактические сигналы на линии анодов (ПОСЛЕ применения анодной маски): %b", AN);
            
            if (i != 7) 
                @(posedge clk);           
        end  
        number = number + 1;        
    end       
end
endtask

task test_show_stats;
localparam TEST_COUNT = 3;
integer test_counter, i;
begin
    test_counter = 0;
    $display("\n[%0t]: Результаты тестирования:", $time);
    // Отображение цифры
    if (&(test_digit_register))
    begin
        $display("1. Тест на отображение пройден успешно для всех возможных вариантов цифр.");
        test_counter = test_counter + 1;
    end
    else begin      
        $display("1. Тест на отображение цифр НЕ пройден"); 
        for (i = 0; i < 16; i = i + 1)
            if (!test_digit_register[i])
                $display("Ошибка отображения цифры %d", i); 
    end              
    // Динамическая индикация        
    if (&(test_an_register))
    begin
        test_counter = test_counter + 1;
        $display("2. Тест работы динамической индикации пройден успешно.");
    end
    else begin   
        $display("2. Тест работы динамической индикации НЕ пройден.", i);   
        for (i = 0; i < 8; i = i + 1)
            if (!test_an_register[i])
                $display("Ошибка на индикаторе %0d.", i);       
    end    
    // Анодная маска          
    if (test_an_mask_register)
    begin
        $display("3. Тест анодной маски пройден успешно.");     
        test_counter = test_counter + 1;
    end
    else
        $display("3. Тест анодной маски НЕ пройден."); 
        
    $display("Пройдено тестов: %0d/%0d.", test_counter, TEST_COUNT);         
end
endtask

endmodule
