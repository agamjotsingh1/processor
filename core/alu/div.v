module div (
    input wire [63:0] in1,
    input wire [63:0] in2,

    /* 
       00 -> div (quotient) 
       01 -> divu (quotient - unsigned division) 
       10 -> rem (remainder) 
       11 -> remu (remainder - unsigned division) 
    */
    input wire [1:0] control,

    output reg [63:0] out
);
    wire [63:0] quotient_signed, quotient_unsigned;
    wire [63:0] remainder_signed, remainder_unsigned;
    
    assign quotient_signed = $signed(in1) / $signed(in2);
    assign quotient_unsigned = in1 / in2;
    
    assign remainder_signed = $signed(in1) - (quotient_signed * $signed(in2));
    assign remainder_unsigned = in1 - (quotient_unsigned * in2);
    
    always @(*) begin
        case (control)
            // div
            2'b00: begin
                if(in2 == 0) out = 64'hFFFFFFFFFFFFFFFF;
                else out = quotient_signed;
            end

            // divu
            2'b01: begin
                if(in2 == 0) out = 64'hFFFFFFFFFFFFFFFF;
                else out = quotient_unsigned;
            end

            // rem
            2'b10: begin
                if(in2 == 0) out = in1;
                else out = remainder_signed;
            end

            // remu
            2'b11: begin
                if(in2 == 0) out = in1;
                else out = remainder_unsigned;
            end
            
            default: out = 64'b0;
        endcase
    end
endmodule