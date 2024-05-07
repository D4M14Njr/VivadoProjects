`timescale 1ns / 1ps

module func_test;

function [31:0] div_float;
    input [31:0] a, b;
reg [48:0] new_m;
reg [8:0] new_e;
begin
    new_e = $signed({1'b0, a[30:23]}) - $signed({1'b0, b[30:23]}) + 9'd127;
    new_m = {1'b1, a[22:0], 24'b0} / {1'b1, b[22:0]};
    new_m = {1'b1, a[22:0], 24'b0} / {1'b1, b[22:0]};
//    $display("%b", new_e);
//    $display("%b", new_m);
    
    if (new_m[24])
        new_m = new_m >> 1'b1;
    else 
        new_e = new_e - 9'b1;
    
//    $display("%b", new_m);
    div_float = {a[31]^b[31], new_e[7:0], new_m[22:0]};
//    $display("%b", {a[31]^b[31], new_e[7:0], new_m[22:0]});
end
endfunction

function [31:0] mult_float;
    input [31:0] a, b;
reg [47:0] new_m;
reg [8:0] new_e;
begin
    if ((a[30:23] == 0 & a[22:0] == 0) | (b[30:23] == 0 & b[22:0] == 0))
        mult_float = 32'b0;
    else
    begin
        new_e = a[30:23] + b[30:23] - 9'd126;
        if (new_e[8])
            mult_float = {a[31]^b[31], 8'd255, 23'b0};
        else
        begin
            new_m = {1'b1, a[22:0]} * {1'b1, b[22:0]};
            if (new_m[47])
                mult_float = {a[31]^b[31], new_e[7:0], new_m[46:24]};
            else
            begin
                new_e = new_e - 9'b1;
                mult_float = {a[31]^b[31], new_e[7:0], new_m[45:23]};
            end 
        end
    end
end
endfunction

function [31:0] sum_float;
    input [31:0] a, b;
reg [8:0] new_e;
reg [7:0] r;
reg signed [25:0] a_m, b_m, new_m;
begin
    if ((a[30:23] == 0 & a[22:0] == 0))
        sum_float = b;
    else if ((b[30:23] == 0 & b[22:0] == 0))
        sum_float = a;
    else
    begin
        a_m = {a[31], 2'b01, a[22:0]};
        $display("a_m %b", a_m);
        b_m = {b[31], 2'b01, b[22:0]};
        $display("b_m %b", b_m);
        
        if (a[30:23] > b[30:23])
        begin
            new_e = a[30:23];
            r = a[30:23] - b[30:23];
            b_m = {b_m[25], b_m[24:0] >> r};
        end
        else
        begin
            new_e = b[30:23];
            r = b[30:23] - a[30:23];
            a_m = {a_m[25], a_m[24:0] >> r};
        end
        $display("%b", new_e);
        $display(r);
        $display("%b", a_m);
        if (a[31])
            a_m = {a_m[25], ~a_m[24:0] + 1'b1};   
        $display("%b", a_m);
        if (b[31])
            b_m = {b_m[25], ~b_m[24:0] + 1'b1};
        $display("%b", b_m);
        if (r >= 8'd24)
            if (a[30:23] > b[30:23])
                sum_float = a;
            else
                sum_float = b;
        else
        begin
            new_m = a_m + b_m;
            $display("%b", new_m);
            if (new_m[25])
                new_m = {new_m[25], ~new_m[24:0] + 1'b1};
            $display("%b", new_m);
            if (new_m[24])
            begin
                new_e = new_e + 1'b1;
                sum_float = {new_m[25], new_e[7:0], new_m[23:1]};
            end
            else if (new_m[23])
                sum_float = {new_m[25], new_e[7:0], new_m[22:0]};
            else
            begin
                for (r = 8'd23; r != 1'b0; r = r - 1'b1)
                begin
                    $display("| %d", r);
                    if (new_m[r])
                    begin
                        new_e = new_e - (8'd23 - r);
                        new_m = {new_m[25], new_m[24:0] << (8'd23 - r)};
                        $display("| %d", (8'd23 - r));
                        $display("| %b", new_m);
                        $display("| %b", new_e);
                        $display("| %b", new_m[25]);
                        sum_float = {new_m[25], new_e[7:0], new_m[22:0]};
                        r = 8'd1;
                    end
                end
            end
        end
    end
end
endfunction

reg clk = 0;
reg [31:0] res;
reg test_res;

always #5 clk = ~clk;

initial
begin
    @(posedge clk)
    res = mult_float(32'b0_01111110_11000000000000000000000, 32'b1_01111011_00101111000110101010000);
    test_res = res == 32'b1_01111011_00001001001101110100110;
    @(posedge clk)    
    res = mult_float(32'b0_01110101_00111010100100101010010, 32'b0_10000000_00000000000000000000000);
    test_res = res == 32'b0_01110110_00111010100100101010010;
    @(posedge clk)    
    res = mult_float(32'b1_10000000_10001111011111001111111, 32'b0_01110101_00111010100100101010010);
    test_res = res == 32'b1_01110110_11101010111001000010010;
    
//    @(posedge clk)    
//    res = sum_float(32'b0_01111110_11000000000000000000000, 32'b1_01111011_00101111000110101010000);
//    test_res = res == 32'b0_01111110_10011010000111001010110;

    @(posedge clk)    
    res = sum_float(32'b1_01111111_01010111000010100011110, 32'b0_01111111_00000000000000000000000);
    test_res = res == 32'b1_01111111_01010111000010100011110;
    
    @(posedge clk)    
    res = div_float(32'b0_01111110_11000000000000000000000, 32'b1_01111011_00101111000110101010000);
    test_res = res == 32'b1_10000010_01111010011000001101110;

    @(posedge clk)    
    res = div_float(32'b0_01110101_00111010100100101010010, 32'b0_10000000_00000000000000000000000);
    test_res = res == 32'b0_01110100_00111010100100101010010;

    @(posedge clk)    
    res = div_float(32'b0_01111111_00000000000000000000000, 32'b0_10000001_00000000000000000000000);
    test_res = res == 32'b0_01111101_00000000000000000000000;
end

endmodule
