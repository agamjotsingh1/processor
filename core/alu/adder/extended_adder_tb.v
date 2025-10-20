`timescale 1ns/1ps

module tb_extended_adder;
	// Test signals
	reg [127:0] a;
	reg [127:0] b;
	wire [127:0] sum;
	
	// Reference result (256-bit to capture overflow)
	reg [255:0] expected_sum;
	reg [127:0] expected_truncated;
	
	// DUT instantiation
	extended_adder dut (
		.a(a),
		.b(b),
		.sum(sum)
	);
	
	integer i;
	integer pass_count;
	integer fail_count;
	
	initial begin
		$display("=================================================");
		$display("Starting extended_adder testbench");
		$display("=================================================");
		
		pass_count = 0;
		fail_count = 0;
		
		// Test Case 1: Zero + Zero
		a = 128'h0;
		b = 128'h0;
		#10;
		expected_sum = a + b;
		expected_truncated = expected_sum[127:0];
		check_result("Zero + Zero");
		
		// Test Case 2: Max value + 0
		a = {128{1'b1}};  // All ones - corrected
		b = 128'h0;
		#10;
		expected_sum = a + b;
		expected_truncated = expected_sum[127:0];
		check_result("Max + Zero");
		
		// Test Case 3: Max value + 1 (overflow case)
		a = {128{1'b1}};  // All ones - corrected
		b = 128'h1;
		#10;
		expected_sum = a + b;
		expected_truncated = expected_sum[127:0];
		check_result("Max + 1 (overflow)");
		
		// Test Case 4: Simple addition
		a = 128'h123456789ABCDEF0123456789ABCDEF0;
		b = 128'hFEDCBA9876543210FEDCBA9876543210;
		#10;
		expected_sum = a + b;
		expected_truncated = expected_sum[127:0];
		check_result("Simple addition");
		
		// Test Case 5: Adding 1 to each bit position
		a = 128'h1;
		b = 128'h1;
		#10;
		expected_sum = a + b;
		expected_truncated = expected_sum[127:0];
		check_result("1 + 1");
		
		// Test Case 6: Carry propagation test
		a = 128'h00000000000000000000000FFFFFFFF;
		b = 128'h00000000000000000000000000000001;
		#10;
		expected_sum = a + b;
		expected_truncated = expected_sum[127:0];
		check_result("Carry propagation");
		
		// Test Case 7: All ones in lower half + All ones in upper half
		a = 128'hFFFFFFFFFFFFFFFF0000000000000000;
		b = 128'h0000000000000000FFFFFFFFFFFFFFFF;
		#10;
		expected_sum = a + b;
		expected_truncated = expected_sum[127:0];
		check_result("Split halves");
		
		// Random test cases
		$display("\n--- Running Random Test Cases ---");
		for (i = 0; i < 20; i = i + 1) begin
			a = {$random, $random, $random, $random};
			b = {$random, $random, $random, $random};
			#10;
			expected_sum = a + b;
			expected_truncated = expected_sum[127:0];
			// Use simple string concatenation instead of sformatf
			$write("Random test %0d: ", i+1);
			if (sum === expected_truncated) begin
				$display("PASS");
				pass_count = pass_count + 1;
			end else begin
				$display("FAIL");
				$display("       a     = 0x%h", a);
				$display("       b     = 0x%h", b);
				$display("       Expected = 0x%h", expected_truncated);
				$display("       Got      = 0x%h", sum);
				fail_count = fail_count + 1;
			end
		end
		
		// Test Case: Pattern testing with alternating bits
		a = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
		b = 128'h55555555555555555555555555555555;
		#10;
		expected_sum = a + b;
		expected_truncated = expected_sum[127:0];
		check_result("Alternating bits");
		
		// Test Case: Walking ones
		for (i = 0; i < 128; i = i + 1) begin
			a = 128'h1 << i;
			b = 128'h1 << i;
			#10;
			expected_sum = a + b;
			expected_truncated = expected_sum[127:0];
			// Use simple display instead of sformatf
			$write("Walking ones bit %0d: ", i);
			if (sum === expected_truncated) begin
				$display("PASS");
				pass_count = pass_count + 1;
			end else begin
				$display("FAIL");
				$display("       a     = 0x%h", a);
				$display("       b     = 0x%h", b);
				$display("       Expected = 0x%h", expected_truncated);
				$display("       Got      = 0x%h", sum);
				fail_count = fail_count + 1;
			end
		end
		
		// Summary
		$display("\n=================================================");
		$display("Test Summary:");
		$display("  PASSED: %0d", pass_count);
		$display("  FAILED: %0d", fail_count);
		$display("  TOTAL:  %0d", pass_count + fail_count);
		$display("=================================================");
		
		if (fail_count == 0)
			$display("*** ALL TESTS PASSED ***");
		else
			$display("*** SOME TESTS FAILED ***");
		
		$finish;
	end
	
	// Task to check results - using reg instead of input string
	task check_result;
		input [255:0] test_name;  // Fixed size declaration
		begin
			if (sum === expected_truncated) begin
				$display("[PASS] %0s", test_name);
				pass_count = pass_count + 1;
			end else begin
				$display("[FAIL] %0s", test_name);
				$display("       a     = 0x%h", a);
				$display("       b     = 0x%h", b);
				$display("       Expected = 0x%h", expected_truncated);
				$display("       Got      = 0x%h", sum);
				fail_count = fail_count + 1;
			end
		end
	endtask
	
	// Optional: Waveform dumping for GTKWave
	initial begin
		$dumpfile("extended_adder.vcd");
		$dumpvars(0, tb_extended_adder);
	end
	
endmodule

