module mealy_fsm #(STATE = 0)(
    input a, b, c, clk,
    output reg d);
    
reg [1:0] state;
reg [1:0] next_state = STATE;
reg a_, b_, c_;

always@(posedge clk)
begin
    a_ <= a;
    b_ <= b;
    c_ <= c;
    state <= next_state;
end

always@*
begin
    case(state)
        0: begin
            d = b_ & a_;
            casex({a_, b_, c_})
                3'b0x0: next_state = 2;
                3'bxx1: next_state = 1;
                3'b1x0: next_state = 0;
            endcase
        end
        1: begin
            d = b_ ^ c_;
            casex({a_, b_, c_})
                3'bxx0: next_state = 3;
                3'bxx1: next_state = 0;
            endcase
        end
        2: begin 
            d = ~(c_ | a_);
            casex({a_, b_, c_})
                3'bxx0: next_state = 3;
                3'bxx1: next_state = 1;
            endcase
        end
        3: begin
            d = b_ ^ a_;
            casex({a_, b_, c_})
                3'bx0x: next_state = 0;
                3'bx1x: next_state = 2;
            endcase
        end
    endcase
end

endmodule
