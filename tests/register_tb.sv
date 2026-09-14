module register_tb;

    logic clk;
    logic reset;
    logic [7:0] d;
    logic [7:0] q;

    register dut (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

    initial begin
        clk = 0;
        reset = 1;
        d = 8'b00000000;

        @(posedge clk);

        if (q == 8'b00000000) begin
            $display("PASS: reset works, q=%b", q);
        end
        else begin
            $display("FAIL: reset failed, q=%b", q);
        end

        reset = 0;

        @(negedge clk);
        d = 8'b10101010;

        @(negedge clk);
        d = 8'b11110000;

        @(negedge clk);
        d = 8'b00110011;

        @(posedge clk);

        if (q == 8'b00110011) begin
            $display("PASS: register captured last d, q=%b", q);
        end
        else begin
            $display("FAIL: register captured wrong value, q=%b", q);
        end
    end

    always #5 clk = ~clk;

endmodule