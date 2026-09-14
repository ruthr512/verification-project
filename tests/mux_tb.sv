module mux_tb;
    logic d0, d1, d2, d3;
    logic s0, s1;
    logic y;
    mux_4to1 dut (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .s0(s0),
        .s1(s1),
        .y(y)
    );
    logic expected; 
    integer i;
    initial begin
        for(i = 0; i < 64; i = i + 1) begin
            d0 = i[3];
            d1 = i[2];
            d2 = i[1];
            d3 = i[0];
            s1 = i[5];
            s0 = i[4];
            expected = (s1 == 0 && s0 == 0) ? d0 :
                       (s1 == 0 && s0 == 1) ? d1 :
                       (s1 == 1 && s0 == 0) ? d2 : d3;
            #1;
            if(y==expected)begin
               $display("PASS: d0=%b d1=%b d2=%b d3=%b s1=%b s0=%b y=%b expected=%b", d0, d1, d2, d3, s1, s0, y, expected); 
            end
            else begin
                $display("FAIL: d0=%b d1=%b d2=%b d3=%b s1=%b s0=%b y=%b expected=%b", d0, d1, d2, d3, s1, s0, y, expected);
            end
        end
    end

endmodule