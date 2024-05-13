`timescale 1ns / 1ns

module test_clk_div;

reg clk = 0;
wire clk_div_out;

clk_div #(10) clk_div1 (
	.clk(clk),
	.clk_d(clk_div_out));

always #5 clk <= ~clk;

integer clk_div_period = 100;
realtime t_begin, t_end;

initial
begin
    @(posedge clk_div_out);
    t_begin = $realtime;
    @(posedge clk_div_out);
    t_end = $realtime;
    
    $display("Ожидаемый период сигнала: %0d", clk_div_period);
    $write("Фактический период сигнала: ");
    $write((t_end - t_begin));
    
    if ( (t_end - t_begin) == clk_div_period )
        $display("\nТест пройден.");
    else 
        $display("\nТест НЕ пройден."); 
end
    
endmodule
