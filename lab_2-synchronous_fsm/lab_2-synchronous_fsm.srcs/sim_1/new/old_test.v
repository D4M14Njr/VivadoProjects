`timescale 1ns / 1ps

module old_test;

reg clk = 0;
reg button = 0;
reg reset = 0;
reg [15:0] inp = 0;

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
    
    inp = 16'b0000_0000_0000_0101;
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
    
    inp = 16'b1000_0000_0000_0001;
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
    
    inp = 16'b0000_0000_0000_0011;
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
    
    inp = 16'b0000_0000_0000_0001;
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
    
    inp = 16'b1000_0000_0000_0100;
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
    
    inp = 16'b0000_0000_0000_0010;
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
    
    inp = 16'b0000_0000_0000_0010;
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
    
    inp = 16'b1000_0000_0000_0001;
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
    
    inp = 16'b0000_0000_0000_0101;
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
    
    inp = 16'b0000_0000_0000_0101;
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
    
    inp = 16'b0000_0000_0001_0100;
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
    
    inp = 16'b0000_0000_0000_1010;
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