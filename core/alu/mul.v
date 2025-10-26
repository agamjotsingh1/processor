module mul (
    input wire [63:0] in1,
    input wire [63:0] in2,

    /*
       00 -> mul (lower 64 bits) 
       01 -> mulh (higher 64 bits) 
       10 -> mulhsu (higher 64 bits - signed unsigned multiplication) 
       11 -> mulhu (higher 64 bits - unsigned unsigned multiplication) 
    */
    input wire [1:0] control,

    output reg [63:0] out
);
    reg [127:0] full_out; // Full 128 bit output

    always @(*) begin
        casez (control)
            2'b0z: full_out = $signed(in1) * $signed(in2);
            2'b10: full_out = $signed(in1) * $unsigned(in2);
            2'b11: full_out = $unsigned(in1) * $unsigned(in2);
            default: full_out = 64'b0;
        endcase

        if(control == 2'b00) begin
            out = full_out[63:0];
        end
        else begin
            out = full_out[127:64];
        end
    end
endmodule
