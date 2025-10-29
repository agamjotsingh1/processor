// DATA MEM is split into 8 sepereate interleaved memory units
// All of these 8 units will be written/read in parallel
// This is to support all store and load variants

module data_mem_unit (
    input wire clk,
    input wire en,
    input wire wea,
    input wire [63:0] addr,

    input wire [63:0] din,

    /* bit_width
       00 -> 8 bits (byte)
       01 -> 16 bits (half word)
       10 -> 32 bits (word)
       11 -> 64 bits (double word)
    */
    input wire bit_width,

    output wire [63:0] dout
);
    // short for "write enables"
    wire weas [0:7]; // enables for all 8 seperate data memory instances

    genvar i;
    generate
        for(i = 0; i < 8; i++) begin
            data_mem data_mem_sub_unit (
                .clka(clk),
                .ena(en),
                .wea(weas[i]),
                .addra(addr[16:0]),
                .dina(din[(8*(i + 1) - 1):8*i]),
                .dout(dout[(8*(i + 1) - 1):8*i])
            );
        end
    endgenerate

endmodule