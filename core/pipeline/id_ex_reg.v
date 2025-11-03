module id_ex_reg #(
    parameter BUS_WIDTH=64,
    parameter INSTR_WIDTH=32,
    parameter REGFILE_LEN=6,
    parameter ALU_CONTROL_WIDTH=2,
    parameter ALU_SELECT_WIDTH=3,
    parameter FPU_OP_WIDTH=3,
    parameter BRANCH_SRC_WIDTH=3
)(
    input wire clk,

    // ------ INPUTS ------

    // Control Pins
    input wire in_reg_write, 
    input wire in_mem_write,
    input wire in_mem_read,
    input wire in_mem_to_reg,
    input wire in_jump_src,
    input wire in_jalr_src,
    input wire in_u_src,
    input wire in_uj_src,
    input wire in_alu_src,
    input wire in_alu_fpu,
    input wire in_fpu_rd,
    input wire [2:0] in_branch_src,

    // REGFILE Outputs
    input wire [(BUS_WIDTH - 1):0] in_read_data1,
    input wire [(BUS_WIDTH - 1):0] in_read_data2,
    input wire [(REGFILE_LEN - 1):0] in_rd,

    // ALU Controls
    input wire [(ALU_CONTROL_WIDTH - 1):0] in_control,
    input wire [(ALU_SELECT_WIDTH - 1):0] in_select,

    // FPU Controls
    input wire in_fpu_rd,
    input wire [(FPU_OP_WIDTH - 1):0] in_fpu_op,

    // IMMGEN output
    input wire [(BUS_WIDTH - 1):0] in_imm

    input wire [(BUS_WIDTH - 1):0] in_pc,

    // ------ OUTPUTS ------

    // Control Pouts
    output wire out_reg_write, 
    output wire out_mem_write,
    output wire out_mem_read,
    output wire out_mem_to_reg,
    output wire out_jump_src,
    output wire out_jalr_src,
    output wire out_u_src,
    output wire out_uj_src,
    output wire out_alu_src,
    output wire out_alu_fpu,
    output wire out_fpu_rd,
    output wire [2:0] out_branch_src,

    // REGFILE Outputs
    output wire [(BUS_WIDTH - 1):0] out_read_data1,
    output wire [(BUS_WIDTH - 1):0] out_read_data2,
    output wire [(REGFILE_LEN - 1):0] out_rd,

    // ALU Controls
    output wire [(ALU_CONTROL_WIDTH - 1):0] out_control,
    output wire [(ALU_SELECT_WIDTH - 1):0] out_select,

    // FPU Controls
    output wire out_fpu_rd,
    output wire [(FPU_OP_WIDTH - 1):0] out_fpu_op,

    // IMMGEN output
    output wire [(BUS_WIDTH - 1):0] out_imm

    output wire [(BUS_WIDTH - 1):0] out_pc,

);

    // Control Pins
    reg reg_write; 
    reg mem_write;
    reg mem_read;
    reg mem_to_reg;
    reg jump_src;
    reg jalr_src;
    reg u_src;
    reg uj_src;
    reg alu_src;
    reg alu_fpu;
    reg fpu_rd;
    reg [2:0] branch_src;

    // REGFILE Outputs
    reg [(BUS_WIDTH - 1):0] read_data1;
    reg [(BUS_WIDTH - 1):0] read_data2;
    reg [(REGFILE_LEN - 1):0] rd;

    // ALU Controls
    reg [(ALU_CONTROL_WIDTH - 1):0] control;
    reg [(ALU_SELECT_WIDTH - 1):0] select;

    // FPU Controls
    reg fpu_rd;
    reg [(FPU_OP_WIDTH - 1):0] fpu_op;

    // IMMGEN output
    reg [(BUS_WIDTH - 1):0] imm

    reg [(BUS_WIDTH - 1):0] pc;

    always @(posedge clk) begin
        // Control Pins
        reg_write <= in_reg_write;
        mem_write <= in_mem_write;
        mem_read <= in_mem_read;
        mem_to_reg <= in_mem_to_reg;
        jump_src <= in_jump_src;
        jalr_src <= in_jalr_src;
        u_src <= in_u_src;
        uj_src <= in_uj_src;
        alu_src <= in_alu_src;
        alu_fpu <= in_alu_fpu;
        fpu_rd <= in_fpu_rd;
        branch_src <= in_branch_src;
        
        // REGFILE Outputs
        read_data1 <= in_read_data1;
        read_data2 <= in_read_data2;
        rd <= in_rd;
        
        // ALU Controls
        control <= in_control;
        select <= in_select;
        
        // FPU Controls
        fpu_op <= in_fpu_op;
        
        // IMMGEN output
        imm <= in_imm;
        
        // PC
        pc <= in_pc;
    end

    // Continuous assignments to output wires
    // Control Pins
    assign out_reg_write = reg_write;
    assign out_mem_write = mem_write;
    assign out_mem_read = mem_read;
    assign out_mem_to_reg = mem_to_reg;
    assign out_jump_src = jump_src;
    assign out_jalr_src = jalr_src;
    assign out_u_src = u_src;
    assign out_uj_src = uj_src;
    assign out_alu_src = alu_src;
    assign out_alu_fpu = alu_fpu;
    assign out_fpu_rd = fpu_rd;
    assign out_branch_src = branch_src;
    
    // REGFILE Outputs
    assign out_read_data1 = read_data1;
    assign out_read_data2 = read_data2;
    assign out_rd = rd;
    
    // ALU Controls
    assign out_control = control;
    assign out_select = select;
    
    // FPU Controls
    assign out_fpu_op = fpu_op;
    
    // IMMGEN output
    assign out_imm = imm;
    
    // PC
    assign out_pc = pc;
endmodule