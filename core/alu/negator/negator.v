module negator(
	input wire [63:0] in,
	output wire [63:0] out
);
	assign out[0] = in[0];
	wire [63:0] carry;
	assign carry[0] = ~in[0];

	genvar i;
	generate
		for(i = 1; i < 64; i = i + 1) begin
			assign out[i] = (~in[i]) ^ (carry[i - 1]);
			assign carry[i] = (~in[i]) & carry[i - 1];
		end
	endgenerate
endmodule
