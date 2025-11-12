module predictor #(
    parameter INSTR_WIDTH=32
)(
    input wire [(INSTR_WIDTH - 1):0] instruction,
    input wire truth, // 1 means it has branched previously
    input wire clk,
    input wire reset,
    output wire next_prediction // 1 means predicting it will branch
);
    reg [4:0] incoming_sequence;
    reg [15:0] matching_sequence;

    wire enable = (instruction[6:0] == 7'b1100011);

    always @(posedge clk) begin
        if(reset) begin
            incoming_sequence <= 5'b00000;
            matching_sequence <= {16'b0};
        end
        else if(enable) begin
            incoming_sequence <= (incoming_sequence << 1) | truth;
            matching_sequence[incoming_sequence[4:1]]  <= incoming_sequence[0];
        end
    end

    assign next_prediction = enable & matching_sequence[incoming_sequence[4:1]];
endmodule
