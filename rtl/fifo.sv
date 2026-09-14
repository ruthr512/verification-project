`timescale 1ns/1ps
module fifo (
    input logic clk,
    input logic reset,
    input logic write_en,
    input logic read_en,
    input logic [7:0] data_in,
    output logic [7:0] data_out,
    output logic full,
    output logic empty
);

logic [7:0] memory [0:3];
logic [1:0] write_ptr;
logic [1:0] read_ptr;
logic [2:0] counter;

always_ff @(posedge clk) begin

    if (reset) begin

        write_ptr <= 0;
        read_ptr  <= 0;
        counter   <= 0;
        empty     <= 1;
        full      <= 0;
        data_out  <= 0;

    end

    else if (write_en && !full && !(read_en && !empty)) begin
        // Write בלבד
        memory[write_ptr] <= data_in;
        write_ptr <= write_ptr + 1;
        counter <= counter + 1;
        empty <= 0;
        if (counter == 3) begin
            full <= 1;
        end

    end

    else if (read_en && !empty && !(write_en && !full)) begin
        // Read בלבד
        data_out <= memory[read_ptr];
        read_ptr <= read_ptr + 1;
        counter <= counter - 1;
        full <= 0;
        if (counter == 1) begin
            empty <= 1;
        end

    end

    else if ((write_en && !full) && (read_en && !empty)) begin
        // Write ו-Read בו זמנית
        memory[write_ptr] <= data_in;
        write_ptr <= write_ptr + 1;

        data_out <= memory[read_ptr];
        read_ptr <= read_ptr + 1;

    end

end

endmodule