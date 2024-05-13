`timescale 1ns / 1ps

module test_fsm;

reg input_enable = 0;
reg [15:0] data_in; 
reg clk = 0;
reg reset = 0;

wire [31:0] result;
wire output_enable;
wire [2:0] state;
wire error_out;

fsm m(
    .data(data_in),
    .input_enable(input_enable),
    .reset(reset),
    .clk(clk),
    .data_out(result),
    .output_enable(output_enable),
    .error_out(error_out),
    .current_state(state));
    
always #5 clk = ~clk;

initial
begin   
    test_fsm_1();
    test_fsm_2();
    test_fsm_3();
    test_fsm_4();
    test_fsm_5();
    test_fsm_6();
    test_fsm_7();
    test_fsm_8();
    test_show_stats();
end

task test_fsm_1;
reg test_result;
begin
    $display("\n[%0t]: Тест 1.", $time);
    test_res(16'd15, 16'd2, 16'd3, 16'd1, 31'd9, test_result);
    test_info(1, test_result);
end  
endtask

task test_fsm_2;
reg test_result;
begin
    $display("\n[%0t]: Тест 2.", $time);
    test_res(16'd15, -16'd2, 16'd3, 16'd3, 31'd17, test_result);
    test_info(2, test_result);
end  
endtask

task test_fsm_3;
reg test_result;
begin
    $display("\n[%0t]: Тест 3.", $time);
    test_res(16'd7, 16'd6, 16'd3, 16'd1, -31'd11, test_result);
    test_info(3, test_result);
end  
endtask

task test_fsm_4;
reg test_result;
begin
    $display("\n[%0t]: Тест 4.", $time);
    test_res(16'd54, -16'd38, -16'd11, 16'd6, -31'd15, test_result);
    test_info(4, test_result);
end  
endtask

task test_fsm_5;
reg test_result;
begin
    $display("\n[%0t]: Тест 5.", $time);
    test_res(16'd5, 16'd2, 16'd150, 16'd1500, 31'd5, test_result);
    test_info(5, test_result);
end  
endtask

task test_fsm_6;
reg test_result;
begin
    $display("\n[%0t]: Тест 6. Error.", $time);
    test_error(16'd6, 16'd2, 16'd2, 16'd0, 1'b1, test_result);
    test_info(6, test_result);
end  
endtask

task test_fsm_7;
reg test_result;
begin
    $display("\n[%0t]: Тест 7. Error.", $time);
    test_error(16'd111, -16'd44, 16'd0, 16'd0, 1'b1, test_result);
    test_info(7, test_result);
end  
endtask

task test_fsm_8;
reg test_result;
begin
    $display("\n[%0t]: Тест 8. Reset.", $time);
    test_reset(test_result); 
    test_info(8, test_result);   
end
endtask

task test_res;
    input signed [15:0] a, b, c, d;
    input signed [31:0] result_expected;
    output reg test_result;

reg signed [31:0] result_real;
reg error;
begin
    formula(a, b, c, d, result_real, error);
    
    $display("Входные данные: a = %0d, b = %0d, c = %0d, d = %0d", a, b, c, d);
    $display("Ожидаемый результат: %0d", result_expected);
    $display("Фактический результат: %0d", result_real);
    
    test_result = (result_expected == result_real) && (error == 1'b0);
end
endtask

task test_error;
    input signed [15:0] a, b, c, d;
    input error_in;
    output reg test_result;

reg signed [31:0] result;
reg error;
begin
    formula(a, b, c, d, result, error);
    
    $display("Входные данные: a = %0d, b = %0d, c = %0d, d = %0d", a, b, c, d);
    $display("Ожидаемый номер ошибки: %0d", error_in);
    $display("Фактический номер ошибки: %0d", error);
    
    test_result = error == error_in;
end
endtask

task test_reset;
    output reg test_result;
begin
    $display("Состояние до сброса: state = %0d", m.state);
    @(posedge clk) reset <= 1;
    @(posedge clk) reset <= 0;
    
    @(posedge clk); 
    $display("Состояние после сброса: state = %0d", m.state);
          
    test_result = m.state == 0;
end
endtask

task formula;
    input [15:0] a, b, c, d;
    output [31:0] comp_result;
    output error;
begin    
    @(posedge clk);
    data_in <= a; input_enable <= 1;
    @(posedge clk); 
    input_enable <= 0;
    
    @(posedge clk);
    data_in <= b; input_enable <= 1;
    @(posedge clk);
    input_enable <= 0;
    
    @(posedge clk);
    data_in <= c; input_enable <= 1;
    @(posedge clk);
    input_enable <= 0;
    
    @(posedge clk);
    data_in <= d; input_enable <= 1;
    @(posedge clk);
    input_enable <= 0;
    
    @(posedge output_enable); @(posedge clk);
    comp_result = result;
    error = error_out; 
end
endtask

localparam TEST_COUNT = 8;
reg [0:TEST_COUNT-1] test_register;
initial test_register = {TEST_COUNT{1'b0}};

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
    $display("\nTest results:");
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
