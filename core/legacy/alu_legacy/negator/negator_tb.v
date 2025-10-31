`timescale 1ns/1ps

module tb_negator;

	reg [63:0] in;
	wire [63:0] out;
	
	// Instantiate the negator module
	negator dut (
		.in(in),
		.out(out)
	);
	
	initial begin
		// Test case 1: all zeros input
		in = 64'b0;
		#10;
		$display("Input: %h, Output: %h", in, out);
		
		// Test case 2: all ones input
		in = 64'hFFFFFFFFFFFFFFFF;
		#10;
		$display("Input: %h, Output: %h", in, out);
		
		// Test case 3: alternating bits input (1010... pattern)
		in = 64'hAAAAAAAAAAAAAAAA;
		#10;
		$display("Input: %h, Output: %h", in, out);
		
		// Test case 4: alternating bits input (0101... pattern)
		in = 64'h5555555555555555;
		#10;
		$display("Input: %h, Output: %h", in, out);
		
		// Test case 5: random pattern
		in = 64'h123456789ABCDEF0;
		#10;
		$display("Input: %h, Output: %h", in, out);
		
		$finish;
	end

endmodule

