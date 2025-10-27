module core (
    input wire clk,
    input wire [14:0] addr,
    output wire [63:0] out
);
    wire [31:0] dout;

    instr_mem_gen instr_mem (
        .clka(clk),       // input, clock for Port A
        .addra(addr),     // input, address for Port A
        .douta(dout)      // output, data output for Port A
    );

    wire [63:0] temp = {dout, dout};

    (* DONT_TOUCH = "true" *)
    alu alu_instance (
        .in1(temp),
        .in2(temp),
        .funct3(3'b0),
        .funct7(7'b0),
        .out(out)
    );

endmodule