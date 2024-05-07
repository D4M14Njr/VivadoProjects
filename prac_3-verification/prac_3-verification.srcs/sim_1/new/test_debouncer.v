`timescale 1ns / 1ps

module test_debouncer;

localparam PRESS = 1, RELEASE = 0;
reg clk = 0;
reg in_signal = 0;
wire out_signal_enable;

debouncer #(32) btn_c(
	.clk(clk),
	.in_signal(in_signal),
	.CLOCK_ENABLE(1),
	.out_signal_enable(out_signal_enable));

always #5 clk <= ~clk;

localparam TEST_COUNT = 3;
reg [0:TEST_COUNT-1] test_register;
initial
begin
    test_register = 0;
    test_debouncer_1();
    test_debouncer_2();
    test_debouncer_3();
    test_show_stats();
end

task test_debouncer_1;
reg test_result;
begin
    $display("\n[%0t]: Тест 1. Реакция фильтра дребезга на сигнал высокого уровня на шине физ. манипулятора.", $time);
    $display("[%0t]: (время удержания сигнала соответствует требуемому)", $time); 
    send_signal_to_debouncer(PRESS, 32);
    @(posedge clk) test_result <= (out_signal_enable == 1'b1); 
    send_signal_to_debouncer(RELEASE, 32);
    test_info(1, test_result);    
end
endtask

task test_debouncer_2;
reg test_result;
begin
    $display("\n[%0t]: Тест 2. Реакция фильтра дребезга на сигнал высокого уровня на шине физ. манипулятора.", $time); 
    $display("[%0t]: (время удержания сигнала меньше требуемого)", $time);
    send_signal_to_debouncer(PRESS, 16);
    @(posedge clk); test_result = (out_signal_enable == 1'b0);
    send_signal_to_debouncer(RELEASE, 16);
    test_info(2, test_result);    
end
endtask

task test_debouncer_3;
reg test_result;
begin
    $display("\n[%0t]: Тест 3. Реакция фильтра дребезга на сигнал низкого уровня на шине физ. манипулятора.", $time);
    $display("[%0t]: (только дребезг контактов)", $time); 
    send_signal_to_debouncer(RELEASE, 32);
    @(posedge clk); test_result = (out_signal_enable == 1'b0);  
    test_info(3, test_result); 
end
endtask

task test_info;
input integer test_number;
input test_result;
begin
    test_register[test_number-1] = test_result;
    if (test_result)
        $display("[%0t]: Тест %0d пройден.", $time, test_number);
    else
        $display("[%0t]: Тест %0d НЕ пройден.", $time, test_number);  
end
endtask

task test_show_stats;
integer i, test_counter;
begin
    $display("\nРезультаты тестирования:");
    test_counter = 0; 
    
    for (i = 0; i < TEST_COUNT; i = i + 1)
    begin
        if (test_register[i])
            $display("Тест %2d пройден.", i+1);
        else
            $display("Тест %2d НЕ пройден.", i+1);    
        test_counter = test_counter + (test_register[i] ? 1 : 0);
    end
    $display("Пройдено тестов: %0d/%0d", test_counter, TEST_COUNT);  
end
endtask

task send_signal_to_debouncer;
    input signal_in;
    input [6:0] ticks;
begin
    @(posedge clk); 
    jitter();
    in_signal = ~signal_in;
    @(posedge clk) in_signal = signal_in;
    $display("[%0t]: Сигнал %b подан на линию.", $time, signal_in);
    repeat(ticks + 1)
        @(posedge clk);  
    $display("[%0t]: Сигнал %b убран с линии, подан сигнал 0", $time, signal_in);
end
endtask

task jitter;  
begin
    $display("Дребезг на кнопке C");
    $srandom(33985);
	repeat($urandom_range(50,0))
	begin
		in_signal = $random;
		#3;
	end
end
endtask

endmodule
