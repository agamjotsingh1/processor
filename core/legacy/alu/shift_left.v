module shift_left (
    input wire signed [63:0] in,
    input wire [5:0] amt,
    output wire [63:0] out
);
    assign out = in << amt;
endmodule