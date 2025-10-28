module control (
    input wire [31:0] instr,

    output reg reg_write,
    output reg mem_write,
    output reg mem_read,
    output reg mem_to_reg,
    output reg jump_src,
    output reg branch_src,
    output reg jalr_src,
    output reg u_src,
    output reg uj_src,
    output reg alu_src
);
    always @(*) begin
        case (instr[6:0]) // opcode
            // R - type
            7'b0110011: begin 
                reg_write = 1;
                mem_write = 0;
                mem_read = 0;
                mem_to_reg = 0;
                jump_src = 0;
                branch_src = 0;
                jalr_src = 0;
                u_src = 0;
                uj_src = 1;
                alu_src = 0;
            end

            // I-type
            7'b0010011: begin 
                reg_write = 1;
                mem_write = 0;
                mem_read = 0;
                mem_to_reg = 0;
                jump_src = 0;
                branch_src = 0;
                jalr_src = 0;
                u_src = 0;
                uj_src = 1;
                alu_src = 1;
            end


            // I - type (load)
            7'b0000011: begin 
                reg_write = 1;
                mem_write = 0;
                mem_read = 1;
                mem_to_reg = 1;
                jump_src = 0;
                branch_src = 0;
                jalr_src = 0;
                u_src = 0;
                uj_src = 1;
                alu_src = 1;
            end

            // I - type (jalr)
            7'b0000011: begin 
                reg_write = 1;
                mem_write = 0;
                mem_read = 0;
                mem_to_reg = 0;
                jump_src = 0;
                branch_src = 0;
                jalr_src = 1;
                u_src = 0;
                uj_src = 1;
                alu_src = 1;
            end

            // S - type
            7'b0100011: begin 
                reg_write = 0;
                mem_write = 1;
                mem_read = 0;
                mem_to_reg = 0;
                jump_src = 0;
                branch_src = 0;
                jalr_src = 0;
                u_src = 0;
                uj_src = 1;
                alu_src = 0;
            end

            // B - type
            7'b1100011: begin 
                reg_write = 0;
                mem_write = 0;
                mem_read = 0;
                mem_to_reg = 0;
                jump_src = 0;
                branch_src = 1;
                jalr_src = 0;
                u_src = 0;
                uj_src = 1;
                alu_src = 0;
            end

            // U-type (lui)
            7'b0110111: begin 
                reg_write = 1;
                mem_write = 0;
                mem_read = 0;
                mem_to_reg = 0;
                jump_src = 0;
                branch_src = 0;
                jalr_src = 0;
                u_src = 0;
                uj_src = 0;
                alu_src = 0;
            end

            // U-type (auipc)
            7'b0010111: begin 
                reg_write = 1;
                mem_write = 0;
                mem_read = 0;
                mem_to_reg = 0;
                jump_src = 0;
                branch_src = 0;
                jalr_src = 0;
                u_src = 1;
                uj_src = 0;
                alu_src = 0;
            end

            // J-type
            7'b1101111: begin 
                reg_write = 1;
                mem_write = 0;
                mem_read = 0;
                mem_to_reg = 0;
                jump_src = 1;
                branch_src = 1;
                jalr_src = 0;
                u_src = 0;
                uj_src = 1;
                alu_src = 0;
            end

            default: begin 
                reg_write = 0;
                mem_write = 0;
                mem_read = 0;
                mem_to_reg = 0;
                jump_src = 0;
                branch_src = 0;
                jalr_src = 0;
                u_src = 0;
                uj_src = 0;
                alu_src = 0;
            end

        endcase
    end
endmodule