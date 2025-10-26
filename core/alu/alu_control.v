module alu_control (
    input wire [2:0] funct3,
    input wire [6:0] funct7,

    output reg [1:0] control,
    output reg [2:0] select
);
    always @(*) begin
        case ({funct3, funct7})
            // add
            10'b000_0000000: begin
                select = 3'b000;
                control = 2'b00;
            end

            // sub 
            10'b000_0100000: begin
                select = 3'b000;
                control = 2'b01;
            end

            // slt
            10'b010_0000000: begin
                select = 3'b000;
                control = 2'b10;
            end

            // sltu
            10'b010_0000000: begin
                select = 3'b000;
                control = 2'b10;
            end

            // mul
            10'b000_0000001: begin
                select = 3'b001;
                control = 2'b00;
            end

            // mulh
            10'b001_0000001: begin
                select = 3'b001;
                control = 2'b01;
            end

            // mulhsu
            10'b010_0000001: begin
                select = 3'b001;
                control = 2'b10;
            end

            // mulhu
            10'b011_0000001: begin
                select = 3'b001;
                control = 2'b11;
            end

            // div 
            10'b100_0000001: begin
                select = 3'b010;
                control = 2'b00;
            end

            // divu
            10'b101_0000001: begin
                select = 3'b010;
                control = 2'b01;
            end

            // rem
            10'b110_0000001: begin
                select = 3'b010;
                control = 2'b10;
            end

            // remu
            10'b111_0000001: begin
                select = 3'b010;
                control = 2'b11;
            end

            // sll
            10'b001_0000000: begin
                select = 3'b011;
                control = 2'b00; // not needed
            end

            // srl
            10'b101_0000000: begin
                select = 3'b100;
                control = 2'b00; // only first bit used
            end

            // sra
            10'b101_0100000: begin
                select = 3'b100;
                control = 2'b01; // only first bit used
            end

            // xor
            10'b101_0000000: begin
                select = 3'b101;
                control = 2'b00; // not needed
            end

            // or
            10'b110_0000000: begin
                select = 3'b110;
                control = 2'b00; // not needed
            end

            // and
            10'b111_0000000: begin
                select = 3'b111;
                control = 2'b00; // not needed
            end

            default: begin
                select = 3'b000;
                control = 2'b00;
            end
        endcase
    end
endmodule