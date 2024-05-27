module fsm (
    input [16:0] data,
    input [4:0] first_one,
    input input_enable,
    input reset,
    input clk,
    output reg mode,
    output reg [31:0] float_data_out,
    output reg ready_output,
    output reg [1:0] i, j,
    output reg [1:0] error_out);

clk_div #(20) div2( // change it to 20
    .clk(clk),
    .clk_d(calc_clk));
    
reg calc_enable = 0;
wire [31:0] x1_out, x2_out, x3_out;
wire ready_calc_output;
wire [1:0] calc_error;

fsm_calculation fc(
    .clk(calc_clk),
    .calc_enable(calc_enable),
    .a11(INP_MATRIX[0][0]), .a12(INP_MATRIX[0][1]), .a13(INP_MATRIX[0][2]),
    .a21(INP_MATRIX[1][0]), .a22(INP_MATRIX[1][1]), .a23(INP_MATRIX[1][2]),
    .a31(INP_MATRIX[2][0]), .a32(INP_MATRIX[2][1]), .a33(INP_MATRIX[2][2]),
    .b1(INP_VECTOR[0]), .b2(INP_VECTOR[1]), .b3(INP_VECTOR[2]),
    .x1(x1_out), .x2(x2_out), .x3(x3_out),
    .ready_calc_output(ready_calc_output),
    .calc_error(calc_error));

parameter S0 = 4'h0, S1 = 4'h1, S2 = 4'h2, S3 = 4'h3,
          S4 = 4'h4, S5 = 4'h5, S6 = 4'h6, S7 = 4'h7,
          S8 = 4'h8;

reg [3:0] state;
reg [31:0] INP_MATRIX [2:0][2:0];
reg [31:0] INP_VECTOR [2:0];
reg [31:0] X [2:0];

initial state <= S0;

always@(posedge clk)
begin
    if (reset)
        state <= S0;
    else
        case(state)
            S0: begin
                INP_MATRIX[0][0] <= 0; INP_MATRIX[0][1] <= 0; INP_MATRIX[0][2] <= 0;
                INP_MATRIX[1][0] <= 0; INP_MATRIX[1][1] <= 0; INP_MATRIX[1][2] <= 0;
                INP_MATRIX[2][0] <= 0; INP_MATRIX[2][1] <= 0; INP_MATRIX[2][2] <= 0;
                INP_VECTOR[0] <= 0; INP_VECTOR[1] <= 0; INP_VECTOR[2] <= 0;  
                X[0] <= 0; X[1] <= 0; X[2] <= 0;
                mode <= 0;
                error_out <= 0;
                ready_output <= 0;
                i <= 0; j <= 0;
                state <= S1;
            end
            S1: if (input_enable) 
            begin
                if (first_one == 5'd16) begin
                    INP_MATRIX[i][j] <= 32'b0;
                end
                else begin
                    INP_MATRIX[i][j] <= {data[16], 8'd127 + first_one, data[15:0] << (5'd16 - first_one), 7'b0};
                end
                state <= S2;
            end
            S2: begin
                if (j == 2) begin
                    i = i + 1;
                    j = 0;
                end
                else j = j + 1;
 
                if (i == 3) begin 
                    i = 0;
                    j = 3;
                    state <= S3;
                end
                else state <= S1;
            end
            S3: if (input_enable)
            begin        
                if (first_one == 5'd16)
                    INP_VECTOR[i] <= 32'b0;
                else
                    INP_VECTOR[i] <= {data[16], 8'd127 + first_one, data[15:0] << (5'd16 - first_one), 7'b0};
                state <= S4;
            end
            S4: begin
                if (i == 2) begin
                    i <= 0;
                    calc_enable <= 1;
                    state <= S5;
                end
                else begin
                    i <= i + 1;
                    state <= S3;
                end
            end
            S5: begin
                if (ready_calc_output) begin
                    calc_enable <= 0;
                    
                    if (|(calc_error)) 
                        error_out <= calc_error;
                    X[0] <= x1_out;
                    X[1] <= x2_out;
                    X[2] <= x3_out;
                    state <= S6;
                end
            end
            S6: begin
                mode <= 1;
                float_data_out <= X[i];
                ready_output <= 1;
                if (error_out) 
                    state <= S8;
                else 
                    state <= S7;
            end
            S7: begin
                ready_output <= 0;
                if (input_enable) begin
                    if (i == 2)
                        i <= 0;
                    else
                       i <= i + 1;
                    state <= S6;
                end
            end
            S8: ready_output <= 0;
        endcase
end

endmodule
