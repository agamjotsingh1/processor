module branch_predictor (
    input wire clk,
    input wire stall,
    input wire rst,
    input wire [63:0] if_pc,
    input wire [31:0] if_instr,
    input wire id_branch_taken,
    input wire [63:0] next_unpredicted_pc,
    output wire [63:0] next_predicted_pc,
    output wire branch_prediction_failed
);
    // 1 if currently in process of prediction
    reg is_branch_state;

    wire [6:0] opcode = if_instr[6:0];
    wire [63:0] imm = {{51{if_instr[31]}}, if_instr[31], if_instr[7], if_instr[30:25], if_instr[11:8], 1'b0}; // B type

    reg prediction;
    wire next_prediction;

    /*predictor predictor_instance (
        .clk(clk),
        .reset(rst),
        .instruction(if_instr),
        .truth(id_branch_taken), // 1 means it has branched previously
        .next_prediction(next_prediction) // 1 means predicting it will branch
    );*/
    assign next_prediction = 0;

    reg [63:0] failed_pc;
    reg [63:0] stored_imm;

    always @(posedge clk) begin
        if(rst) begin
            is_branch_state <= 0;
            //branch_prediction_failed <= 0;
            failed_pc <= 0;
            prediction <= next_prediction;
            stored_imm <= 0;
        end
        else if (is_branch_state & ~stall) begin
            //branch_prediction_failed <= is_branch_state & (prediction != id_branch_taken);
            failed_pc <= prediction ? (if_pc - stored_imm + 4): next_unpredicted_pc;
            is_branch_state <= (is_branch_state & (prediction != id_branch_taken)) & (opcode == 7'b1100011);
            prediction <= next_prediction;
            stored_imm <= imm;
        end
        else if(opcode == 7'b1100011 & ~stall) begin
            is_branch_state <= 1;
            //branch_prediction_failed <= 0;
            prediction <= next_prediction;
            stored_imm <= imm;
        end
        else if(~stall) begin
            is_branch_state <= 0;
            //branch_prediction_failed <= 0;
        end
    end


    assign branch_prediction_failed = is_branch_state & (prediction != id_branch_taken);
    assign next_predicted_pc = branch_prediction_failed
                                ? failed_pc
                                : next_unpredicted_pc;
endmodule
