module core (
    input wire clk,
    input wire rst,
    output reg [63:0] debug
);
    reg [14:0] pc;

    // WILL BE REMOVED IN SYNTHESIS
    initial begin
        pc = {~14'b0, 1'b0};
    end

    wire stall, reg_write_stall, mem_stall;
    wire [14:0] next_pc;
    wire [31:0] instr;

    // perform fsm for stalling
    // fyi, memory takes 2 extra cycles to load

    // DEBUG
    //wire div_en;
    
    pcfsm pcfsm_instance (
        .clk(clk),
        .stall(stall),
        .rst(rst),

        // DEBUG
        //.div_en(div_en),
        .reg_write_stall(reg_write_stall),
        .mem_stall(mem_stall)
    );

    // stalls for memory read and write
    always @(posedge clk) begin
        if(rst) pc <= {~14'b0, 1'b0};
        else if(~stall) pc <= next_pc;
        
        debug <= next_pc;
    end
    
    instr_mem_gen instr_mem (
        .clka(clk),       // input, clock for Port A
        .addra(pc),       // input, address for Port A
        .ena(1'b1),        // enable pin for Port A  
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
        alu_src,
        alu_fpu;

    wire fpu_rs1, fpu_rd;

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
        .alu_src(alu_src),
        .alu_fpu(alu_fpu)
    );

    wire [5:0] rs1 = {alu_fpu & fpu_rs1, instr[19:15]};
    wire [5:0] rs2 = {alu_fpu, instr[24:20]};
    wire [5:0] rd = {alu_fpu & fpu_rd, instr[11:7]};

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

    wire [63:0] alu_fpu_in1;
    wire [63:0] alu_fpu_in2;

    assign alu_fpu_in1 = read_data1;
    assign alu_fpu_in2 = alu_src ? imm: read_data2;

    // ALU flags (for branch instruction)
    wire zero, neg, negu;

    wire [63:0] alu_out;
    
    alu alu_instance (
        .in1(alu_fpu_in1),
        .in2(alu_fpu_in2),

        // DEBUG
        //.clk(clk),
        //.div_en(div_en),

        .control(control),
        .select(select),
        .zero(zero),
        .neg(neg),
        .negu(negu),
        .out(alu_out)
    );

    // FPU
    wire [2:0] fpu_op;
    wire [63:0] fpu_out;
    
    /*fpu_cntrl fpu_cntrl_instance (
        .instr(instr),
        .fpu_op(fpu_op)
    );
    
    fpu fpu_instance (
        .in1(alu_fpu_in1),
        .in2(alu_fpu_in2),
        .fpu_rd(fpu_rd),
        .fpu_rs1(fpu_rs1),
        .fpu_op(fpu_op),
        .out(fpu_out)
    );*/

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

    // DATA MEM is split into 8 sepereate interleaved memory units
    // All of these 8 units will be written/read in parallel
    // This is to support all store and load variants
    // W/ Parallel 2 cycle clock delay
    wire mem_en, mem_wea, mem_sign_extend;
    wire [1:0] mem_bit_width;
    wire [63:0] mem_out;

    data_mem_control data_mem_control_instance (
        .funct3(instr[14:12]),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_stall(mem_stall),
        .en(mem_en),
        .wea(mem_wea),
        .sign_extend(mem_sign_extend),
        .bit_width(mem_bit_width)
    );

    data_mem_unit data_mem_instance (
        .clk(clk),
        .en(mem_en),
        .wea(mem_wea),
        .addr(alu_jal_out),
        .din(read_data2),
        .sign_extend(mem_sign_extend),
        .bit_width(mem_bit_width),
        .dout(mem_out)
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

    wire [63:0] write_data; // for clarity

    assign write_data = alu_fpu ? fpu_out
                        :(mem_read ? mem_out
                        :(uj_src ? (jalr_src ? (pc_plus_4 << 2) :alu_jal_out)
                        :(u_src ? pc_plus_imm: imm)));
endmodule