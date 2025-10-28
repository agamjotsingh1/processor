module core (
    input wire clk
);
    reg [14:0] pc;

    initial begin
        pc = 15'b0;
    end

    wire stall;
    wire [31:0] instr;

    pcfsm pcfsm_instance (
        .clk(clk),
        .stall(stall)
    );

    always @(posedge clk) begin
        if(~stall) pc <= pc + 1;
    end

    instr_mem_gen instr_mem (
        .clka(clk),       // input, clock for Port A
        .addra(pc),     // input, address for Port A
        .douta(instr)      // output, data output for Port A
    );

    // Control Pins
    wire reg_write, 
        mem_write,
        mem_read,
        mem_to_reg,
        jump_src,
        branch_src,
        jalr_src,
        u_src,
        uj_src,
        alu_src;

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
        .write_enable(reg_write),
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

    assign write_data = uj_src ? alu_out: imm;
endmodule