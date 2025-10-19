module mux (
	input wire [63:0] in1,
	input wire [63:0] in2,
	input wire sel,

	output wire [63:0] out
);
	assign out = sel ? in1 : in2;
endmodule
