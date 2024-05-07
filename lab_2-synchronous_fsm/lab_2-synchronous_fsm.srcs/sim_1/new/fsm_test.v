`timescale 1ns / 1ps

module fsm_test;

reg input_enable = 0;
reg [15:0] data_in; 
reg clk = 0;
reg reset = 0;
reg [3:0] first_one = 0;

wire [31:0] result;
wire ready_output;
wire [1:0] error_out;

fsm m(
    .data(data_in),
    .first_one(first_one),
    .input_enable(input_enable),
    .reset(reset),
    .clk(clk),
    .float_data_out(result),
    .ready_output(ready_output),
    .error_out(error_out),
    .i(), .j());

function [3:0] get_first_one;
    input [15:0] number;
integer i;
reg [3:0] first_one_loc;
begin
    first_one_loc = 4'd15;
    for (i = 0; i < 15; i = i + 1)
        if (number[i])
            first_one_loc = i;

    get_first_one = first_one_loc;
end
endfunction

always #5 clk = ~clk;

initial
begin   
    test_fsm_1();
    test_fsm_2();
    test_fsm_3();
    test_fsm_4();
    test_fsm_5();
    test_show_stats();
end

task test_fsm_1;
reg test_result;
begin
    $display("\n[%0t]: Тест 1.", $time);
    test_res(16'b0000000000000101, 16'b1000000000000001, 16'b0000000000000011, 
             16'b0000000000000001, 16'b1000000000000100, 16'b0000000000000010, 
             16'b0000000000000010, 16'b1000000000000001, 16'b0000000000000101,
             16'b0000000000000101, 16'b0000000000010100, 16'b0000000000001010,
             32'hbf3c3c48, 32'hc08f8785, 32'h3fb2d2d8,
             test_result);
    test_info(1, test_result);
end  
endtask

task test_fsm_2;
reg test_result;
begin
    $display("\n[%0t]: Тест 2.", $time);
    test_res(16'b0000000000000111, 16'b1000000000000010, 16'b0000000000000001, 
             16'b0000000000001111, 16'b1000000000001010, 16'b1000000000000001, 
             16'b0000000000001010, 16'b1000000000001010, 16'b0000000000000100,
             16'b0000000000001011, 16'b0000000000000011, 16'b0000000000000001,
             32'h4005e85c, 32'h402ad4ab, 32'h3fd89d88,
             test_result);
    test_info(2, test_result);
end  
endtask

task test_fsm_3;
reg test_result;
begin
    $display("\n[%0t]: Тест 3.", $time);
    test_res(16'b0000000000010001, 16'b1000000010011100, 16'b0000000000001011, 
             16'b0000000000001011, 16'b0000000001111001, 16'b1000000000001110, 
             16'b0000000000000011, 16'b1000000000101110, 16'b0000000000101101,
             16'b0000000000001010, 16'b1000000101000001, 16'b0000000000001110,
             32'hc1508a16, 32'hbfc14a54, 32'hbeba2b78,
             test_result);
    test_info(3, test_result);
end  
endtask

task test_fsm_4;
reg test_result;
begin
    $display("\n[%0t]: Тест 4.", $time);
    test_error(16'b0000000000000000, 16'b1000000000000001, 16'b0000000000000011, 
               16'b0000000000000001, 16'b1000000000000100, 16'b0000000000000010, 
               16'b0000000000000010, 16'b1000000000000001, 16'b0000000000000000,
               16'b0000000000000101, 16'b0000000000010100, 16'b0000000000001010,
               2'd1, test_result);
    test_info(4, test_result);
end  
endtask

task test_fsm_5;
reg test_result;
begin
    $display("\n[%0t]: Тест 5.", $time);
    test_error(16'b0000000000000000, 16'b0000000000000000, 16'b0000000000000011, 
               16'b0000000000000001, 16'b1000000000000100, 16'b0000000000000010, 
               16'b0000000000000010, 16'b1000000000000001, 16'b0000000000000000,
               16'b0000000000000101, 16'b0000000000010100, 16'b0000000000001010,
               2'd2, test_result);
    test_info(5, test_result);
end  
endtask

task test_res;
    input [15:0] a11, a12, a13, a21, a22, a23, a31, a32, a33, b1, b2, b3;
    input [31:0] result_x1_expected, result_x2_expected, result_x3_expected;
    output reg test_result;

reg [31:0] result_real [2:0];
reg [1:0] error;
begin
    formula(a11, a12, a13, a21, a22, a23, a31, a32, a33, b1, b2, b3, 
            result_real[0], result_real[1], result_real[2], error);
    
    $display("Входные данные:");
    $display("a11 = %0d, a12 = %0d, a13 = %0d", 
        $signed(a11[15]? {a11[15], ~a11[14:0] + 1'b1}: a11), 
        $signed(a12[15]? {a12[15], ~a12[14:0] + 1'b1}: a12), 
        $signed(a13[15]? {a13[15], ~a13[14:0] + 1'b1}: a13));
    $display("a21 = %0d, a22 = %0d, a23 = %0d", 
        $signed(a21[15]? {a21[15], ~a21[14:0] + 1'b1}: a21), 
        $signed(a22[15]? {a22[15], ~a22[14:0] + 1'b1}: a22), 
        $signed(a23[15]? {a23[15], ~a23[14:0] + 1'b1}: a23));
    $display("a31 = %0d, a32 = %0d, a33 = %0d", 
        $signed(a31[15]? {a31[15], ~a31[14:0] + 1'b1}: a31), 
        $signed(a32[15]? {a32[15], ~a32[14:0] + 1'b1}: a32), 
        $signed(a33[15]? {a33[15], ~a33[14:0] + 1'b1}: a33));
    $display("b1 = %0d, b2 = %0d, b3 = %0d",
        $signed(b1[15]? {b1[15], ~b1[14:0] + 1'b1}: b1), 
        $signed(b2[15]? {b2[15], ~b2[14:0] + 1'b1}: b2), 
        $signed(b3[15]? {b3[15], ~b3[14:0] + 1'b1}: b3));
    $display("Ожидаемые результаты:");
    $display("x1 = %0h", result_x1_expected);
    $display("x2 = %0h", result_x2_expected);
    $display("x3 = %0h", result_x3_expected);
    $display("Фактические результаты:");
    $display("x1 = %0h", result_real[0]);
    $display("x2 = %0h", result_real[1]);
    $display("x3 = %0h", result_real[2]);
    
    test_result = (result_x1_expected == result_real[0]) && 
                  (result_x2_expected == result_real[1]) && 
                  (result_x3_expected == result_real[2]) && (error == 1'b0);
end
endtask

task test_error;
    input [15:0] a11, a12, a13, a21, a22, a23, a31, a32, a33, b1, b2, b3;
    input [1:0] error_in;
    output reg test_result;

reg [31:0] result_real [2:0];
reg [1:0] error;
begin
    formula(a11, a12, a13, a21, a22, a23, a31, a32, a33, b1, b2, b3, 
            result_real[0], result_real[1], result_real[2], error);
    $display("Входные данные:");
    $display("a11 = %0d, a12 = %0d, a13 = %0d", $signed(a11[15]? {a11[15], ~a11[14:0] + 1'b1}: a11), 
                                                $signed(a12[15]? {a12[15], ~a12[14:0] + 1'b1}: a12), 
                                                $signed(a13[15]? {a13[15], ~a13[14:0] + 1'b1}: a13));
    $display("a21 = %0d, a22 = %0d, a23 = %0d", $signed(a21[15]? {a21[15], ~a21[14:0] + 1'b1}: a21), 
                                                $signed(a22[15]? {a22[15], ~a22[14:0] + 1'b1}: a22), 
                                                $signed(a23[15]? {a23[15], ~a23[14:0] + 1'b1}: a23));
    $display("a31 = %0d, a32 = %0d, a33 = %0d", $signed(a31[15]? {a31[15], ~a31[14:0] + 1'b1}: a31), 
                                                $signed(a32[15]? {a32[15], ~a32[14:0] + 1'b1}: a32), 
                                                $signed(a33[15]? {a33[15], ~a33[14:0] + 1'b1}: a33));
    $display("b1 = %0d, b2 = %0d, b3 = %0d",$signed(b1[15]? {b1[15], ~b1[14:0] + 1'b1}: b1), 
                                            $signed(b2[15]? {b2[15], ~b2[14:0] + 1'b1}: b2), 
                                            $signed(b3[15]? {b3[15], ~b3[14:0] + 1'b1}: b3)); 
    $display("Ожидаемый номер ошибки: %0d", error_in);
    $display("Фактический номер ошибки: %0d", error);
    
    test_result = error == error_in;
end
endtask


task formula;
    input [15:0] a11, a12, a13, a21, a22, a23, a31, a32, a33, b1, b2, b3;
    output [31:0] comp_result_x1, comp_result_x2, comp_result_x3;
    output [1:0] error;
begin
    @(posedge clk); data_in <= a11; first_one = get_first_one(a11); input_enable <= 1;
    @(posedge clk); input_enable <= 0;
    
    @(posedge clk); data_in <= a12; first_one = get_first_one(a12); input_enable <= 1;
    @(posedge clk); input_enable <= 0;
    
    @(posedge clk); data_in <= a13; first_one = get_first_one(a13); input_enable <= 1;
    @(posedge clk); input_enable <= 0;
    
    @(posedge clk); data_in <= a21; first_one = get_first_one(a21); input_enable <= 1;
    @(posedge clk); input_enable <= 0;
    
    @(posedge clk); data_in <= a22; first_one = get_first_one(a22); input_enable <= 1;
    @(posedge clk); input_enable <= 0;
    
    @(posedge clk); data_in <= a23; first_one = get_first_one(a23); input_enable <= 1;
    @(posedge clk); input_enable <= 0;
    
    @(posedge clk); data_in <= a31; first_one = get_first_one(a31); input_enable <= 1;
    @(posedge clk); input_enable <= 0;
    
    @(posedge clk); data_in <= a32; first_one = get_first_one(a32); input_enable <= 1;
    @(posedge clk); input_enable <= 0;
    
    @(posedge clk); data_in <= a33; first_one = get_first_one(a33); input_enable <= 1;
    @(posedge clk); input_enable <= 0;
    
    @(posedge clk); data_in <= b1; first_one = get_first_one(b1); input_enable <= 1;
    @(posedge clk); input_enable <= 0;
    
    @(posedge clk); data_in <= b2; first_one = get_first_one(b2); input_enable <= 1;
    @(posedge clk); input_enable <= 0;
    
    @(posedge clk); data_in <= b3; first_one = get_first_one(b3); input_enable <= 1;
    @(posedge clk); input_enable <= 0;
    
    @(posedge ready_output);
    if (error_out == 0) begin
        @(posedge clk);
        comp_result_x1 <= result;
        error <= error_out;
        
        @(posedge clk); input_enable <= 1;
        @(posedge clk); input_enable <= 0;
        @(posedge ready_output); @(posedge clk);
        comp_result_x2 <= result;
        
        
        @(posedge clk); input_enable <= 1;
        @(posedge clk); input_enable <= 0;
        @(posedge ready_output); @(posedge clk);
        comp_result_x3 <= result;
        
        @(posedge clk); reset <= 1;
        @(posedge clk); reset <= 0;
    end
    else begin
        @(posedge clk);
        error <= error_out;
        
        @(posedge clk); reset <= 1;
        @(posedge clk); reset <= 0;
    end 
end
endtask

localparam TEST_COUNT = 5;
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
