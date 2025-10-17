module mux_2 #(
	parameter WIDTH = 1
)(
	input wire [WIDTH - 1: 0] in1,
	input wire [WIDTH - 1: 0] in2,
	input wire sel,

	output wire [WIDTH - 1: 0] out
);
	assign out = (sel == 1'b0) ? in1 : in2;
endmodule
