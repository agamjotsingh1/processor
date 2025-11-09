module branch_predictor (
    input wire clk,
    input wire rst,

    // IF stage instruction
    input wire [31:0] next_instruction,

    // coming from ID stage, next branch pc
    input wire [63:0] correct_pc,

    // IF stage pc
    input wire [63:0] current_pc,

    // Next pc
    output wire [63:0] predicted_pc,
    output wire prediction_failed
);
    wire [63:0] pc_plus_imm;
    wire [63:0] pc_plus_4;
    wire next_prediction;
    wire prediction_correct;

    immediate_adder imm_add(
        .pc(current_pc),
        .instruction(next_instruction),
        .pc_plus_imm(pc_plus_imm),
        .pc_plus_4(pc_plus_4)
    );

    predictor predict(
        .instruction(next_instruction),
        .truth(correct_pc != (current_pc + 4)),
        .clk(clk),
        .rst(rst),
        .next_prediction(next_prediction)
    );

    assign predicted_pc = next_prediction ? pc_plus_imm : pc_plus_4;
    assign prediction_correct = (correct_pc == predicted_pc);
    assign prediction_failed = ~prediction_correct;
endmodule
