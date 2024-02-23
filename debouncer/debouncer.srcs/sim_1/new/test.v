`timescale 1ns / 1ps

module test;

wire led;
reg clk = 0;
reg button = 0;    

led_controller cntlr(.button_in(button), .clk(clk), .led_out(led));

always #10 clk = ~clk;

initial
begin
    #50
    $srandom(33985);
    repeat(10)
    begin
        repeat($urandom_range(50,0))
        begin
            button = $random;
            #3;
        end
        button = 1;
        #500;

        repeat($urandom_range(50,0))
        begin
            button = $random;
            #3;
        end
        button = 0;
        #500;
    end
end

endmodule
