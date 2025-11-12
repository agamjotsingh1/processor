module immediate_adder(
    input wire [63:0] pc,
    input wire [31:0] instruction,
    output wire [63:0] pc_plus_4,
    output wire [63:0] pc_plus_imm
);

    wire [63:0] immediate;
    assign immediate = {{51{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // B type

    assign pc_plus_4 = pc + 4;
    assign pc_plus_imm = pc + immediate;
endmodule
