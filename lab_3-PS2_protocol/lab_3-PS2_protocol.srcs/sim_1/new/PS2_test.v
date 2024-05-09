`timescale 1ns / 1ps

module PS2_test;

reg clk = 0;
reg PS2_dat = 0, PS2_clk = 0;

wire ready_output;
wire [6:0] out;

PS2_manager ps2_m(
    .clk(clk),
    .PS2_dat(PS2_dat),
    .PS2_clk(PS2_clk),
    .ready_output(ready_output),
    .out(out));

always #5 clk = ~clk;

initial
begin   
    test_ps2();
    test_show_stats();
end

function [6:0] decode;
    input [7:0] keycode;
begin
	case (keycode)
        8'h45: decode = 7'h0;
        8'h16: decode = 7'h1;
        8'h1E: decode = 7'h2;
        8'h26: decode = 7'h3;
        8'h25: decode = 7'h4;
        8'h2E: decode = 7'h5;
        8'h36: decode = 7'h6;
        8'h3D: decode = 7'h7;
        8'h3E: decode = 7'h8;
        8'h46: decode = 7'h9;
        8'h1C: decode = 7'hA;
        8'h32: decode = 7'hB;
        8'h21: decode = 7'hC;
        8'h23: decode = 7'hD;
        8'h24: decode = 7'hE;
        8'h2B: decode = 7'hF;
        
        8'h5A: decode = 7'h1F;
        8'h2D: decode = 7'h2F;
        8'h66: decode = 7'h3F;
        8'h4E: decode = 7'h4F;
	endcase
end	
endfunction

function [7:0] bit_reverse;
    input [7:0] data;
integer i;
begin
    for (i = 0; i < 8; i = i+1)
        bit_reverse[7 - i] = data[i];
end
endfunction

reg [19:0] test_register = 0;

task test_ps2;
reg [0:10] packets [0:19];
reg [0:10] release_button;
integer i, j;
reg [6:0] key;
begin
    packets[0] = 10'b01010001001; packets[1] = 10'b00110100001; packets[2] = 10'b00111100011; packets[3] = 10'b00110010001;
    packets[4] = 10'b01010010001; packets[5] = 10'b00111010011; packets[6] = 10'b00110110011; packets[7] = 10'b01011110001;
    packets[8] = 10'b00111110001; packets[9] = 10'b00110001001; packets[10] = 10'b00011100001; packets[11] = 10'b00100110001;
    packets[12] = 10'b01000010011; packets[13] = 10'b01100010001; packets[14] = 10'b00010010011; packets[15] = 10'b01101010011;
    packets[16] = 10'b00101101011; packets[17] = 10'b01011010011; packets[18] = 10'b00110011011; packets[19] = 10'b00111001011;
    release_button = 10'b00000111111;
    
    for (i = 0; i < 20; i = i + 1)
    begin
        key = decode(bit_reverse(packets[i][1:8]));
        case(key)
            7'h1F: $display("\n[%0t]: Тест для клавиши: enter", $time);
            7'h2F: $display("\n[%0t]: Тест для клавиши: r", $time);
            7'h3F: $display("\n[%0t]: Тест для клавиши: backspace", $time);
            7'h4F: $display("\n[%0t]: Тест для клавиши: minus", $time);
            default: $display("\n[%0t]: Тест для клавиши: %h", $time, key[3:0]);
        endcase
        
        for (j = 0; j < 11; j = j + 1) begin        
            @(posedge clk) PS2_dat = release_button[j]; PS2_clk = 0;
            @(posedge clk) PS2_clk = 1;
        end
        for (j = 0; j < 11; j = j + 1) begin        
            @(posedge clk) PS2_dat = packets[i][j]; PS2_clk = 0;
            @(posedge clk) PS2_clk = 1;
        end
        $display("[%0t]: Отправленный пакет: %b", $time, packets[i]);
        $display("Ожидаемый результат: %b", key);
        $display("Фактический результат: %b", out);
        test_register[i] = out == key;
        #1000;
    end
end  
endtask

localparam TEST_COUNT = 20;
task test_show_stats;
integer i, test_counter;
begin
    $display("\nРезультаты тестирования:");
    test_counter = 0;
    
    for (i = 0; i < TEST_COUNT; i = i + 1)
    begin
        if (test_register[i])
            $display("Тест %1d пройден.", i+1);
        else
            $display("Тест %1d НЕ пройден.", i+1);    
        test_counter = test_counter + (test_register[i] ? 1 : 0);
    end
    $display("Пройдено тестов: %0d/%0d", test_counter, TEST_COUNT);  
end
endtask

endmodule
