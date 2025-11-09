// short for "Hazard Detection Unit"
module hdu #(
    parameter REGFILE_LEN=6
)(
    input wire clk,
    input wire rst,
    input wire [(REGFILE_LEN - 1):0] rs1_IF_ID,
    input wire [(REGFILE_LEN - 1):0] rs2_IF_ID,
    input wire [(REGFILE_LEN - 1):0] rd_ID_EX,
    input wire mem_read_ID_EX,
    input wire jump_taken_IF_ID,
    output wire load_stall,
    output wire jump_stall
);
    wire reg_eq_A = (rd_ID_EX == rs1_IF_ID);
    wire reg_eq_B = (rd_ID_EX == rs2_IF_ID);
    assign load_stall = mem_read_ID_EX & (reg_eq_A | reg_eq_B);
    assign jump_stall = jump_taken_IF_ID; // if branch then stall
endmodule