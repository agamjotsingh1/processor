`include "addsub.v"
`include "mul.v"

module alu (
    input wire [63:0] in1,
    input wire [63:0] in2,

    input wire [2:0] funct3,
    input wire [6:0] funct7,

    output reg [63:0] out
);
    always @(*) begin
        case ({funct3, funct7})
            10'b0000000000:  
            default: 
        endcase
    end
endmodule