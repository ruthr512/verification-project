module basic_gates_tb;



    logic a;
    logic b;
    logic y;

    and_gate dut (
        .a(a),
        .b(b),
        .y(y)
    );

    integer i;
    logic expected;
    initial begin
        for(i = 0; i < 4; i = i + 1) begin
            a = i[1];
            b = i[0];
            expected = a & b;
            #1;
            if(y==expected)begin
               $display("PASS: a=%b b=%b y=%b expected=%b", a, b, y, expected); 
            end
            else begin
                $display("FAIL: a=%b b=%b y=%b expected=%b", a, b, y, expected);
            end
        end
    end


    

endmodule