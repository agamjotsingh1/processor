module unit_decoder (
	input wire in,
	input wire en, // enable
	output wire [1:0] out
);
	assign out[0] = (~in) & en;
	assign out[1] = (in) & en;
endmodule

module decoder #(
	parameter N = 1 // number of inputs
)(
	input wire [N - 1: 0] in,
	input wire en, // enable

	output wire [(1 << N) - 1: 0] out
);
	generate
		if(N == 1) begin
			unit_decoder decoder (
				.in(in[0]), 
				.en(en),
				.out(out[1:0])
			);
		end
		else begin
			wire [(1 << (N - 1)) - 1: 0] decoder_low_out;
			wire [(1 << (N - 1)) - 1: 0] decoder_high_out;

			decoder #(.N(N - 1)) decoder_low (
				.in(in[N - 2: 0]),
				.en(~in[N - 1]),
				.out(decoder_low_out)
			);

			decoder #(.N(N - 1)) decoder_high (
				.in(in[N - 2: 0]),
				.en(in[N - 1]),
				.out(decoder_high_out)
			);

			genvar i;

			// enable checking
			for(i = 0; i < (1 << (N - 1)); i = i + 1) begin
				assign out[i] = decoder_low_out[i] & en;
				assign out[i + (1 << (N - 1))] = decoder_high_out[i] & en;
			end
		end
	endgenerate
endmodule
