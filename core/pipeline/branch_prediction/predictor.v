module predictor(
    input wire [31:0] instruction,
    input wire truth, // 1 means it has branched previously
    input wire clk,
    input wire reset,
    output wire next_prediction // 1 means predicting it will branch
);

reg [4:0] incoming_sequence;
reg [15:0] matching_sequence;

wire enable;
assign enable = (instruction[6:0] == 7'b1100011);

always @(posedge clk) begin
    if(reset) begin
        incoming_sequence <= 5'b00000;
        matching_sequence <= {16'b0};
    end

    else begin
        case (enable)
            1'b1: begin
                    incoming_sequence <= (incoming_sequence << 1) | truth;
                    case (incoming_sequence[4:1])
                        4'b0000: matching_sequence[0]  <= incoming_sequence[0];
                        4'b0001: matching_sequence[1]  <= incoming_sequence[0];
                        4'b0010: matching_sequence[2]  <= incoming_sequence[0];
                        4'b0011: matching_sequence[3]  <= incoming_sequence[0];
                        4'b0100: matching_sequence[4]  <= incoming_sequence[0];
                        4'b0101: matching_sequence[5]  <= incoming_sequence[0];
                        4'b0110: matching_sequence[6]  <= incoming_sequence[0];
                        4'b0111: matching_sequence[7]  <= incoming_sequence[0];
                        4'b1000: matching_sequence[8]  <= incoming_sequence[0];
                        4'b1001: matching_sequence[9]  <= incoming_sequence[0];
                        4'b1010: matching_sequence[10] <= incoming_sequence[0];
                        4'b1011: matching_sequence[11] <= incoming_sequence[0];
                        4'b1100: matching_sequence[12] <= incoming_sequence[0];
                        4'b1101: matching_sequence[13] <= incoming_sequence[0];
                        4'b1110: matching_sequence[14] <= incoming_sequence[0];
                        default: matching_sequence[15] <= incoming_sequence[0];
                    endcase
                end
            default: incoming_sequence <= incoming_sequence;
        endcase
    end
end

reg next_prd;

always @(*) begin
    case(incoming_sequence[4:1])
        4'b0000: next_prd = matching_sequence[0];
        4'b0001: next_prd = matching_sequence[1];
        4'b0010: next_prd = matching_sequence[2];
        4'b0011: next_prd = matching_sequence[3];
        4'b0100: next_prd = matching_sequence[4];
        4'b0101: next_prd = matching_sequence[5];
        4'b0110: next_prd = matching_sequence[6];
        4'b0111: next_prd = matching_sequence[7];
        4'b1000: next_prd = matching_sequence[8];
        4'b1001: next_prd = matching_sequence[9];
        4'b1010: next_prd = matching_sequence[10];
        4'b1011: next_prd = matching_sequence[11];
        4'b1100: next_prd = matching_sequence[12];
        4'b1101: next_prd = matching_sequence[13];
        4'b1110: next_prd = matching_sequence[14];
        default: next_prd = matching_sequence[15];
    endcase
end

assign next_prediction = enable & next_prd;

endmodule
