module fsm_calculation(
    input clk,
    input calc_enable,
    input [31:0] a11, a12, a13, a21, a22, a23, a31, a32, a33, b1, b2, b3,
    output [31:0] x1, x2, x3,
    output reg ready_calc_output,
    output reg [1:0] calc_error);

parameter S0 = 4'h0, S1 = 4'h1, S2 = 4'h2, S3 = 4'h3,
          S4 = 4'h4, S5 = 4'h5, S6 = 4'h6, S7 = 4'h7,
          S8 = 4'h8, S9 = 4'h9, S10 = 4'ha;

parameter [1:0] INF_ERROR = 2'b01, NAN_ERROR = 2'b10;
parameter [30:0] e = 31'b01110001_10100011011011100010111; //0.0001

reg [3:0] calc_state;
reg [31:0] MATRIX [2:0][2:0];
reg [31:0] VECTOR [2:0];
reg [31:0] DIAGONAL [2:0];
reg [31:0] X [2:0];
reg [31:0] X_NEW [2:0];
reg [30:0] x_change [2:0];
reg [6:0] calc_cnt;
reg [1:0] a, b, c;

assign x1 = X[0];
assign x2 = X[1];
assign x3 = X[2];

initial calc_state <= S0;

always@(posedge clk)
begin
    case(calc_state)
        S0: begin
            MATRIX[0][0] <= 0; MATRIX[0][1] <= 0; MATRIX[0][2] <= 0;
            MATRIX[1][0] <= 0; MATRIX[1][1] <= 0; MATRIX[1][2] <= 0;
            MATRIX[2][0] <= 0; MATRIX[2][1] <= 0; MATRIX[2][2] <= 0;
            VECTOR[0] <= 0; VECTOR[1] <= 0; VECTOR[2] <= 0;  
            X[0] <= 0; X[1] <= 0; X[2] <= 0;
            X_NEW[0] <= 0; X_NEW[1] <= 0; X_NEW[2] <= 0;
            
            calc_error <= 0;
            ready_calc_output <= 0;
            calc_cnt <= 0;
            a <= 0; b <= 0; c <= 1;
            if (calc_enable)
                calc_state <= S1;
        end
        S1: begin
            MATRIX[0][0] <= a11; MATRIX[0][1] <= a12; MATRIX[0][2] <= a13;
            MATRIX[1][0] <= a21; MATRIX[1][1] <= a22; MATRIX[1][2] <= a23;
            MATRIX[2][0] <= a31; MATRIX[2][1] <= a32; MATRIX[2][2] <= a33;
            VECTOR[0] <= b1; VECTOR[1] <= b2; VECTOR[2] <= b3;
            DIAGONAL[0] <= a11; DIAGONAL[1] <= a22; DIAGONAL[2] <= a33;
            calc_state <= S2;
        end
        S2: begin
            MATRIX[a][b] <= div_float(MATRIX[a][c], {~DIAGONAL[a][31], DIAGONAL[a][30:0]});
            calc_state <= S3;
        end
        S3: begin
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
               calc_state <= S4;
            end
            else calc_state <= S2;
        end
        S4: begin
            MATRIX[a][2] <= div_float(VECTOR[a], DIAGONAL[a]);
            calc_state <= S5;
        end
        S5: begin
            if (a == 2) begin 
                a <= 0;
                calc_state <= S6; 
            end
            else begin
                a <= a + 1;
                calc_state <= S4;
            end
        end
        S6: begin
            case(a)
                0: begin b = 1; c = 2; end
                1: begin b = 0; c = 2; end
                2: begin b = 0; c = 1; end
            endcase 
            
            X_NEW[a] = sum_float(sum_float(mult_float(MATRIX[a][0], X[b]), mult_float(MATRIX[a][1], X[c])), MATRIX[a][2]);
            x_change[a] = sum_float(X_NEW[a], {~X[a][31], X[a][30:0]});
            X[a] = X_NEW[a];
            calc_state <= S7;
        end
        S7: begin
            if (a == 2) begin
                a <= 0;
                b <= 0;
                c <= 0;
                calc_state <= S8;
            end
            else begin
                a <= a + 1;
                calc_state <= S6;
            end
        end
        S8: begin
            if (((x_change[0][30:23] < e[30:23] && x_change[0][22:0] < e[22:0]) && 
                 (x_change[1][30:23] < e[30:23] && x_change[1][22:0] < e[22:0]) && 
                 (x_change[2][30:23] < e[30:23] && x_change[2][22:0] < e[22:0])) || calc_cnt == 7'd100)
            begin
                a <= 0;
                ready_calc_output <= 1;
                calc_state <= S9;
            end
            else begin
                calc_cnt <= calc_cnt + 1'b1;
                calc_state <= S6;
            end
        end
        S9: begin
            ready_calc_output <= 1;
            calc_state <= S10;
        end
        S10: begin
            ready_calc_output <= 0;
            calc_state <= S0;
        end
    endcase
end


// функция деления чисел с плавающей точкой
function [31:0] div_float;
    input [31:0] a, b;
reg [48:0] res_m;
reg [8:0] res_e;
begin
    if (calc_error == 1'b0 & a[30:0] == 31'b0 & b[30:0] == 31'b0)
        calc_error = NAN_ERROR;
    else if (calc_error == 1'b0 & b[30:0] == 31'b0)
        calc_error = INF_ERROR;
    if (a[30:0] == 31'b0)
        div_float = 32'b0;
    else begin
        res_e = $signed({1'b0, a[30:23]}) - $signed({1'b0, b[30:23]}) + 9'd127;
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

endmodule
