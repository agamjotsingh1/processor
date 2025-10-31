
`timescale 1ns/1ps

module decoder_tb;

  // Parameter for test
  localparam N = 3;

  // Inputs
  reg [N-1:0] in;
  reg en;

  // Outputs
  wire [(1<<N)-1:0] out;

  // Instantiate the decoder module
  decoder #(.N(N)) uut (
    .in(in),
    .en(en),
    .out(out)
  );

  // Stimulus
  initial begin
    $display("Time\t EN\t IN \t\t OUT");
    $monitor("%0t\t %b \t %b \t %b", $time, en, in, out);

    en = 0; in = 0;
    #10; // Wait 10 ns
    en = 1;

    // Test all input combinations with enable high
    repeat((1<<N)) begin
      #10;
      in = in + 1;
    end

    // Disable decoder and check output
    #10;
    en = 0; in = 0;
    #10;

    $finish; // End simulation
  end

endmodule

