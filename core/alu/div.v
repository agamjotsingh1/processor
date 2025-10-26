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
            2'b00: out = quotient_signed;      // DIV
            2'b01: out = quotient_unsigned;    // DIVU
            2'b10: out = remainder_signed;     // REM
            2'b11: out = remainder_unsigned;   // REMU
            default: out = 64'b0;
        endcase
    end

    /*
    always @(*) begin
        casez (control)
            2'b00: out = $signed(in1) / $signed(in2);
            2'b01: out = $unsigned(in1) / $unsigned(in2);
            2'b10: out = $signed(in1) % $signed(in2);
            2'b11: out = $unsigned(in1) % $unsigned(in2);
            default: out = 64'b0;
        endcase
    end
    */
endmodule