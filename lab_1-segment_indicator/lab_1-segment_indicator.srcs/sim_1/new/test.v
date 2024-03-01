`timescale 1ns / 1ps

module test;

reg [3:0] inp = 4'b0000;
reg reset = 0;
wire [7:0] seg;
wire [7:0] an;
reg clk = 0;
reg button = 0;

main m(.digit(inp), 
       .en_button(button), 
       .clk(clk), 
       .reset(reset), 
       .an(an), 
       .seg(seg));

always #5 clk = ~clk;

initial
begin
    #100
    $srandom(33985);
    repeat(4)
    begin
        inp = inp + 4'b0001;
        repeat($urandom_range(50,0))
        begin
            button = $random;
            #3;
        end
        button = 1;
        #200;

        repeat($urandom_range(50,0))
        begin
            button = $random;
            #3;
        end
        button = 0;
        #200;
    end
    #200
    
    repeat($urandom_range(50,0))
        begin
            reset = $random;
            #3;
        end
        reset = 1;
        #200;

        repeat($urandom_range(50,0))
        begin
            reset = $random;
            #3;
        end
        reset = 0;
end

endmodule