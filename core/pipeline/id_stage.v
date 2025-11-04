module id_stage #(
    parameter BUS_WIDTH=64,
    parameter INSTR_WIDTH=32,
    parameter REGFILE_LEN=6,
    parameter ALU_CONTROL_WIDTH=2,
    parameter ALU_SELECT_WIDTH=3,
    parameter FPU_OP_WIDTH=5,
    parameter BRANCH_SRC_WIDTH=3
)(
    input wire clk,
    input wire [(BUS_WIDTH - 1):0] pc,
    input wire [(INSTR_WIDTH - 1):0] instr,

    // from WB stage
    input wire [(REGFILE_LEN - 1):0] wb_rd,
    input wire [(BUS_WIDTH - 1):0] wb_write_data,
    input wire wb_reg_write,

    // Control Pins
    output wire reg_write, 
    output wire mem_write,
    output wire mem_read,
    output wire mem_to_reg,
    output wire jump_src,
    output wire jalr_src,
    output wire u_src,
    output wire uj_src,
    output wire alu_src,
    output wire alu_fpu,

    // REGFILE Outputs
    output wire [(BUS_WIDTH - 1):0] read_data1,
    output wire [(BUS_WIDTH - 1):0] read_data2,
    output wire [(REGFILE_LEN - 1):0] rs1,
    output wire [(REGFILE_LEN - 1):0] rs2,
    output wire [(REGFILE_LEN - 1):0] rd,

    // ALU Controls
    output wire [(ALU_CONTROL_WIDTH - 1):0] control,
    output wire [(ALU_SELECT_WIDTH - 1):0] select,

    // FPU Controls
    output wire fpu_rd,
    output wire [(FPU_OP_WIDTH - 1):0] fpu_op,

    // IMMGEN output
    output wire [(BUS_WIDTH - 1):0] imm,

    // NEXT IMM PC (wont go to next stage)
    output wire imm_pc,
    output wire [(BUS_WIDTH - 1):0] next_imm_pc
);
    wire [(BRANCH_SRC_WIDTH -1):0] branch_src;

    control control_instance (
        .instr(instr),
        .reg_write(reg_write), 
        .mem_write(mem_write),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .jump_src(jump_src),
        .branch_src(branch_src),
        .jalr_src(jalr_src),
        .u_src(u_src),
        .uj_src(uj_src),
        .alu_src(alu_src),
        .alu_fpu(alu_fpu)
    );

    alu_control alu_control_instance (
        .instr(instr),
        .control(control),
        .select(select)
    );

    wire fpu_rs1, fpu_rs2;

    fpu_cntrl fpu_cntrl_instance (
        .instr(instr),
        .fpu_rs1(fpu_rs1),
        .fpu_rd(fpu_rd),
        .fpu_op(fpu_op)
    );

    assign fpu_rs2 = 1'b1; // second register is always fp (if alu_fp == 1)

    assign rs1 = {alu_fpu & fpu_rs1, instr[19:15]};
    assign rs2 = {alu_fpu & fpu_rs2, instr[24:20]};
    assign rd = {alu_fpu & fpu_rd, instr[11:7]};

    regfile regfile_instance (
        .clk(clk),
        .write_enable(wb_reg_write),
        .read_addr1(rs1),
        .read_addr2(rs2),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .write_addr(wb_rd),
        .write_data(wb_write_data)
    );
    
    immgen immgen_instance (
        .instr(instr),
        .imm(imm)
    );

    // BRANCH Flags
    wire zero, neg, negu;

    comparator comparator_instance (
        .in1(read_data1),
        .in2(read_data2),
        .zero(zero),
        .neg(neg),
        .negu(negu)
    );

    // To branch or not to branch, that is the question
    wire branch;

    branch_control branch_control_instance (
        .branch_src(branch_src),
        .zero(zero),
        .neg(neg),
        .negu(negu),
        .branch(branch)
    );

    assign imm_pc = branch | jump_src;

    localparam ADD_CNTRL = 2'b00;

    addsub addsub_jal_instance (
        .in1(jalr_src ? read_data1: pc),
        .in2(imm),
        .control(ADD_CNTRL),
        .out(next_jmp_pc)
    );
endmodule