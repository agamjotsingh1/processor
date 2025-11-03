
module ex_stage #(
    parameter BUS_WIDTH=64,
    parameter ALU_CONTROL_WIDTH=2,
    parameter ALU_SELECT_WIDTH=3,
    parameter FPU_OP_WIDTH=3
)(
    // Control Pins
    input wire alu_src,
    input wire alu_fpu,

    // REGFILE Outputs
    input wire [(BUS_WIDTH - 1):0] read_data1,
    input wire [(BUS_WIDTH - 1):0] read_data2,

    // ALU Controls
    input wire [(ALU_CONTROL_WIDTH - 1):0] control,
    input wire [(ALU_SELECT_WIDTH - 1):0] select,

    // FPU Controls
    input wire fpu_rd,
    input wire [(FPU_OP_WIDTH - 1):0] fpu_op,

    // IMMGEN output
    input wire [(BUS_WIDTH - 1):0] imm,

    input wire [(BUS_WIDTH - 1):0] pc,

    output wire [(BUS_WIDTH - 1):0] alu_fpu_result
);
    wire [(BUS_WIDTH - 1):0] alu_fpu_in1 = read_data1;
    wire [(BUS_WIDTH - 1):0] alu_fpu_in2 = alu_src ? imm: read_data2;

    wire [(BUS_WIDTH - 1):0] alu_out;
    wire [(BUS_WIDTH - 1):0] fpu_out;

    alu alu_instance (
        .in1(alu_fpu_in1),
        .in2(alu_fpu_in2),
        .control(control),
        .select(select),
        .out(alu_out)
    );

    fpu fpu_instance (
        .in1(alu_fpu_in1),
        .in2(alu_fpu_in2),
        .fpu_op(fpu_op),
        .out(fpu_out)
    );

    wire [(BUS_WIDTH - 1):0] pc_plus_4 = pc + 4;
    wire [(BUS_WIDTH - 1):0] alu_fpu_out = alu_fpu ? fpu_out: alu_out;

    assign alu_fpu_result = jump_src ? pc_plus_4: alu_fpu_out;
endmodule