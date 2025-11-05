module core #(
    parameter BUS_WIDTH=64
)(
    input wire clk,
    input wire rst,
    output reg [63:0] debug
);
    localparam INSTR_WIDTH=32;
    localparam REGFILE_LEN=6;
    localparam ALU_CONTROL_WIDTH=2;
    localparam ALU_SELECT_WIDTH=3;
    localparam FPU_OP_WIDTH=5;
    localparam BRANCH_SRC_WIDTH=3;
    localparam MEM_BIT_WIDTH=2;

    // actual instr mem length = pow(2, INSTR_MEM_LEN)
    localparam INSTR_MEM_LEN=15;

    // GLOBAL interconnects
    wire imm_pc, wb_reg_write;
    wire [(BUS_WIDTH - 1):0] next_imm_pc;
    wire [(REGFILE_LEN - 1):0] wb_rd;
    wire [(BUS_WIDTH - 1):0] wb_write_data;

    //==============================================
    // IF STAGE 
    //==============================================

    wire pc_stall;

    wire [(BUS_WIDTH - 1):0] if_pc;
    wire [(INSTR_WIDTH - 1):0] if_instr;

    if_stage #(
        .BUS_WIDTH(BUS_WIDTH),
        .INSTR_MEM_LEN(INSTR_MEM_LEN),
        .INSTR_WIDTH(INSTR_WIDTH)
    ) if_stage_instance (
        .clk(clk),
        .rst(rst),
        .stall(pc_stall),
        .imm_pc(imm_pc),
        .next_imm_pc(next_imm_pc),
        .pc(if_pc),
        .instr(if_instr)
    );


    //==============================================
    // IF ID PIPELINE REGISTER
    //==============================================

    wire if_id_stall;

    wire [(BUS_WIDTH - 1):0] id_pc;
    wire [(INSTR_WIDTH - 1):0] id_instr;

    if_id_reg #(
        .BUS_WIDTH(BUS_WIDTH),
        .INSTR_WIDTH(INSTR_WIDTH)
    ) if_id_reg_instance (
        .clk(clk),
        .rst(rst),
        .stall(if_id_stall),
        .in_pc(if_pc),
        .in_instr(if_instr),
        .out_pc(id_pc),
        .out_instr(id_instr)
    );


    //==============================================
    // ID Stage
    //==============================================

    // Control Pins
    wire id_reg_write; 
    wire id_mem_write;
    wire id_mem_read;
    wire id_mem_to_reg;
    wire id_jump_src;
    wire id_jalr_src;
    wire id_u_src;
    wire id_uj_src;
    wire id_alu_src;
    wire id_alu_fpu;

    // REGFILE Outputs
    wire [(BUS_WIDTH - 1):0] id_read_data1;
    wire [(BUS_WIDTH - 1):0] id_read_data2;
    wire [(REGFILE_LEN - 1):0] id_rs1;
    wire [(REGFILE_LEN - 1):0] id_rs2;
    wire [(REGFILE_LEN - 1):0] id_rd;

    // ALU Controls
    wire [(ALU_CONTROL_WIDTH - 1):0] id_control;
    wire [(ALU_SELECT_WIDTH - 1):0] id_select;

    // FPU Controls
    wire id_fpu_rd;
    wire [(FPU_OP_WIDTH - 1):0] id_fpu_op;

    // IMMGEN output
    wire [(BUS_WIDTH - 1):0] id_imm;

    id_stage #(
        .BUS_WIDTH(BUS_WIDTH),
        .INSTR_WIDTH(INSTR_WIDTH),
        .REGFILE_LEN(REGFILE_LEN),
        .ALU_CONTROL_WIDTH(ALU_CONTROL_WIDTH),
        .ALU_SELECT_WIDTH(ALU_SELECT_WIDTH),
        .FPU_OP_WIDTH(FPU_OP_WIDTH),
        .BRANCH_SRC_WIDTH(BRANCH_SRC_WIDTH)
    ) id_stage_instance (
        .clk(clk),
        .pc(id_pc),
        .instr(id_instr),
        .wb_rd(wb_rd),
        .wb_write_data(wb_write_data),
        .wb_reg_write(wb_reg_write),

        // CONTROL Signals
        .reg_write(id_reg_write),
        .mem_write(id_mem_write),
        .mem_read(id_mem_read),
        .mem_to_reg(id_mem_to_reg),
        .jump_src(id_jump_src),
        .jalr_src(id_jalr_src),
        .u_src(id_u_src),
        .uj_src(id_uj_src),
        .alu_src(id_alu_src),
        .alu_fpu(id_alu_fpu),

        // REGFILE Outputs
        .read_data1(id_read_data1),
        .read_data2(id_read_data2),
        .rs1(id_rs1),
        .rs2(id_rs2),
        .rd(id_rd),

        // ALU Controls
        .control(id_control),
        .select(id_select),

        // FPU Controls
        .fpu_rd(id_fpu_rd),
        .fpu_op(id_fpu_op),

        // IMMGEN output
        .imm(id_imm),

        .imm_pc(imm_pc),
        .next_imm_pc(next_imm_pc)
    );

    //==============================================
    // ID EX PIPELINE REGISTER
    //==============================================

    wire id_ex_stall;

    wire [(BUS_WIDTH - 1):0] ex_pc;
    wire [(INSTR_WIDTH - 1):0] ex_instr;

    // Control Pins
    wire ex_reg_write; 
    wire ex_mem_write;
    wire ex_mem_read;
    wire ex_mem_to_reg;
    wire ex_jump_src;
    wire ex_jalr_src;
    wire ex_u_src;
    wire ex_uj_src;
    wire ex_alu_src;
    wire ex_alu_fpu;

    // REGFILE Outputs
    wire [(BUS_WIDTH - 1):0] ex_read_data1;
    wire [(BUS_WIDTH - 1):0] ex_read_data2;
    wire [(REGFILE_LEN - 1):0] ex_rs1;
    wire [(REGFILE_LEN - 1):0] ex_rs2;
    wire [(REGFILE_LEN - 1):0] ex_rd;

    // ALU Controls
    wire [(ALU_CONTROL_WIDTH - 1):0] ex_control;
    wire [(ALU_SELECT_WIDTH - 1):0] ex_select;

    // FPU Controls
    wire [(FPU_OP_WIDTH - 1):0] ex_fpu_op;

    // IMMGEN output
    wire [(BUS_WIDTH - 1):0] ex_imm;

    id_ex_reg #(
        .BUS_WIDTH(BUS_WIDTH),
        .INSTR_WIDTH(INSTR_WIDTH),
        .REGFILE_LEN(REGFILE_LEN),
        .ALU_CONTROL_WIDTH(ALU_CONTROL_WIDTH),
        .ALU_SELECT_WIDTH(ALU_SELECT_WIDTH),
        .FPU_OP_WIDTH(FPU_OP_WIDTH)
    ) id_ex_reg_instance (
        .clk(clk),
        .rst(rst),
        .stall(id_ex_stall),
        
        // In Control Pins
        .in_reg_write(id_reg_write),
        .in_mem_write(id_mem_write),
        .in_mem_read(id_mem_read),
        .in_mem_to_reg(id_mem_to_reg),
        .in_jump_src(id_jump_src),
        .in_jalr_src(id_jalr_src),
        .in_u_src(id_u_src),
        .in_uj_src(id_uj_src),
        .in_alu_src(id_alu_src),
        .in_alu_fpu(id_alu_fpu),
        
        // In REGFILE Pins
        .in_read_data1(id_read_data1),
        .in_read_data2(id_read_data2),
        .in_rs1(id_rs1),
        .in_rs2(id_rs2),
        .in_rd(id_rd),
        
        // In ALU Pins
        .in_control(id_control),
        .in_select(id_select),

        // In FPU Pins
        .in_fpu_op(id_fpu_op),

        .in_imm(id_imm),
        .in_pc(id_pc),
        .in_instr(id_instr),

        // Out Control Pins
        .out_reg_write(ex_reg_write),
        .out_mem_write(ex_mem_write),
        .out_mem_read(ex_mem_read),
        .out_mem_to_reg(ex_mem_to_reg),
        .out_jump_src(ex_jump_src),
        .out_jalr_src(ex_jalr_src),
        .out_u_src(ex_u_src),
        .out_uj_src(ex_uj_src),
        .out_alu_src(ex_alu_src),
        .out_alu_fpu(ex_alu_fpu),

        // Out REGFILE Pins
        .out_read_data1(ex_read_data1),
        .out_read_data2(ex_read_data2),
        .out_rs1(ex_rs1),
        .out_rs2(ex_rs2),
        .out_rd(ex_rd),
        
        // Out ALU Pins
        .out_control(ex_control),
        .out_select(ex_select),

        // Out FPU Pins
        .out_fpu_op(ex_fpu_op),

        .out_imm(ex_imm),
        .out_pc(ex_pc),
        .out_instr(ex_instr)
    );

    //==============================================
    // EX Stage
    //==============================================
    wire [(BUS_WIDTH - 1):0] ex_alu_fpu_result;

    ex_stage #(
        .BUS_WIDTH(BUS_WIDTH),
        .ALU_CONTROL_WIDTH(ALU_CONTROL_WIDTH),
        .ALU_SELECT_WIDTH(ALU_SELECT_WIDTH),
        .FPU_OP_WIDTH(FPU_OP_WIDTH)
    ) ex_stage_instance (
        .alu_src(ex_alu_src),
        .alu_fpu(ex_alu_fpu),
        .jump_src(ex_jump_src),
        
        .read_data1(ex_read_data1),
        .read_data2(ex_read_data2),
        
        .control(ex_control),
        .select(ex_select),
        
        .fpu_op(ex_fpu_op),
        
        .imm(ex_imm),
        .pc(ex_pc),
        
        .alu_fpu_result(ex_alu_fpu_result)
    );

    //==============================================
    // EX MEM PIPELINE REGISTER
    //==============================================

    wire ex_mem_stall;

    // Control Pins
    wire mem_reg_write;
    wire mem_mem_write;
    wire mem_mem_read;
    wire mem_mem_to_reg;
    wire mem_jalr_src;
    wire mem_u_src;
    wire mem_uj_src;

    // REGFILE Outputs
    wire [(REGFILE_LEN - 1):0] mem_rs1;
    wire [(REGFILE_LEN - 1):0] mem_rs2;
    wire [(REGFILE_LEN - 1):0] mem_rd;

    // IMMGEN and ALU Results
    wire [(BUS_WIDTH - 1):0] mem_imm;

    wire [(BUS_WIDTH - 1):0] mem_pc;
    wire [(INSTR_WIDTH - 1):0] mem_instr;
    wire [(BUS_WIDTH - 1):0] mem_alu_fpu_result;

    // pretty trippy but bare with me
    // first "mem" indicates stage, next "mem_in" is the variable name
    wire [(BUS_WIDTH - 1):0] mem_mem_in;

    ex_mem_reg #(
        .BUS_WIDTH(BUS_WIDTH),
        .INSTR_WIDTH(INSTR_WIDTH),
        .REGFILE_LEN(REGFILE_LEN)
    ) ex_mem_reg_instance (
        .clk(clk),
        .rst(rst),
        .stall(ex_mem_stall),
        
        .in_reg_write(ex_reg_write),
        .in_mem_write(ex_mem_write),
        .in_mem_read(ex_mem_read),
        .in_mem_to_reg(ex_mem_to_reg),
        .in_jalr_src(ex_jalr_src),
        .in_u_src(ex_u_src),
        .in_uj_src(ex_uj_src),
        
        .in_rs1(ex_rs1),
        .in_rs2(ex_rs2),
        .in_rd(ex_rd),
        
        .in_imm(ex_imm),
        .in_pc(ex_pc),
        .in_instr(ex_instr),
        .in_alu_fpu_result(ex_alu_fpu_result),
        .in_mem_in(ex_read_data2),
        
        .out_reg_write(mem_reg_write),
        .out_mem_write(mem_mem_write),
        .out_mem_read(mem_mem_read),
        .out_mem_to_reg(mem_mem_to_reg),
        .out_jalr_src(mem_jalr_src),
        .out_u_src(mem_u_src),
        .out_uj_src(mem_uj_src),
        
        .out_rs1(mem_rs1),
        .out_rs2(mem_rs2),
        .out_rd(mem_rd),
        
        .out_imm(mem_imm),
        .out_pc(mem_pc),
        .out_instr(mem_instr),
        .out_alu_fpu_result(mem_alu_fpu_result),
        .out_mem_in(mem_mem_in)
    );

    //==============================================
    // MEM STAGE
    //==============================================

    wire [(BUS_WIDTH - 1):0] mem_mem_out;
    wire [(BUS_WIDTH - 1):0] mem_write_data;

    mem_stage #(
        .BUS_WIDTH(BUS_WIDTH),
        .INSTR_WIDTH(INSTR_WIDTH),
        .MEM_BIT_WIDTH(MEM_BIT_WIDTH)
    ) mem_stage_instance (
        .clk(clk),
        
        // Control Pins
        .mem_write(mem_mem_write),
        .mem_read(mem_mem_read),
        .jalr_src(mem_jalr_src),
        .u_src(mem_u_src),
        .uj_src(mem_uj_src),
        
        // Data Inputs
        .imm(mem_imm),
        .pc(mem_pc),
        .alu_fpu_result(mem_alu_fpu_result),
        .mem_in(mem_mem_in),
        .instr(mem_instr),
        
        // Data Outputs
        .mem_out(mem_mem_out),
        .write_data(mem_write_data)
    );

    //==============================================
    // MEM WB PIPELINE REGISTER
    //==============================================

    wire mem_wb_stall;

    wire wb_mem_to_reg;
    wire [(BUS_WIDTH - 1):0] wb_mem_out;
    wire [(BUS_WIDTH - 1):0] wb_reg_write_data;

    mem_wb_reg #(
        .BUS_WIDTH(BUS_WIDTH),
        .INSTR_WIDTH(INSTR_WIDTH),
        .REGFILE_LEN(REGFILE_LEN)
    ) mem_wb_reg_instance (
        .clk(clk),
        .rst(rst),
        .stall(mem_wb_stall),
        
        .in_reg_write(mem_reg_write),
        .in_mem_to_reg(mem_mem_to_reg),
        .in_rd(mem_rd),
        .in_mem_out(mem_mem_out),
        .in_write_data(mem_write_data),
        
        .out_reg_write(wb_reg_write),
        .out_mem_to_reg(wb_mem_to_reg),
        .out_rd(wb_rd),
        .out_mem_out(wb_mem_out),
        .out_write_data(wb_reg_write_data)
    );

    assign wb_write_data = wb_mem_to_reg ? wb_mem_out: wb_reg_write_data;

    // STALLING
    wire stall;

    stall_unit stall_unit_instance (
        .clk(clk),
        .rst(rst),
        .stall(1'b0),
        .out_stall(stall)
    );

    assign pc_stall = stall;
    assign if_id_stall = stall;
    assign id_ex_stall = stall;
    assign ex_mem_stall = stall;
    assign mem_wb_stall = stall;
endmodule