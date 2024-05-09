module PS2_manager (
    input clk,
    input PS2_dat,
    input PS2_clk,
    output reg ready_output,
    output [6:0] out);
    
// Состояние ожидания установки сигнала готовности пакета данных
parameter WAIT_ONE = 0;
// Состояние ожидания сброса сигнала готовности пакета данных
parameter WAIT_ZERO = 1;
reg state;
// Выходы модуля приёма одного пакета PS2
wire PS2_R_O, PS2_ERROR;
wire [7:0] PS2_out;
// Регистр флага отжатия клавиши
reg release_flag;

initial begin
    state = 0; ready_output = 0;
    release_flag = 0;
end

always@(posedge clk)
begin
    case(state)
        WAIT_ONE: begin
            if (PS2_R_O) begin
                if (!PS2_ERROR) begin
                    if (PS2_out == 8'hF0)
                        release_flag <= 1;
                    else if (release_flag) begin
                        ready_output <= 1;
                        release_flag <= 0;
                    end
                end
                state <= WAIT_ZERO;
            end
        end
        WAIT_ZERO: begin
            ready_output <= 0;
            if (!PS2_R_O)
                state <= WAIT_ONE;
        end
    endcase
end

// Приём одного пакета
PS2 ps2(
    .clk(clk),
    .PS2_clk(PS2_clk), 
    .PS2_dat(PS2_dat),
    .out(PS2_out), 
    .ready_output(PS2_R_O),
    .error(PS2_ERROR));

// Дешифратор пакета
PS2_DC dc(.keycode(PS2_out), .out(out));

endmodule