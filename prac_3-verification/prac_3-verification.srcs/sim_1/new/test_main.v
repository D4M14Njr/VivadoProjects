`timescale 1ns / 1ps

module test_main;

reg clk = 0;
reg button = 0;
reg reset = 0;
reg [7:0] inp;

wire [7:0] an;
wire [7:0] seg;

main m(
    .inp(inp),
    .en_button(button),
    .clk(clk),
    .reset(reset),
    .an(an),
    .seg(seg));

initial
begin
    #100
    $srandom(33985);
    
    inp = 7;
    repeat($urandom_range(50,0))
    begin
        button = $random;
        #3;
    end
    button = 1;
    #1000;

    repeat($urandom_range(50,0))
    begin
        button = $random;
        #3;
    end
    button = 0;
    #1000;
    
    inp = 6;
    repeat($urandom_range(50,0))
    begin
        button = $random;
        #3;
    end
    button = 1;
    #1000;

    repeat($urandom_range(50,0))
    begin
        button = $random;
        #3;
    end
    button = 0;
    #1000;
    
    inp = 3;
    repeat($urandom_range(50,0))
    begin
        button = $random;
        #3;
    end
    button = 1;
    #1000;

    repeat($urandom_range(50,0))
    begin
        button = $random;
        #3;
    end
    button = 0;
    #1000;
    
    inp = 1;
    repeat($urandom_range(50,0))
    begin
        button = $random;
        #3;
    end
    button = 1;
    #1000;

    repeat($urandom_range(50,0))
    begin
        button = $random;
        #3;
    end
    button = 0;
    #1000;
    
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

always #5 clk = ~clk;

endmodule
