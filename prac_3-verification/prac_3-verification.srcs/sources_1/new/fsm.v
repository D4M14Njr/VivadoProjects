module fsm (
    input [7:0] data,
    input input_enable,
    input reset,
    input clk,
    output reg [16:0] data_out,
    output reg output_enable,
    output reg error_out,
    output [2:0] current_state);
    
parameter S0 = 3'b000,
          S1 = 3'b001,
          S2 = 3'b010,
          S3 = 3'b011,
          S4 = 3'b100,
          S5 = 3'b101,
          S6 = 3'b110;

reg [3:0] state;
reg signed [7:0] a_, b_, c_, d_;

initial state <= S0;

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
                    output_enable <= 0;
                    error_out <= 0;
                end
            S1: if (input_enable) 
                begin
                    a_ <= data;
                    state <= S2;
                end
            S2: if (input_enable) 
                begin
                    b_ <= data;
                    state <= S3;
                end
            S3: if (input_enable) 
                begin
                    c_ <= data;
                    state <= S4;
                end
            S4: if (input_enable) 
                begin
                    d_ <= data;
                    state <= S5;
                end
            S5: begin
                    if (d_ == 0)
                        error_out <= 1;
                    else if (c_ == 0)
                        data_out <= a_;
                    else
                        data_out <= a_ - b_ * c_ / d_;
                    output_enable <= 1;
                    state <= S0;
                end
        endcase
end

assign current_state = state;

endmodule
