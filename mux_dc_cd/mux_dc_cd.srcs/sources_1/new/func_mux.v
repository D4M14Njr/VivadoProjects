`timescale 1ns / 1ps

module func_mux(
    input [4:0] in,
    output f);
    
wire w0_0, w0_1, w0_2, w0_3;
wire w1_0, w1_1, w1_2, w1_3;
wire w2_0, w2_1;

mux mux0(.a(in[1]), .x({in[0], 1'b1}), .Y(w0_0));
mux mux1(.a(in[1]), .x({in[0], ~in[0]}), .Y(w0_1));
mux mux2(.a(in[1]), .x({1'b0, in[0]}), .Y(w0_2));
mux mux3(.a(in[1]), .x({~in[0], 1'b1}), .Y(w0_3));

mux mux4(.a(in[2]), .x({w0_1, w0_0}), .Y(w1_0));
mux mux5(.a(in[2]), .x({w0_2, w0_0}), .Y(w1_1));
mux mux6(.a(in[2]), .x({~w0_2, w0_0}), .Y(w1_2));
mux mux7(.a(in[2]), .x({w0_3, in[0]}), .Y(w1_3));

mux mux8(.a(in[3]), .x({w1_1, w1_0}), .Y(w2_0));
mux mux9(.a(in[3]), .x({w1_3, w1_2}), .Y(w2_1));

mux mux10(.a(in[4]), .x({w2_1, w2_0}), .Y(f));

endmodule