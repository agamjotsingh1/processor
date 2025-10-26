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
    always @(*) begin
        casez (control)
            2'b00: out = $signed(in1) / $signed(in2);
            2'b01: out = $unsigned(in1) / $unsigned(in2);
            2'b10: out = $signed(in1) % $signed(in2);
            2'b11: out = $unsigned(in1) % $unsigned(in2);
            default: out = 64'b0;
        endcase
    end
endmodule