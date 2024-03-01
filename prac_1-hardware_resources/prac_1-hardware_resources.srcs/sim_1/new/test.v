`timescale 1ns / 1ps

module test;

reg [11:0] in = 0;
wire [5:0] res;

main m(.a(in[11:9]), .b(in[8:6]), .c(in[5:3]), .d(in[2:0]), .res(res));

always #10 in = in + 1;

endmodule
