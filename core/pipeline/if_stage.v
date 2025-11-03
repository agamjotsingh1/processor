module if_stage #(
    parameter BUS_WIDTH=64,
    parameter INSTR_MEM_LEN=15, // actual instr mem length = pow(2, INSTR_MEM_LEN)
    parameter INSTR_WIDTH=32
)(
    input wire clk,
    input wire rst,
    input wire stall,
    input wire imm_pc, // 1 if jump to next_imm_pc, 0 if jump to PC + 4

    // NOTE next_jmp_pc should be given in word addressable format
    input wire [(INSTR_MEM_LEN - 1):0] next_imm_pc

    output wire [(BUS_WIDTH - 1):0] pc,
    output wire [(INSTR_WIDTH - 1):0] instr
);
    reg [(BUS_WIDTH - 1):0] cur_pc;
    wire [(BUS_WIDTH - 1):0] next_pc;

    // PC + 1 (plus 1 because instr memory is word addressable)
    assign next_pc = imm_pc ? next_imm_pc: (cur_pc + 1);

    // multiply by 4 to give actual pc (in byte addressable format)
    assign pc = cur_pc << 2;

    always @(posedge clk) begin
        if(rst) cur_pc <= {INSTR_WIDTH{1'b0}};
        else if(~stall) cur_pc <= next_pc;
    end

    instr_mem_gen instr_mem (
        .clka(clk), // input, clock for Port A
        .addra(cur_pc[(INSTR_MEM_LEN - 1):0]), // input, address for Port A
        .ena(1'b1), // enable pin for Port A  
        .douta(instr) // output, data output for Port A
    );
endmodule