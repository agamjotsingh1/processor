// Full adder
module full_adder(
	input wire a, // input #1
	input wire b, // input #2
	input wire cin, // carry in
	output wire sum,
	output wire cout // carry out
);
	assign sum = a ^ b ^ cin;
	assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module adder(
	input wire [63:0] a, // input #1
	input wire [63:0] b, // input #2
	input wire cin, // carry in
	output wire [63:0] sum,
	output wire cout // carry out
);
	// inner wiring to make the to transfer carry
	output wire [64:0] cinner;
	assign cinner[0] = cin;

	genvar i;
	generate
		for (i = 0; i < 64; i = i + 1) begin : ADDERS
			full_adder FA (
				.a(a[i]),
				.b(b[i]),
				.cin(cinner[i]),
				.sum(sum[i]),
				.cout(cinner[i+1])
			);
		end
	endgenerate

	assign cout = cinner[64];
endmodule
