module immgen (
    input wire [31:0] instr,

    output reg [63:0] imm
);
    always @(*) begin
        case (instr[6:0]) // opcode
            7'b0110011: imm = 64'b0; // R type
            7'b0010011, 7'b0000011: imm = {{52{instr[31]}}, instr[31:20]}; // I type
            7'b0100011: imm = {{52{instr[31]}}, instr[31:25], instr[11:7]}; // S type
            7'b1100011: imm = {{51{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // B type
            7'b0110111, 7'b0010111: imm = {{32{instr[31]}}, instr[31:12], 12'b0}; // U type
            7'b1101111: imm = {{43{instr[31]}}, instr[31], instr[20], instr[19:12], instr[30:21], 1'b0}; // J type
            default: imm = 64'b0; 
        endcase
    end
endmodule