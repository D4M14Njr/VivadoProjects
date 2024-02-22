`timescale 1ns / 1ps

module test();
    
wire t_flipflop_ds_res;
reg r;

t_flipflop_ds tr (.t(r), .q(t_flipflop_ds_res));

always #10 r = r + 1;

initial
    begin
        r = 0;
        #40
        $finish;
    end

endmodule
