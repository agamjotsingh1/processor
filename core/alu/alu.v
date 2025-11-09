module alu (
    input wire clk, // for multicycle division

    input wire [63:0] in1,
    input wire [63:0] in2,

    // ALUOp
    input wire [1:0] control,
    input wire [2:0] select,

    // flags
    output reg zero,
    output reg neg, // if in1 < in2, neg = 1, 0 otherwise
    output reg negu, // unsigned in1 and in2

    output reg [63:0] out
);
    wire [63:0] addsub_out;
    wire [63:0] mul_out;
    wire [63:0] div_out;
    wire [63:0] shift_left_out;
    wire [63:0] shift_right_out;
    wire [63:0] xor_out;
    wire [63:0] or_out;
    wire [63:0] and_out;

    addsub addsub_instance (
        .in1(in1),
        .in2(in2),
        .control(control),
        .out(addsub_out)
    );

    mul mul_instance (
        .in1(in1),
        .in2(in2),
        .control(control),
        .out(mul_out)
    );

    div div_instance (
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .control(control),
        .out(div_out)
    );
    
    shift_left shift_left_instance (
        .in(in1),
        .amt(in2[5:0]),
        .out(shift_left_out)
    );

    shift_right shift_right_instance (
        .in(in1),
        .amt(in2[5:0]),
        .control(control[0]),
        .out(shift_right_out)
    );

    _xor xor_instance (
        .in1(in1),
        .in2(in2),
        .out(xor_out)
    );

    _or or_instance (
        .in1(in1),
        .in2(in2),
        .out(or_out)
    );

    _and and_instance (
        .in1(in1),
        .in2(in2),
        .out(and_out)
    );

    always @(*) begin
        case (select)
            3'b000: out = addsub_out;
            3'b001: out = mul_out;
            3'b010: out = div_out;
            3'b011: out = shift_left_out;
            3'b100: out = shift_right_out;
            3'b101: out = xor_out;
            3'b110: out = or_out;
            3'b111: out = and_out;
            default: out = 64'b0;
        endcase

        zero = (in1 == in2) ? 1: 0;
        neg = ($signed(in1) < $signed(in2)) ? 1: 0;
        negu = ($unsigned(in1) < $unsigned(in2)) ? 1: 0;
    end
endmodule