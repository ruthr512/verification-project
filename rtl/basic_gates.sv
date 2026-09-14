module and_gate (
    input logic a,
    input logic b,
    output logic y
);
    assign y = a & b;
endmodule

module or_gate (
    input logic a,
    input logic b,
    output logic y
);
    assign y = a | b;
endmodule

module not_gate (
    input logic a,
    output logic y
);
    assign y = ~a;
endmodule

module xor_gate (
    input logic a,
    input logic b,
    output logic y
);
    assign y = a ^ b;
endmodule