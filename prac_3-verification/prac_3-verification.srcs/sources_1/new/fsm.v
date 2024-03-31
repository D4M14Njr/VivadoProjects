module fsm (
    input [15:0] data,
    input input_enable,
    input reset,
    input clk,
    output reg [31:0] data_out,
    output reg output_enable,
    output reg error_out,
    output [2:0] current_state);
    
parameter S0 = 3'b000,
          S1 = 3'b001,
          S2 = 3'b010,
          S3 = 3'b011,
          S4 = 3'b100,
          S5 = 3'b101;

reg [3:0] state;
reg signed [15:0] a, b, c, d;

initial state <= S0;

always@(posedge clk)
begin
    if (reset)
        state <= S0;
    else
        case(state)
            S0: begin
                    a <= 0;
                    b <= 0;
                    c <= 0;
                    d <= 0;
                    output_enable <= 0;
                    error_out <= 0;
                    state <= S1;
                end
            S1: if (input_enable) 
                begin
                    a <= data;
                    state <= S2;
                end
            S2: if (input_enable) 
                begin
                    b <= data;
                    state <= S3;
                end
            S3: if (input_enable) 
                begin
                    c <= data;
                    state <= S4;
                end
            S4: if (input_enable) 
                begin
                    d <= data;
                    state <= S5;
                end
            S5: begin
                    if (d == 0)
                        error_out <= 1;
                    else if (b == 0 || c == 0)
                        data_out <= a;
                    else
                        data_out <= a - b * c / d;
                    output_enable <= 1;
                    state <= S0;
                end
        endcase
end

assign current_state = state;

endmodule
