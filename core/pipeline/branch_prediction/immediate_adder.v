module immediate_adder(
    input wire [63:0] pc,
    input wire [31:0] instruction,
    output wire [63:0] pc_plus_4,
    output wire [63:0] pc_plus_imm
);

wire [63:0] immediate;
assign immediate[63:13] = instruction[31] == 1'b0 ? {51{1'b0}} : {51{1'b1}};
assign immediate[12] = instruction[31];
assign immediate[11] = instruction[7];
assign immediate[10:5] = instruction[30:25];
assign immediate[4:1] = instruction[11:8];
assign immediate[0] = 1'b0;

assign pc_plus_4 = pc + 4;
assign pc_plus_imm = pc + immediate;

endmodule
