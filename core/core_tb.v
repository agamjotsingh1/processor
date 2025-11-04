`timescale 1ns / 1ps

module core_tb;
    localparam BUS_WIDTH = 64;
    localparam INSTR_WIDTH = 32;
    localparam REGFILE_LEN = 6;
    localparam ALU_CONTROL_WIDTH = 2;
    localparam ALU_SELECT_WIDTH = 3;
    localparam FPU_OP_WIDTH = 3;
    localparam BRANCH_SRC_WIDTH = 3;
    localparam INSTR_MEM_LEN = 15;
    localparam CLK_PERIOD = 10;
    
    reg clk;
    reg rst;
    wire [63:0] debug;
    
    core #(
        .BUS_WIDTH(BUS_WIDTH),
        .INSTR_WIDTH(INSTR_WIDTH),
        .REGFILE_LEN(REGFILE_LEN),
        .ALU_CONTROL_WIDTH(ALU_CONTROL_WIDTH),
        .ALU_SELECT_WIDTH(ALU_SELECT_WIDTH),
        .FPU_OP_WIDTH(FPU_OP_WIDTH),
        .BRANCH_SRC_WIDTH(BRANCH_SRC_WIDTH),
        .INSTR_MEM_LEN(INSTR_MEM_LEN)
    ) dut (
        .clk(clk),
        .rst(rst),
        .debug(debug)
    );

    assign dut.imm_pc = 0;
    assign dut.pc_stall = 0;
    assign dut.if_id_stall = 0;
    assign dut.id_ex_stall = 0;
    assign dut.ex_mem_stall = 0;
    assign dut.mem_wb_stall = 0;
    
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    initial begin
        rst = 1;
        @(posedge clk);
        #1 rst = 0;
        $finish;
    end
    
endmodule
