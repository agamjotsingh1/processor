
module ex_stage #(
    parameter BUS_WIDTH=64,
    parameter ALU_CONTROL_WIDTH=2,
    parameter ALU_SELECT_WIDTH=3,
    parameter FPU_OP_WIDTH=6
)(
    input wire clk, // for multicycle division
    input wire rst,

    // Control Pins
    input wire jump_src,
    input wire alu_src,
    input wire alu_fpu,

    // REGFILE Outputs
    input wire [(BUS_WIDTH - 1):0] read_data1,
    input wire [(BUS_WIDTH - 1):0] read_data2,

    // ALU Controls
    input wire [(ALU_CONTROL_WIDTH - 1):0] control,
    input wire [(ALU_SELECT_WIDTH - 1):0] select,

    // FPU Controls
    input wire [(FPU_OP_WIDTH - 1):0] fpu_op,

    // IMMGEN output
    input wire [(BUS_WIDTH - 1):0] imm,

    input wire [(BUS_WIDTH - 1):0] pc,

    output wire div_stall, // stall for multicycle division
    output wire [(BUS_WIDTH - 1):0] alu_fpu_result
);
    wire [(BUS_WIDTH - 1):0] alu_fpu_in1 = read_data1;
    wire [(BUS_WIDTH - 1):0] alu_fpu_in2 = alu_src ? imm: read_data2;

    wire [(BUS_WIDTH - 1):0] alu_out;
    wire [(BUS_WIDTH - 1):0] fpu_out;

    alu alu_instance (
        .clk(clk),
        .in1(alu_fpu_in1),
        .in2(alu_fpu_in2),
        .control(control),
        .select(select),
        .out(alu_out)
    );

    wire is_div_instr = (select == 3'b010);

    div_stall_unit div_stall_unit_instance (
        .clk(clk),
        .rst(rst),
        .is_div_instr(is_div_instr),
        .div_stall(div_stall)
    );

    fpu fpu_instance (
        .in1(alu_fpu_in1),
        .in2(alu_fpu_in2),
        .fpu_op(fpu_op),
        .out(fpu_out)
    );

    wire [(BUS_WIDTH - 1):0] pc_plus_4 = pc + 4;
    wire [(BUS_WIDTH - 1):0] alu_fpu_out = alu_fpu ? fpu_out: alu_out;

    // handling jal and jalr instructions
    // rd = PC + 4
    assign alu_fpu_result = jump_src ? pc_plus_4: alu_fpu_out;
endmodule