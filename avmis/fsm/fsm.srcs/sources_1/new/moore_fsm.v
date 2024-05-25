module moore_fsm #(STATE = 0)(
    input a, b, c, clk,
    output reg d);

parameter s00 = 3'b000, s01 = 3'b001, 
          s10 = 3'b010, s11 = 3'b011, 
          s20 = 3'b100, s21 = 3'b101, 
          s30 = 3'b110, s31 = 3'b111;

reg [2:0] state;
reg [2:0] next_state = STATE;
reg a_, b_, c_;

always@(posedge clk)
begin
    a_ = a;
    b_ = b;
    c_ = c;
    state = next_state;
end

always@(a_, b_, c_, state)
begin
    casex({state, a, b, c})
        {s00, 3'b0x0}, {s01, 3'b0x0}: next_state = s20;
        {s00, 3'b0x1}, {s01, 3'b0x1}: next_state = s10;
        {s00, 3'b100}, {s01, 3'b100}: next_state = s00;
        {s00, 3'b101}, {s01, 3'b101}: next_state = s10;
        {s00, 3'b110}, {s01, 3'b110}: next_state = s01;
        {s00, 3'b111}, {s01, 3'b111}: next_state = s11;
        
        {s10, 3'bx00}, {s11, 3'bx00}: next_state = s30;
        {s10, 3'bx01}, {s11, 3'bx01}: next_state = s01;
        {s10, 3'bx10}, {s11, 3'bx10}: next_state = s31;
        {s10, 3'bx11}, {s11, 3'bx11}: next_state = s00;
        
        {s20, 3'bx00}, {s21, 3'bx00}: next_state = s31;
        {s20, 3'bxx1}, {s21, 3'bxx1}: next_state = s10;
        {s20, 3'bx10}, {s21, 3'bx10}: next_state = s30;
        
        {s30, 3'b00x}, {s31, 3'b00x}: next_state = s00;
        {s30, 3'b01x}, {s31, 3'b01x}: next_state = s21;
        {s30, 3'b10x}, {s31, 3'b10x}: next_state = s01;
        {s30, 3'b11x}, {s31, 3'b11x}: next_state = s20;
    endcase
end

always@(state) 
begin
    casex(state)
        3'bxx0: d = 1'b0;
        3'bxx1: d = 1'b1;
    endcase
end

endmodule