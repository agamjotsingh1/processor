module shift_right (
    input wire signed [63:0] in,
    input wire [5:0] amt,

    /* 0 -> logical shift
       1 -> arithmetic shift */
    input wire control,

    output wire [63:0] out
);
    assign out = control ? (in >>> amt): (in >> amt);
endmodule