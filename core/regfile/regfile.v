module regfile (
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
	input wire [63:0] write_data  // data
);
	// first 32 registers are x0, x1, x2 ... x31
	// next 32 registers are f0, f1, f2 ... f31
	reg [63:0] reg_array [63:0];

	
	always @(posedge clk) begin
		if(write_enable & write_addr != 0) begin
			reg_array[write_addr] <= write_data;
		end
	end

	assign read_data1 = (read_addr1 == 0) ? 64'b0 : reg_array[read_addr1];
	assign read_data2 = (read_addr2 == 0) ? 64'b0 : reg_array[read_addr2];
endmodule
