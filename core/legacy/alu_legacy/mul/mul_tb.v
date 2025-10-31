`timescale 1ns / 1ps

module tb_mul;
	// Inputs
	reg [63:0] a;
	reg [63:0] b;
	reg sign;

	// Output
	wire [127:0] res;

	// Instantiate the DUT
	mul dut (
		.a(a),
		.b(b),
		.sign(sign),
		.res(res)
	);

	// Reference models for comparison
	reg signed [63:0] a_signed;
	reg signed [63:0] b_signed;
	reg signed [127:0] expected;

	integer i;

	initial begin
		$display("Starting mul testbench");

		// Test unsigned multiplication
		sign = 0;
		for (i = 0; i < 10; i = i + 1) begin
			a = {$random, $random};
			b = {$random, $random};

			expected = a * b;

			#5;
			if (res !== expected) begin
				$display("Mismatch (unsigned): a=%h b=%h expected=%h got=%h", a, b, expected, res);
			end
			else begin
				$display("PASS (unsigned): a=%h b=%h res=%h", a, b, res);
			end
		end

		// Test signed multiplication
		sign = 1;
		for (i = 0; i < 10; i = i + 1) begin
			a_signed = {$random, $random};
			b_signed = {$random, $random};

			a = a_signed;
			b = b_signed;

			expected = a_signed * b_signed;

			#5;
			if (res !== expected) begin
				$display("Mismatch (signed): a=%d b=%d expected=%d got=%d", a_signed, b_signed, expected, res);
			end
			else begin
				$display("PASS (signed): a=%d b=%d res=%d", a_signed, b_signed, res);
			end
		end

		$display("Testing complete.");

		$finish;
	end
endmodule
