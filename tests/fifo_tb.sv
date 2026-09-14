module fifo_tb;

    logic clk;
    logic reset;
    logic write_en;
    logic read_en;
    logic [7:0] data_in;
    logic [7:0] data_out;
    logic full;
    logic empty;

    fifo dut (
        .clk(clk),
        .reset(reset),
        .write_en(write_en),
        .read_en(read_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock: period = 10
    always #5 clk = ~clk;

    initial begin

        // VCD
        $dumpfile("fifo.vcd");
        $dumpvars(0, fifo_tb);

        // Initial values
        clk      = 0;
        reset    = 1;
        write_en = 0;
        read_en  = 0;
        data_in  = 8'h00;


        // ============================================================
        // 1. RESET
        // ============================================================

        @(posedge clk);
        #1;

        reset = 0;

        $display("RESET DONE: counter=%0d, empty=%b, full=%b",
                 dut.counter, empty, full);


        // ============================================================
        // 2. BASIC TEST
        // Write AA -> Read AA
        // ============================================================

        @(negedge clk);
        data_in  = 8'hAA;
        write_en = 1;
        read_en  = 0;

        @(posedge clk);
        #1;

        $display("WRITE AA: counter=%0d, write_ptr=%0d",
                 dut.counter, dut.write_ptr);

        @(negedge clk);
        write_en = 0;
        read_en  = 1;

        @(posedge clk);
        #1;

        if (data_out == 8'hAA)
            $display("PASS: basic read, data_out=%h", data_out);
        else
            $display("FAIL: basic read, data_out=%h", data_out);


        // ============================================================
        // 3. RESET BEFORE NEXT TEST
        // ============================================================

        @(negedge clk);
        reset    = 1;
        write_en = 0;
        read_en  = 0;

        @(posedge clk);
        #1;

        reset = 0;


        // ============================================================
        // 4. FIFO ORDER TEST
        // Write AA -> Write BB -> Read AA -> Read BB
        // ============================================================

        @(negedge clk);
        data_in  = 8'hAA;
        write_en = 1;
        read_en  = 0;

        @(posedge clk);
        #1;

        @(negedge clk);
        data_in  = 8'hBB;

        @(posedge clk);
        #1;

        $display("AFTER TWO WRITES: counter=%0d",
                 dut.counter);


        // Read AA
        @(negedge clk);
        write_en = 0;
        read_en  = 1;

        @(posedge clk);
        #1;

        if (data_out == 8'hAA)
            $display("PASS: first FIFO read, data_out=%h", data_out);
        else
            $display("FAIL: first FIFO read, data_out=%h", data_out);


        // Read BB
        @(posedge clk);
        #1;

        if (data_out == 8'hBB)
            $display("PASS: second FIFO read, data_out=%h", data_out);
        else
            $display("FAIL: second FIFO read, data_out=%h", data_out);


        // ============================================================
        // 5. RESET
        // ============================================================

        @(negedge clk);
        reset   = 1;
        read_en = 0;

        @(posedge clk);
        #1;

        reset = 0;


        // ============================================================
        // 6. EDGE CASE - READ EMPTY FIFO
        // ============================================================

        @(negedge clk);
        write_en = 0;
        read_en  = 1;

        @(posedge clk);
        #1;

        if (dut.counter == 0 &&
            empty == 1 &&
            dut.read_ptr == 0 &&
            data_out == 8'h00)

            $display("PASS: read empty FIFO");

        else

            $display("FAIL: read empty FIFO: counter=%0d empty=%b read_ptr=%0d data_out=%h",
                     dut.counter, empty, dut.read_ptr, data_out);


        // ============================================================
        // 7. RESET
        // ============================================================

        @(negedge clk);
        reset   = 1;
        read_en = 0;

        @(posedge clk);
        #1;

        reset = 0;


        // ============================================================
        // 8. EDGE CASE - WRITE UNTIL FULL
        // ============================================================

        // Write 1
        @(negedge clk);
        data_in  = 8'h11;
        write_en = 1;

        @(posedge clk);
        #1;

        // Write 2
        @(negedge clk);
        data_in = 8'h22;

        @(posedge clk);
        #1;

        // Write 3
        @(negedge clk);
        data_in = 8'h33;

        @(posedge clk);
        #1;

        // Write 4
        @(negedge clk);
        data_in = 8'h44;

        @(posedge clk);
        #1;

        if (dut.counter == 4 && full == 1)
            $display("PASS: FIFO became full");
        else
            $display("FAIL: FIFO full: counter=%0d full=%b",
                     dut.counter, full);


        // ============================================================
        // 9. EDGE CASE - WRITE WHEN FULL
        // ============================================================

        @(negedge clk);
        data_in = 8'h55;

        @(posedge clk);
        #1;

        if (dut.counter == 4 && full == 1)
            $display("PASS: write blocked when FIFO full");
        else
            $display("FAIL: write when full: counter=%0d full=%b",
                     dut.counter, full);


        // ============================================================
        // 10. EDGE CASE - READ AND WRITE TOGETHER
        // ============================================================

        @(negedge clk);
        data_in  = 8'h55;
        write_en = 1;
        read_en  = 1;

        // Note:
        // FIFO is full, so current FIFO design will not enter
        // the simultaneous branch because !full is false.
        // Therefore we first read one item below.


        @(posedge clk);
        #1;

        // Read first item (11)
        @(negedge clk);
        write_en = 0;
        read_en  = 1;

        @(posedge clk);
        #1;

        // Now FIFO is no longer full.


        // Simultaneous read + write
        @(negedge clk);
        data_in  = 8'h66;
        write_en = 1;
        read_en  = 1;

        @(posedge clk);
        #1;

        $display("SIMULTANEOUS R/W: counter=%0d write_ptr=%0d read_ptr=%0d data_out=%h",
                 dut.counter, dut.write_ptr, dut.read_ptr, data_out);


        // ============================================================
        // END
        // ============================================================

        $display("======================================");
        $display("FIFO TESTBENCH FINISHED");
        $display("======================================");

        $finish;
    end

endmodule