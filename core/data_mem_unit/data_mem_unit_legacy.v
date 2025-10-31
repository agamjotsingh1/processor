module data_mem_unit_legacy (
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
    // short for "write enables"
    wire [7:0] weas; // enables for all 8 seperate data memory instances

    always @(*) begin
        case ({bit_width, addr[2:0]})
            2'b00: weas = 8'b10000000; // 8 bits
            2'b01: weas = 8'b11000000; // 16 bits
            2'b10: weas = 8'b11110000; // 32 bits
            2'b11: weas = 8'b11111111; // 64 bits
            default: 
        endcase
    end

    genvar i;
    generate
        for(i = 0; i < 8; i++) begin
            data_mem data_mem_sub_unit (
                .clka(clk),
                .ena(en),
                .wea(weas[i] & wea),
                .addra(addr[16:0]),
                .dina(din[(8*(i + 1) - 1):8*i]),
                .dout(dout[(8*(i + 1) - 1):8*i])
            );
        end
    endgenerate

    always @(*) begin
        case (bit_width)
            2'b00: din[63:8] = sign_extend ? {56{din[7]}} : 56'b0;
            2'b01: din[63:16] = sign_extend ? {48{din[15]}} : 48'b0;
            2'b10: din[63:32] = sign_extend ? {32{din[31]}} : 32'b0;
            default: din[63:0] = din[63:0]; // to prevent unecessary latches
        endcase
    end
    
    // Data inputs and outputs for each memory bank
    wire [7:0] dout_banks [7:0];
    reg [7:0] din_banks [7:0];
    
    // Address offset (last 3 bits)
    wire [2:0] offset = addr[2:0];
    
    // Aligned base address (addr with last 3 bits cleared)
    wire [63:0] base_addr = {addr[63:3], 3'b000};

    // Generate write enables based on bit_width and offset
    always @(*) begin
        weas = 8'b0;
        case (bit_width)
            2'b00: begin // 8 bits (1 byte)
                weas[offset] = 1'b1;
            end
            2'b01: begin // 16 bits (2 bytes)
                weas[offset] = 1'b1;
                weas[(offset + 1)] = 1'b1;
            end
            2'b10: begin // 32 bits (4 bytes)
                weas[offset] = 1'b1;
                weas[(offset + 1) << 3] = 1'b1;
                weas[(offset + 2) << 3] = 1'b1;
                weas[(offset + 3) << 3] = 1'b1;
            end
            2'b11: begin // 64 bits (8 bytes)
                weas = 8'b11111111;
            end
        endcase
    end

    // Map input data to correct memory banks based on offset
    genvar j;
    generate
        for (j = 0; j < 8; j = j + 1) begin
            din_banks[j] = din[((offset + j) %) * 8 +: 8];
        end
    endgenerate

    // Instantiate 8 memory banks
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : mem_banks
            data_mem data_mem_sub_unit (
                .clka(clk),
                .ena(en),
                .wea(weas[i] & wea),
                .addra(base_addr[16:3]), // Use aligned address (byte addr / 8)
                .dina(din_banks[i]),
                .douta(dout_banks[i])
            );
        end
    endgenerate

    // Map output data from memory banks to output based on offset
    reg [63:0] dout_raw;
    integer k;
    always @(*) begin
        for (k = 0; k < 8; k = k + 1) begin
            dout_raw[k * 8 +: 8] = dout_banks[(offset + k) % 8];
        end
    end

endmodule