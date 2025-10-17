module regfile(
	input wire clk,
	input wire write_enable,

	// read port #1
	input wire [5:0] read_addr1,  // address
	output wire [63:0] read_data1, // data


	// read port #2
	input wire [5:0] read_addr2,   // address
	output wire [63:0] read_data2, // data


	// write port
	input wire [5:0] write_addr,   // address
	output wire [63:0] write_data  // data
);
	// first 32 registers are x0, x1, x2 ... x31
	// next 32 registers are f0, f1, f2 ... f31
	reg [63:0] reg_array [0:63];

	always @(posedge clk) begin
		if(write_enable) begin
			reg_array[write_addr] <= write_data;
		end
	end

	assign read_data1 = reg_array[read_addr1];
	assign read_data2 = reg_array[read_addr2];
endmodule
