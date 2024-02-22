`timescale 1ns / 1ps

module test;

reg [3:0] inp = 4'b0000;
wire [6:0] seg;
wire [7:0] an;



reg clk = 0;
reg button = 0;

main m(
.clk(clk),
.btn_c(button),
.SW(seg),
.AN(an),
.SEG(seg)
);
always #10 clk = ~clk;

initial
begin
    #50
    $srandom(33985);
    repeat(5)
    begin
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
        inp = inp + 4'b0001;
    end
end

endmodule

