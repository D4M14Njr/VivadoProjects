module main(
    input [2:0] a, 
    input [2:0] b, 
    input [2:0] c, 
    input [2:0] d,
    output [6:0] res); 

assign res = a - b * c / d;

endmodule
