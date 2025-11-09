module if_stage #(
    parameter BUS_WIDTH=64,
    parameter INSTR_MEM_LEN=15, // actual instr mem length = pow(2, INSTR_MEM_LEN)
    parameter INSTR_WIDTH=32
)(
    input wire clk,
    input wire rst,
    input wire stall,
    input wire imm_pc, // 1 if jump to next_imm_pc, 0 if jump to PC + 4
    input wire id_branch_taken,

    // NOTE next_jmp_pc should be given in word addressable format
    input wire [(BUS_WIDTH - 1):0] next_imm_pc,

    output wire [(BUS_WIDTH - 1):0] pc,
    output wire [(INSTR_WIDTH - 1):0] instr,
    output wire branch_prediction_failed
);
    reg [(BUS_WIDTH - 1):0] cur_pc;
    wire [(BUS_WIDTH - 1):0] next_pc;
    wire [(BUS_WIDTH - 1):0] next_unpredicted_pc;

    // PC + 1 (plus 1 because instr memory is word addressable)
    // assign next_pc = imm_pc ? (next_imm_pc >> 2): (cur_pc + 1);

    // multiply by 4 to give actual pc (in byte addressable format)
    assign pc = cur_pc << 2;
    assign next_unpredicted_pc = imm_pc ? (next_imm_pc): (pc + 4);

    wire branch_consecutive_stall;

    always @(posedge clk) begin
        if(rst) cur_pc <= {BUS_WIDTH{1'b0}};
        else if(~stall & ~branch_consecutive_stall) cur_pc <= next_pc >> 2;
    end

    //==============================================
    // BRANCH PREDICTION UNIT 
    //==============================================
    wire branch_prediction_failed_only;

    branch_predictor branch_predictor_instance (
        .clk(clk),
        .stall(stall),
        .rst(rst),
        .if_pc(pc),
        .if_instr(instr),
        .id_branch_taken(id_branch_taken),
        .next_unpredicted_pc(next_unpredicted_pc),
        .next_predicted_pc(next_pc),
        .branch_prediction_failed(branch_prediction_failed_only),
        .branch_consecutive_stall(branch_consecutive_stall)
    );

    assign branch_prediction_failed = branch_consecutive_stall | branch_prediction_failed_only;

    instr_mem_gen instr_mem (
        .clka(clk), // input, clock for Port A
        .addra(cur_pc[(INSTR_MEM_LEN - 1):0]), // input, address for Port A
        .ena(1'b1), // enable pin for Port A  
        .douta(instr) // output, data output for Port A
    );
endmodule