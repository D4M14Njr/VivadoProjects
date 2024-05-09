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
    
parameter S0 = 4'h0, S1 = 4'h1, S2 = 4'h2, S3 = 4'h3,
          S4 = 4'h4, S5 = 4'h5, S6 = 4'h6, S7 = 4'h7,
          S8 = 4'h8, S9 = 4'h9, S10 = 4'ha, S11 = 4'hb,
          S12 = 4'hc, S13 = 4'hd, S14 = 4'he;

parameter [1:0] INF_ERROR = 2'b01, NAN_ERROR = 2'b10;
parameter [30:0] e = 31'b01110001_10100011011011100010111; //0.0001

reg [3:0] state;
reg [31:0] MATRIX [2:0][2:0];
reg [31:0] VECTOR [2:0];
reg [31:0] DIAGONAL [2:0];
reg [31:0] X [2:0];
reg [31:0] X_NEW [2:0];
reg [30:0] x_change [2:0]; 
reg [6:0] calc_cnt; 
reg [1:0] a, b, c; 

// функция деления чисел с плавающей точкой
function [31:0] div_float;
    input [31:0] a, b;
reg [48:0] res_m;
reg [8:0] res_e;
begin
    if (error_out == 1'b0 & a[30:0] == 31'b0 & b[30:0] == 31'b0)
        error_out = NAN_ERROR;
    else if (error_out == 1'b0 & b[30:0] == 31'b0)
        error_out = INF_ERROR;
    if (a[30:0] == 31'b0)
        div_float = 32'b0;
    else begin
        res_e = $signed({1'b0, a[30:23]}) - $signed({1'b0, b[30:23]}) + 9'd127;
        res_m = {1'b1, a[22:0], 24'b0} / {1'b1, b[22:0]};
        res_m = {1'b1, a[22:0], 24'b0} / {1'b1, b[22:0]};
        
        if (res_m[24])
            res_m = res_m >> 1'b1;
        else 
            res_e = res_e - 9'b1;
    
        div_float = {a[31]^b[31], res_e[7:0], res_m[22:0]};
    end
end
endfunction

// функция умножения чисел с плавающей точкой
function [31:0] mult_float;
    input [31:0] a, b;
reg [47:0] res_m;
reg [8:0] res_e;
begin
    if ((a[30:23] == 0 & a[22:0] == 0) | (b[30:23] == 0 & b[22:0] == 0))
        mult_float = 32'b0;
    else begin
        res_e = a[30:23] + b[30:23] - 9'd126;
        res_m = {1'b1, a[22:0]} * {1'b1, b[22:0]};
        if (res_m[47])
            mult_float = {a[31]^b[31], res_e[7:0], res_m[46:24]};
        else
        begin
            res_e = res_e - 9'b1;
            mult_float = {a[31]^b[31], res_e[7:0], res_m[45:23]};
        end
    end
end
endfunction

// функция суммирования чисел с плавающей точкой
function [31:0] sum_float;
    input [31:0] a, b;
reg [8:0] res_e;
reg [7:0] r, f_r;
reg signed [25:0] a_m, b_m, res_m;
reg out;
begin
    out = 1;
    if ((a[30:23] == 0 & a[22:0] == 0))
        sum_float = b;
    else if ((b[30:23] == 0 & b[22:0] == 0))
        sum_float = a;
    else begin
        a_m = {a[31], 2'b01, a[22:0]};
        b_m = {b[31], 2'b01, b[22:0]};
        
        if (a[30:23] > b[30:23]) begin
            res_e = a[30:23];
            r = a[30:23] - b[30:23];
            b_m = {b_m[25], b_m[24:0] >> r};
        end
        else begin
            res_e = b[30:23];
            r = b[30:23] - a[30:23];
            a_m = {a_m[25], a_m[24:0] >> r};
        end
        
        if (a[31])
            a_m = {a_m[25], ~a_m[24:0] + 1'b1};   

        if (b[31])
            b_m = {b_m[25], ~b_m[24:0] + 1'b1};

        if (r >= 8'd24)
            if (a[30:23] > b[30:23])
                sum_float = a;
            else
                sum_float = b;
        else
        begin
            res_m = a_m + b_m;
            if (res_m[25])
                res_m = {res_m[25], ~res_m[24:0] + 1'b1};
            
            if (res_m[24]) begin
                res_e = res_e + 1'b1;
                sum_float = {res_m[25], res_e[7:0], res_m[23:1]};
            end
            else if (res_m[23])
                sum_float = {res_m[25], res_e[7:0], res_m[22:0]};
            else begin
                for (r = 8'd23; r != 1'b0; r = r - 1'b1)
                    if (res_m[r] & out) begin
                        f_r = r;
                        out = 0;
                    end
                res_e = res_e - (8'd23 - f_r);
                res_m = {res_m[25], res_m[24:0] << (8'd23 - f_r)};
                sum_float = {res_m[25], res_e[7:0], res_m[22:0]};
            end
        end
    end
end
endfunction

initial state <= S0;

always@(posedge clk)
begin
    if (reset)
        state <= S0;
    else
        case(state)
            S0: begin
                MATRIX[0][0] <= 0; MATRIX[0][1] <= 0; MATRIX[0][2] <= 0;
                MATRIX[1][0] <= 0; MATRIX[1][1] <= 0; MATRIX[1][2] <= 0;
                MATRIX[2][0] <= 0; MATRIX[2][1] <= 0; MATRIX[2][2] <= 0;
                VECTOR[0] <= 0; VECTOR[1] <= 0; VECTOR[2] <= 0;  
                X[0] <= 0; X[1] <= 0; X[2] <= 0;
                X_NEW[0] <= 0; X_NEW[1] <= 0; X_NEW[2] <= 0;
                
                mode <= 0;
                error_out <= 0;
                ready_output <= 0;
                calc_cnt <= 0;
                i <= 0; j <= 0;
                a <= 0; b <= 0; c <= 1;
                state <= S1;
            end
            S1: if (input_enable) begin
                if (first_one == 5'd16)
                    MATRIX[i][j] <= 32'b0;
                else
                    MATRIX[i][j] <= {data[16], 8'd127 + first_one, data[15:0] << (5'd16 - first_one), 7'b0};
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
                    VECTOR[i] <= 32'b0;
                else
                    VECTOR[i] <= {data[16], 8'd127 + first_one, data[15:0] << (5'd16 - first_one), 7'b0};
                DIAGONAL[i] <= MATRIX[i][i];
                state <= S4;
            end
            S4: begin
                if (i == 2) begin 
                    i <= 0;
                    state <= S5;
                end
                else begin
                    i <= i + 1;
                    state <= S3;
                end
            end
            S5: begin
                MATRIX[a][b] <= div_float(MATRIX[a][c], {~DIAGONAL[a][31], DIAGONAL[a][30:0]});
                state <= S6;
            end
            S6: begin
                if (b == 1) begin
                    a = a + 1;
                    b = 0; c = 0;
                end
                else begin
                    b = b + 1;
                    c = c + 1;
                    if (a == b)
                        c = c + 1;
                end
                if (a == 3) begin 
                   a = 0;
                   b = 0; 
                   c = 1;
                   state <= S7;
                end
                else state <= S5;
            end
            S7: begin
                MATRIX[a][2] <= div_float(VECTOR[a], DIAGONAL[a]);
                state <= S8;
            end
            S8: begin
                if (a == 2) begin 
                    a <= 0;
                    state <= S9; 
                end
                else begin
                    a <= a + 1;
                    state <= S7;
                end
            end
            S9: begin
                case(a)
                    0: begin b = 1; c = 2; end
                    1: begin b = 0; c = 2; end
                    2: begin b = 0; c = 1; end
                endcase 
                
                X_NEW[a] = sum_float(sum_float(mult_float(MATRIX[a][0], X[b]), mult_float(MATRIX[a][1], X[c])), MATRIX[a][2]);
                x_change[a] = sum_float(X_NEW[a], {~X[a][31], X[a][30:0]});
                X[a] = X_NEW[a];
                state <= S10;
            end
            S10: begin
                if (a == 2) begin
                    a <= 0;
                    b <= 0;
                    c <= 0;
                    state <= S11;
                end
                else begin
                    a <= a + 1;
                    state <= S9;
                end
            end
            S11: begin
                if (((x_change[0][30:23] < e[30:23] && x_change[0][22:0] < e[22:0]) && 
                     (x_change[1][30:23] < e[30:23] && x_change[1][22:0] < e[22:0]) && 
                     (x_change[2][30:23] < e[30:23] && x_change[2][22:0] < e[22:0])) || calc_cnt == 7'd100)
                begin
                    a <= 0;
                    mode <= 1;
                    if (error_out == 0)
                        state <= S12;
                    else begin
                        ready_output <= 1;
                        state <= S14;
                    end  
                end
                else begin
                    calc_cnt <= calc_cnt + 1'b1;
                    state <= S9;
                end
            end
            S12: begin
                float_data_out <= X[i];
                ready_output <= 1;
                state <= S13;
            end
            S13: begin
                ready_output <= 0;
                if (input_enable) begin
                    if (i == 2)
                        i <= 0;
                    else
                       i <= i + 1;
                    state <= S12;
                end
            end
            S14: ready_output <= 0;
        endcase
end

endmodule
