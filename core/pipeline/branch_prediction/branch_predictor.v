module branch_predictor (
    input wire clk,
    input wire stall,
    input wire rst,
    input wire [63:0] if_pc,
    input wire [31:0] if_instr,
    input wire id_branch_taken,
    input wire [63:0] next_unpredicted_pc,
    output wire [63:0] next_predicted_pc,
    output wire branch_prediction_failed,

    // stall due to consecutive branches
    output wire branch_consecutive_stall
);
    // 1 if currently in process of prediction
    reg is_branch_state;
    //reg branch_consecutive_stall_reg;

    wire [6:0] opcode = if_instr[6:0];
    assign imm = {{51{if_instr[31]}}, if_instr[31], if_instr[7], if_instr[30:25], if_instr[11:8], 1'b0}; // B type

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

    always @(posedge clk) begin
        if(rst) begin
            is_branch_state <= 0;
            //branch_consecutive_stall_reg <= 0;
            prediction <= 0;
        end
        else if (is_branch_state & ~stall) begin
            is_branch_state <= 0;
            //if(opcode == 7'b1100011) branch_consecutive_stall_reg <= 1;
            //else branch_consecutive_stall_reg <= 0;
            prediction <= next_prediction;
        end
        else if(opcode == 7'b1100011 & ~stall) begin
            is_branch_state <= 1;
            //branch_consecutive_stall_reg <= 0;
            prediction <= next_prediction;
        end
    end

    
    assign branch_prediction_failed = is_branch_state & (prediction != id_branch_taken);

    wire [63:0] failed_pc = prediction ? (if_pc - imm + 4): next_unpredicted_pc;

    assign next_predicted_pc = branch_prediction_failed
                                ? failed_pc
                                : next_unpredicted_pc;

    //assign branch_consecutive_stall = branch_consecutive_stall_reg;
    //assign branch_consecutive_stall = (opcode == 7'b1100011) & is_branch_state & (~stall);
    assign branch_consecutive_stall = 0;
endmodule