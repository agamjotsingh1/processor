`include "../shift/sl/sl.v"
`include "../adder/adder.v"
`include "../../util/mux/mux.v"

module mulsl (
	input wire [63:0] a, // input #1
	input wire [63:0] b, // input #2

	output wire [127:0] res, // 128 bit result
);
    wire [127:0][127:0] inner_sl; // inner shift left outputs
    genvar i;

	generate
		for (i = 1; i < 64; i = i + 1) begin : mediary_adders

            extended_sl mediary_sl (
                .in(inner_sl[i - 1]),
                .out(inner_sl[i])
            );

			full_adder fa (
				.a(a[i]),
				.b(sel ? (~b[i]) : b[i]),
				.cin(cinner[i]),
				.sum(res[i]),
				.cout(cinner[i + 1])
			);
		end
	endgenerate
endmodule