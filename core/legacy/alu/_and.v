module _and (
    input wire [63:0] in1,
    input wire [63:0] in2,
    output wire [63:0] out
);
    assign out = in1 & in2;
endmodule