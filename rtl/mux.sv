module mux_4to1 (
    input logic d0,
    input logic d1,
    input logic d2,
    input logic d3,
    input logic s0,
    input logic s1,
    output logic y
);

always_comb begin
    case ({s1, s0})
        2'b00: y = d0;
        2'b01: y = d1;
        2'b10: y = d2;
        2'b11: y = d3;
endcase
end

endmodule