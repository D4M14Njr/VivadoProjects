module main(
    input signed [3:0] a,
    input signed [3:0] b,
    input signed [3:0] c,
    input signed [3:0] d,
    output signed [6:0] res
);

assign res = a - b * c / d;

    
endmodule

