module core (
    input wire clk
);
    reg [14:0] pc;

    initial begin
        pc = {~14'b0, 1'b0};
    end

    wire stall, reg_write_stall;
    wire [14:0] next_pc;
    wire [31:0] instr;

    // perform fsm for stalling
    // fyi, memory takes 2 extra cycles to load
    pcfsm pcfsm_instance (
        .clk(clk),
        .stall(stall),
        .reg_write_stall(reg_write_stall)
    );

    always @(posedge clk) begin
        if(~stall) pc <= next_pc;
    end

    wire ena;
    assign ena = 1'b1;

    instr_mem_gen instr_mem (
        .clka(clk),       // input, clock for Port A
        .addra(pc),       // input, address for Port A
        .ena(ena),           // enable pin for Port A  
        .douta(instr)     // output, data output for Port A
    );

    // Control Pins
    wire reg_write, 
        mem_write,
        mem_read,
        mem_to_reg,
        jump_src,
        jalr_src,
        u_src,
        uj_src,
        alu_src;

    wire [2:0] branch_src;

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
        .alu_src(alu_src)
    );

    wire [5:0] rs1 = instr[19:15];
    wire [5:0] rs2 = instr[24:20];
    wire [5:0] rd = instr[11:7];

    wire [63:0] read_data1;
    wire [63:0] read_data2;

    wire [63:0] write_data;

    regfile regfile_instance (
        .clk(clk),
        .write_enable(reg_write & (~reg_write_stall)),
        .read_addr1(rs1),
        .read_addr2(rs2),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .write_addr(rd),
        .write_data(write_data)
    );

    wire [63:0] imm;

    immgen immgen_instance (
        .instr(instr),
        .imm(imm)
    );

    // ALUOp
    wire [1:0] control;
    wire [2:0] select;

    alu_control alu_control_instance (
        .instr(instr),
        .control(control),
        .select(select)
    );

    wire [63:0] alu_in1;
    wire [63:0] alu_in2;

    assign alu_in1 = read_data1;
    assign alu_in2 = alu_src ? imm: read_data2;

    // ALU flags (for branch instruction)
    wire zero, neg, negu;

    wire [63:0] alu_out;

    alu alu_instance (
        .in1(alu_in1),
        .in2(alu_in2),
        .control(control),
        .select(select),
        .zero(zero),
        .neg(neg),
        .negu(negu),
        .out(alu_out)
    );

    // for jal instructions
    // the alu output and PC + 4 is passed through mux
    wire [63:0] alu_jal_out;

    // add by 1
    // because the instruction memory is word addressable as opposed to byte addressability
    wire [14:0] pc_plus_4;
    assign pc_plus_4 = pc + 1;

    // Multiplyu pc_plus_4 by 4 because right now pc + 4 (byte addressable)
    // is actually pc + 1 (word addressable)
    // where the pc itself is in word addressable format
    assign alu_jal_out = jump_src ? pc_plus_4 << 2 : alu_out;

    wire branch;

    branch_control branch_control_instance (
        .branch_src(branch_src),
        .zero(zero),
        .neg(neg),
        .negu(negu),
        .branch(branch)
    );

    // auipc, lui, branch, jal support 
    // note that immgen block already gives out shifted by 12
    // for branch and jal, imm is shifted by just 1
    wire [63:0] pc_plus_imm;
    assign pc_plus_imm = {50'b0, pc} + imm;

    // NOTE: for the following code
    // please refer to the report for this
    // this is not understantable without glancing the datapath

    // shift by 4 / add by 1
    // because the instruction memory is word addressable as opposed to byte addressability
    wire [14:0] next_imm_pc = pc + $signed((imm >> 2));

    // alu_jal_out because the value in rs1 = PC + 4 (byte addressable)
    // to convert to word addressable we do (PC + 4)/2
    assign next_pc = jalr_src ? (alu_jal_out >> 2) : ((branch | jump_src) ? (next_imm_pc): pc_plus_4);

    assign write_data = uj_src ? (jalr_src ? (pc_plus_4 << 2) :alu_jal_out): (u_src ? pc_plus_imm: imm);
endmodule