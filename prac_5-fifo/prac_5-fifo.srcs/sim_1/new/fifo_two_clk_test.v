`timescale 1ns / 1ps

module fifo_two_clk_test;

reg clk_read = 0;
reg clk_write = 0;

integer CLK_READ_PERIOD = 20;
integer CLK_WRITE_PERIOD = 10;

always #(CLK_READ_PERIOD/2) clk_read <= ~clk_read;
always #(CLK_WRITE_PERIOD/2) clk_write <= ~clk_write;

wire min_clk;
assign min_clk = CLK_READ_PERIOD < CLK_WRITE_PERIOD? clk_read: clk_write;

reg reset = 0;
reg enable = 0;
reg read_mode = 0;
reg write_mode = 0;
reg [3:0] data_in;

wire [3:0] data_out;
wire valid, full, empty;

fifo_two_clk uut(
    .clk_in_read(clk_read),
    .clk_in_write(clk_write),
    .enable(enable),
    .reset(reset),
    .read_mode(read_mode),
    .write_mode(write_mode),
    .data_in(data_in),
    .data_out(data_out),
    .valid(valid),
    .full(full),
    .empty(empty));

integer tn = 1;

localparam TEST_COUNT = 10;
reg [0:TEST_COUNT-1] test_register;
initial 
begin
    test_register = 0;
    @(posedge clk_read);
    fifo_test1();
    fifo_test2();
    fifo_test3();
    fifo_test4();
    fifo_test5();
    fifo_test6();
    fifo_test7();
    fifo_test8();
    fifo_test9();
    fifo_test10();
    test_stats();
end

reg [3:0] res;
reg val = 0;
reg [3:0] mem;
reg [2:0] r_p;
reg [2:0] w_p;
reg emp;
reg fll;

task fifo_test1;
begin
    $display("\n1) Буфер пуст. Запрос на чтение.");
    r_p <= uut.read_pointer;
    emp <= uut.empty;
    @(posedge clk_read); read();
    if (~val && r_p == uut.read_pointer && emp == uut.empty) begin
        $display("Тест пройден");
        test_register[0] = 1;
    end
    else $display("Тест НЕ пройден");
    reset_fifo();
end
endtask

task fifo_test2;
begin
    $display("\n2) Буфер пуст. Запрос на запись.");
    w_p <= uut.write_pointer;
    @(posedge clk_write); write(4'b0001);
    if (mem == 4'b0001 && 
        w_p == uut.write_pointer - 1 && 
        uut.empty == 0) begin
        $display("Тест пройден");
        test_register[1] = 1;
    end
    else $display("Тест НЕ пройден");
    reset_fifo();
end
endtask

task fifo_test3;
begin
    $display("\n3) Буфер пуст. Параллельные запросы записи и чтения.");
    r_p <= uut.read_pointer; w_p <= uut.write_pointer;
    write_and_read(4'b0001);
    if (val && mem == 4'b0001 && 
        r_p == uut.read_pointer - 1 && 
        w_p == uut.write_pointer - 1 && 
        uut.empty == 0) begin
        $display("Тест пройден");
        test_register[2] = 1;
    end
    else $display("Тест НЕ пройден");
    reset_fifo();
end
endtask

task fifo_test4;
begin
    fill(4, 4);
    $display("\n4) Случайное тестирование. Запрос на чтение.");
    r_p <= uut.read_pointer;
    @(posedge clk_read); read();
    if (val && res == 4'b0100 && r_p == uut.read_pointer - 1) begin
        $display("Тест пройден");
        test_register[3] = 1;
    end
    else $display("Тест НЕ пройден");
    reset_fifo();
end
endtask

task fifo_test5;
begin
    fill(5, 4);
    $display("\n5) Случайное тестирование. Запрос на запись.");
    w_p <= uut.write_pointer;
    @(posedge clk_write); write(4'b0110);
    if (mem == 4'b0110 && w_p == uut.write_pointer - 1) begin
        $display("Тест пройден");
        test_register[4] = 1;
    end
    else $display("Тест НЕ пройден");    
    reset_fifo();
end
endtask

task fifo_test6;
begin
    fill(6, 4);
    $display("\n6) Случайное тестирование. Параллельные запросы записи и чтения.");
    r_p <= uut.read_pointer; w_p <= uut.write_pointer;
    write_and_read(4'b0111);
    if (val && res == 4'b0110 && 
        mem == 4'b0111 && 
        r_p == uut.read_pointer - 1 && 
        w_p == uut.write_pointer - 1) begin
        $display("Тест пройден");
        test_register[5] = 1;
    end
    else $display("Тест НЕ пройден");    
    reset_fifo();
end
endtask

task fifo_test7;
begin
    fill(7, 8);
    $display("\n7) Буфер заполнен. Запрос на чтение.");
    @(posedge clk_read); read();
    if (val && res == 4'b0111 && r_p == uut.read_pointer - 1 && uut.full == 0) begin
        $display("Тест пройден");
        test_register[6] = 1;
    end
    else $display("Тест НЕ пройден");
    reset_fifo();
end
endtask

task fifo_test8;
begin
    fill(8, 8);
    $display("\n8) Буфер заполнен. Запрос на запись.");
    w_p <= uut.write_pointer; fll <= uut.full;
    @(posedge clk_write); write(4'b1001);
    if (w_p == uut.write_pointer && fll == uut.full) begin
        $display("Тест пройден");
        test_register[7] = 1;
    end
    else $display("Тест НЕ пройден");    
    reset_fifo();
end
endtask

task fifo_test9;
begin
    fill(9, 8);
    $display("\n9) Буфер заполнен. Параллельные запросы записи и чтения.");
    r_p <= uut.read_pointer; w_p <= uut.write_pointer;
    write_and_read(4'b0001);
    if (val && res == 4'b1001 && 
        r_p == uut.read_pointer - 1 && 
        w_p == uut.write_pointer && uut.full == 0) begin
        $display("Тест пройден");
        test_register[8] = 1;
    end
    else $display("Тест НЕ пройден");
    reset_fifo();
end
endtask

task fifo_test10;
begin
    fill(10, 4);
    @(posedge min_clk);
    $display("\n10) Сброс внутренних регистров буфера.");
    $display("[%0t]: Подача единицы на reset.", $time);
    reset <= 1'b1;
    @(posedge min_clk); @(posedge min_clk);
    reset <= 1'b0;
    $display("[%0t]: Подача нуля на reset.", $time);
    @(posedge min_clk);
    if (uut.write_pointer == 0 && 
        uut.read_pointer == 0 && 
        uut.full == 0 && uut.empty == 1) begin
        $display("Тест пройден");
        test_register[9] = 1;
    end 
    else $display("Тест НЕ пройден");
    reset_fifo();
end
endtask

task read;
begin
    read_mode <= 1'b1;
    @(posedge clk_read);
    enable <= 1'b1;
    @(posedge clk_read); @(negedge clk_read);
    res <= data_out;
    val <= valid;
    if (valid) begin
        $display("[%0t]: Данные на выходе %0d.", $time, data_out);
    end else
        $display("[%0t]: Нет выходных данных.", $time);
    enable <= 1'b0;
    read_mode <= 1'b0;
    @(posedge clk_read);
end
endtask

task write;
    input [3:0] data;
begin
    enable <= 1'b1;
    write_mode <= 1'b1; 
    data_in <= data;
    $display("[%0t]: Запись числа %d.", $time, data);
    
    @(posedge clk_write);
    enable <= 1'b0; 
    write_mode <= 1'b0;
    @(posedge clk_write);
    mem <= uut.memory[uut.write_pointer - 1];
    @(posedge clk_write);
end
endtask

task write_and_read;
    input [3:0] data;
begin
    @(posedge min_clk);
    read_mode <= 1'b1;
    write_mode <= 1'b1;
    data_in <= data;
    enable <= 1'b1;

    if (CLK_READ_PERIOD >= CLK_WRITE_PERIOD) begin
        @(posedge clk_read);
        read_mode <= 1'b0; 
        enable <= 1'b0;
        @(posedge clk_write);
        $display("[%0t]: Запись числа %d.", $time, data_in);
        write_mode <= 1'b0;
        val <= valid;
        if (valid) begin
            res <= data_out;
            $display("[%0t]: Данные на выходе %0d.", $time, data_out);
        end
        else $display("[%0t]: Нет выходных данных.", $time);
    end
    else begin
        @(posedge clk_read);
        read_mode <= 1'b0; 
        @(negedge clk_read);
        val <= valid;
        if (valid) begin
            res <= data_out;
            $display("[%0t]: Данные на выходе %0d.", $time, data_out);
        end
        else $display("[%0t]: Нет выходных данных.", $time);
        $display("[%0t]: Запись числа %d.", $time, data_in);
        @(negedge clk_write); enable <= 1'b0;
        write_mode <= 1'b0;
    end
    @(posedge clk_write);
    mem <= uut.memory[uut.write_pointer - 1];
    @(posedge clk_read);
end
endtask

task reset_fifo;
begin
    @(posedge min_clk);
    reset <= 1'b1;
    @(posedge min_clk); @(posedge min_clk);
    reset <= 1'b0;
    fill(0, 8);
    @(posedge min_clk);
    reset <= 1'b1;
    @(posedge min_clk); @(posedge min_clk);
    reset <= 1'b0;
end
endtask

task fill;
    input [3:0] with;
    input [3:0] times;
begin
    @(posedge clk_write);
    data_in <= with;
    enable <= 1'b1;
    repeat(times) begin
        write_mode <= 1'b1;
        @(posedge clk_write); 
        write_mode <= 1'b0;
        @(posedge clk_write);
    end
    enable <= 1'b0;
    @(posedge clk_write);
end
endtask

task test_stats;
integer i, j;
reg [3:0] test_counter;
begin        
    test_counter = 0;
    $display("\n[%0t]: Результаты тестирования:", $time);
    
    for (i = 0; i < TEST_COUNT; i = i + 1)
    begin
        if (&(test_register[i]))
        begin
            $display("Тест %0d пройден успешно.", i+1);
            test_counter = test_counter + 1;
        end
        else $display("Тест %0d НЕ пройден.", i+1); 
    end  
    $display("Пройдено тестов: %0d/%0d", test_counter, TEST_COUNT); 
end
endtask

endmodule
