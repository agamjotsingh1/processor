module addsub (
    input wire [63:0] in1,
    input wire [63:0] in2,

    /*
       00 -> add
       01 -> sub
       10 -> slt (set less than)
       11 -> sltu (set less than)
    */
    input wire [1:0] control,

    output reg cout, // carry out
    output reg [63:0] out
);
    reg [64:0] full_out; // include 65 bit output to compute cout

    always @(*) begin
        casez (control)
            2'b00: begin 
                full_out = in1 + in2;
                out = full_out[63:0];
                cout = full_out[64];
            end
            2'b01: begin 
                full_out = in1 - in2;
                out = full_out[63:0];
                cout = full_out[64];
            end
            2'b10: begin
                if($signed(in1) < $signed(in2)) out = 64'b1;
                else out = 64'b0;
                cout = 1'b0;
            end
            2'b11: begin
                if($unsigned(in1) < $unsigned(in2)) out = 64'b1;
                else out = 64'b0;
                cout = 1'b0;
            end
            default: begin
                out = full_out[63:0];
                cout = full_out[64];
            end
        endcase
    end
endmodule