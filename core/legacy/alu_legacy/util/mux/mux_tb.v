`timescale 1ns/1ps

module tb_mux_2;

	parameter WIDTH = 8; // Example width

	reg [WIDTH-1:0] in1;
	reg [WIDTH-1:0] in2;
	reg sel;

	wire [WIDTH-1:0] out;

	// Instantiate the mux_2 module
	mux_2 #(
		.WIDTH(WIDTH)
	) uut (
		.in1(in1),
		.in2(in2),
		.sel(sel),
		.out(out)
	);

	initial begin
		// Test vector 1
		in1 = 8'hAA;
		in2 = 8'h55;
		sel = 0;
		#10;
		$display("sel=%b in1=%h in2=%h out=%h (expected %h)", sel, in1, in2, out, in1);

		// Test vector 2
		sel = 1;
		#10;
		$display("sel=%b in1=%h in2=%h out=%h (expected %h)", sel, in1, in2, out, in2);

		// Test vector 3: change inputs
		in1 = 8'hFF;
		in2 = 8'h00;
		sel = 0;
		#10;
		$display("sel=%b in1=%h in2=%h out=%h (expected %h)", sel, in1, in2, out, in1);

		// Test vector 4
		sel = 1;
		#10;
		$display("sel=%b in1=%h in2=%h out=%h (expected %h)", sel, in1, in2, out, in2);

		$finish;
	end

endmodule

