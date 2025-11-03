// each data mem sub unit is 64 x (2^17) dimensions long
module data_mem_unit (
    input wire clk,
    input wire en,
    input wire wea, // write enable
    input wire [63:0] addr, // only last 11 bits will be used
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
    wire [2:0] col;
    assign col = addr[2:0];

    wire [60:0] row;
    assign row = addr[63:3];

    // short for "write enables"
    wire [7:0] weas;  // enables for all 8 seperate data memory instances
    reg [7:0] weas_unrotated;  // unrotated weas

    always @(*) begin
        case (bit_width)
            2'b00: weas_unrotated = 8'b00000001; // 8 bits
            2'b01: weas_unrotated = 8'b00000011; // 16 bits
            2'b10: weas_unrotated = 8'b00001111; // 32 bits
            2'b11: weas_unrotated = 8'b11111111; // 64 bits
            default: weas_unrotated = 8'b00000000;
        endcase
    end

    // circular left shift by 'col' to find actual write enables
    assign weas = (weas_unrotated << col) | (weas_unrotated >> (8 - col));

    wire [5:0] col_shift;
    assign col_shift = {3'b0, col} << 3;

    wire [5:0] reverse_col_shift;
    assign reverse_col_shift = 64 - col_shift;

    wire [63:0] din_rotated;
    // same thing for din, but with shift amount = col * 8
    assign din_rotated = (din << col_shift) | (din >> reverse_col_shift);

    // memory addresses is arranged in a matrix-ish grid
    // [0, 1, 2, 3, 4, 5, 6, 7
    //  9,10,11,12,13,14,15,16
    // .......................]

    wire [63:0] dout_raw_unrotated_z;  // May contain z instead of zero

    genvar i;
    generate
        for(i = 0; i < 8; i = i + 1) begin
            data_mem data_mem_sub_unit (
                .clka(clk),
                .ena(en),
                .wea(weas[i] & wea),
                .addra(row[11:0] + (i < col ? 17'b1: 17'b0)),
                .dina(din_rotated[(i << 3) +: 8]),
                .douta(dout_raw_unrotated_z[(i << 3) +: 8])
            );
        end
    endgenerate

    wire [63:0] dout_raw_unrotated;

    // Convert z to 0 using or with 0
    assign dout_raw_unrotated = dout_raw_unrotated_z | 64'b0;

    reg [63:0] dout_raw_rotated;

    // right circular shift for dout to get what was actually put in
    always @(*) begin
        dout_raw_rotated = (dout_raw_unrotated >> col_shift) | (dout_raw_unrotated << reverse_col_shift);

        case (bit_width)
            2'b00: dout_raw_rotated[63:8] = sign_extend ? {56{dout_raw_rotated[7]}} : 56'b0;
            2'b01: dout_raw_rotated[63:16] = sign_extend ? {48{dout_raw_rotated[15]}} : 48'b0;
            2'b10: dout_raw_rotated[63:32] = sign_extend ? {32{dout_raw_rotated[31]}} : 32'b0;
            default: dout_raw_rotated[63:0] = dout_raw_rotated[63:0]; // to prevent unecessary latches
        endcase
    end

    assign dout = dout_raw_rotated;
endmodule