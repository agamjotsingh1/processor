// DATA MEM is split into 8 sepereate interleaved memory units
// All of these 8 units will be written/read in parallel
// This is to support all store and load variants

// 16 bits are used because of the memory size currently
// TODO: parameterize this code to make it dynamic to memory size

module data_mem_unit (
    input wire clk,
    input wire en,
    input wire wea, // write enable
    input wire [63:0] addr, // only last 16 bits will be used
    input wire [63:0] din,
    input wire sign_extend, // 1 if sign has to be extended (signed)

    /* bit_width
       00 -> 8 bits (byte)
       01 -> 16 bits (half word)
       10 -> 32 bits (word)
       11 -> 64 bits (double word)
    */
    input wire [1:0] bit_width,

    output wire [63:0] dout
);
    wire [2:0] offset = addr[2:0];
    wire [63:0] base_addr = {addr[63:3], 3'b000};
    
    // Data banks
    wire [7:0] dout_banks [7:0];
    wire [7:0] din_banks [7:0];
    
    // Write enables
    wire [7:0] weas;
    
    // Rotated input data based on offset (barrel shifter)
    wire [63:0] din_rotated [7:0];
    
    genvar i, j;
    
    // Generate rotated versions of input data for each possible offset
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_din_rotate
            for (j = 0; j < 8; j = j + 1) begin : gen_din_bytes
                assign din_rotated[i][(j << 3) +: 8] = din[((i + j) & 3'b111) << 3 +: 8];
            end
        end
    endgenerate
    
    // Select the correct rotated data based on offset
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_din_mux
            assign din_banks[i] = din_rotated[offset][(i << 3) +: 8];
        end
    endgenerate
    
    // Generate write enables based on bit_width and offset
    wire [7:0] weas_mask [7:0][3:0]; // [offset][bit_width]
    
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_weas_offset
            // byte (bit_width = 00)
            assign weas_mask[i][0] = (8'b1 << i);
            
            // half word (bit_width = 01) - 2 bytes
            assign weas_mask[i][1] = (8'b11 << i) | ((i > 6) ? (8'b11 >> (8 - i)) : 8'b0);
            
            // word (bit_width = 10) - 4 bytes
            assign weas_mask[i][2] = (8'b1111 << i) | ((i > 4) ? (8'b1111 >> (8 - i)) : 8'b0);
            
            // double word (bit_width = 11) - 8 bytes
            assign weas_mask[i][3] = 8'b11111111;
        end
    endgenerate
    
    assign weas = weas_mask[offset][bit_width];
    
    // Instantiate 8 memory banks
    generate
        for (i = 0; i < 8; i = i + 1) begin : mem_banks
            data_mem data_mem_sub_unit (
                .clka(clk),
                .ena(en),
                .wea(weas[i] & wea),
                .addra(base_addr[16:3]),
                .dina(din_banks[i]),
                .douta(dout_banks[i])
            );
        end
    endgenerate
    
    // Rotated output data based on offset (barrel shifter)
    wire [63:0] dout_rotated [7:0];
    
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_dout_rotate
            for (j = 0; j < 8; j = j + 1) begin : gen_dout_bytes
                assign dout_rotated[i][j*8 +: 8] = dout_banks[((i + j) & 3'b111)];
            end
        end
    endgenerate
    
    // Select the correct rotated output based on offset
    wire [63:0] dout_raw;
    
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_dout_mux
            assign dout_raw[i*8 +: 8] = dout_rotated[offset][i*8 +: 8];
        end
    endgenerate
    
    // Sign extension using conditional operators
    assign dout = (bit_width == 2'b00) ? (sign_extend ? {{56{dout_raw[7]}}, dout_raw[7:0]} : {56'b0, dout_raw[7:0]}) :
                  (bit_width == 2'b01) ? (sign_extend ? {{48{dout_raw[15]}}, dout_raw[15:0]} : {48'b0, dout_raw[15:0]}) :
                  (bit_width == 2'b10) ? (sign_extend ? {{32{dout_raw[31]}}, dout_raw[31:0]} : {32'b0, dout_raw[31:0]}) :
                  dout_raw;

endmodule