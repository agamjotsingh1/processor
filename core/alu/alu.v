module alu (
    input wire [63:0] in1,
    input wire [63:0] in2,

    input wire [2:0] funct3,
    input wire [6:0] funct7,

    output reg [63:0] out
);
    reg [1:0] control;
    reg [2:0] select;

    alu_control alu_control_instance (
        .funct3(funct3),
        .funct7(funct7),
        .control(control),
        .select(select)
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
    end
endmodule