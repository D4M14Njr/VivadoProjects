module fifo_one_clk #(MEM_SIZE = 8, WORD_SIZE = 4, localparam ADDR_SIZE = $clog2(MEM_SIZE)) (
    input clk, enable, reset, write_mode, read_mode,
    input [WORD_SIZE - 1:0] data_in,
    output reg [WORD_SIZE - 1:0] data_out,
    output reg full, empty, valid);

reg [WORD_SIZE - 1:0] memory [0:MEM_SIZE - 1];
reg [ADDR_SIZE - 1:0] write_pointer, read_pointer;
reg [ADDR_SIZE - 1:0] write_pointer_next, read_pointer_next;
reg full_next, empty_next;

integer i;
initial
begin
    write_pointer <= {ADDR_SIZE{1'b0}};
    read_pointer <= {ADDR_SIZE{1'b0}};
    write_pointer_next <= {ADDR_SIZE{1'b0}};
    read_pointer_next <= {ADDR_SIZE{1'b0}};
    full <= 0; full_next <= 0;
    empty <= 1; empty_next <= 1;
    valid <= 0;
    data_out <= {WORD_SIZE{1'b0}};
    
    for (i = 0; i < MEM_SIZE; i = i + 1)
        memory[i] <= {WORD_SIZE{1'b0}};
end

// Операция записи
always@(posedge clk)
    if (enable && write_mode && !full)
        memory[write_pointer] <= data_in;

// Операция чтения
always@(posedge clk)
    if (reset) begin
        valid <= 1'b0;
        data_out <= {WORD_SIZE{1'b0}};
    end
    else if (enable && read_mode && !empty) begin
        data_out <= memory[read_pointer];
        valid <= 1'b1;
    end
    else 
        valid <= 1'b0;

// Блок изменения регистров указателей и флагов
always@(posedge clk)
    if (reset) begin
        write_pointer <= {ADDR_SIZE{1'b0}};
        read_pointer <= {ADDR_SIZE{1'b0}};
        full <= 0;
        empty <= 1;
    end
    else if (enable) begin
        write_pointer <= write_pointer_next;
        read_pointer <= read_pointer_next;
        full <= full_next;
        empty <= empty_next;
    end

function [ADDR_SIZE-1:0] next(input [ADDR_SIZE-1:0] pointer);
begin
    if (pointer == MEM_SIZE - 1)
        next = {ADDR_SIZE{1'b0}};
    else
        next = pointer + 1;
end
endfunction

// Блок определения следущих значений регистров указателей и флагов
reg [1:0] operation;
localparam NONE = 0, READ = 1, WRITE = 2, READ_AND_WRITE = 3;

always@*
begin
    case ({write_mode, read_mode})
        2'b01: operation <= !empty ? READ : NONE;
        2'b10: operation <= !full ? WRITE : NONE;
        2'b11: case ({full, empty})
                    2'b10: operation <= READ;
                    2'b01: operation <= WRITE;
                    default: operation <= READ_AND_WRITE;
        endcase
        default: operation <= NONE;
    endcase
    
    case (operation)
        NONE: begin
            write_pointer_next <= write_pointer;
            read_pointer_next <= read_pointer;
            full_next <= full;
            empty_next <= empty;
        end
        READ: begin
            write_pointer_next <= write_pointer;
            read_pointer_next <= next(read_pointer);
            full_next <= 1'b0;
            empty_next <= read_pointer_next == write_pointer;
        end
        WRITE: begin
            write_pointer_next <= next(write_pointer);  
            read_pointer_next <= read_pointer;
            full_next <= write_pointer_next == read_pointer;
            empty_next <= 1'b0;              
        end
        READ_AND_WRITE: begin
            empty_next <= empty;
            full_next <= full;
            read_pointer_next <= next(read_pointer);
            write_pointer_next <= next(write_pointer);
        end
    endcase    
end 

endmodule
