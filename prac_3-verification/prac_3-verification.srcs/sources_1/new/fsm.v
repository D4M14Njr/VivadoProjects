module fsm (
    input [7:0] data,
    input R_I,
    input reset,
    input clk,
    output [16:0] res,
    output reg R_O,
    output [2:0] current_state);
    
parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

reg [2:0] state;
reg signed [7:0] a_, b_, c_, d_;
reg signed [16:0] res_;

initial
begin
    state = S0;
    a_ = 0;
    b_ = 0;
    c_ = 0;
    d_ = 0;
    res_ = 0;
    R_O = 0;
end

always@(posedge clk)
begin
    if (reset)
        state <= S0;
    else
        case(state)
            S0: begin
                    a_ <= 0;
                    b_ <= 0;
                    c_ <= 0;
                    d_ <= 0;
                    state <= S1;
                    R_O <= 0;
                end
            S1: if (R_I) 
                begin
                    a_ <= data;
                    state <= S2;
                end
            S2: if (R_I) 
                begin
                    b_ <= data;
                    state <= S3;
                end
            S3: if (R_I) 
                begin
                    c_ <= data;
                    state <= S4;
                end
            S4: if (R_I) 
                begin
                    d_ <= data;
                    state <= S5;
                end
            S5: begin
                    res_ <= a_ - b_ * c_ / d_;
                    state <= S0;
                    R_O <= 1;
                end
        endcase
end

assign res = res_;

assign current_state = state;

endmodule
