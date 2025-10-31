`timescale 1ns / 1ps

module core_tb();
    // Clock signal
    reg clk;
    
    // Testbench signals
    reg [31:0] instr;
    wire [63:0] out;
    
    // Instantiate the core module
    core dut (
        .clk(clk),
        .instr(instr),
        .out(out)
    );
    
    // Clock generation - 10ns period (100MHz)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    // Monitor control signals continuously
    initial begin
        $monitor("Time=%0t | instr=%h | RegWrite=%b MemWrite=%b MemRead=%b MemToReg=%b ALUSrc=%b | ALUControl=%b ALUSelect=%b | rs1=%d rs2=%d rd=%d | imm=%h | ReadData1=%h ReadData2=%h | ALUOut=%h | Zero=%b Neg=%b NegU=%b", 
            $time, 
            instr,
            dut.reg_write,
            dut.mem_write, 
            dut.mem_read,
            dut.mem_to_reg,
            dut.alu_src,
            dut.control,
            dut.select,
            dut.rs1,
            dut.rs2,
            dut.rd,
            dut.imm,
            dut.read_data1,
            dut.read_data2,
            dut.alu_out,
            dut.zero,
            dut.neg,
            dut.negu
        );
    end
    
    // Test stimulus
    initial begin
        // VCD dump configuration
        $dumpfile("core_tb.vcd");
        $dumpvars(0, core_tb);
        
        // Dump all registers in the register file
        for (integer i = 0; i < 64; i = i + 1) begin
            $dumpvars(0, dut.regfile_instance.reg_array[i]);
        end
        
        // Display header
        $display("\n============================================================");
        $display("           RISC-V Core Testbench - Control Signal Debug");
        $display("============================================================\n");
        
        // Initialize
        instr = 32'h00000013; // NOP (addi x0, x0, 0)
        @(posedge clk);
        #1;
        $display("\n--- Test 0: NOP (ADDI x0, x0, 0) ---");
        display_control_signals();
        
        // Test 1: ADDI x1, x0, 10
        $display("\n--- Test 1: ADDI x1, x0, 10 ---");
        instr = 32'b000000001010_00000_000_00001_0010011;
        @(posedge clk);
        #1;
        display_control_signals();
        display_register_value(1);
        
        // Test 2: ADDI x2, x0, 20
        $display("\n--- Test 2: ADDI x2, x0, 20 ---");
        instr = 32'b000000010100_00000_000_00010_0010011;
        @(posedge clk);
        #1;
        display_control_signals();
        display_register_value(2);
        
        // Test 3: ADD x3, x1, x2 (10 + 20 = 30)
        $display("\n--- Test 3: ADD x3, x1, x2 (R-Type) ---");
        instr = 32'b0000000_00010_00001_000_00011_0110011;
        @(posedge clk);
        #1;
        display_control_signals();
        display_register_value(3);
        $display("Expected: x3 = 30");
        
        // Test 4: ADDI x4, x0, 50
        $display("\n--- Test 4: ADDI x4, x0, 50 ---");
        instr = 32'b000000110010_00000_000_00100_0010011;
        @(posedge clk);
        #1;
        display_control_signals();
        display_register_value(4);
        
        // Test 5: SUB x5, x4, x2 (50 - 20 = 30)
        $display("\n--- Test 5: SUB x5, x4, x2 ---");
        instr = 32'b0100000_00010_00100_000_00101_0110011;
        @(posedge clk);
        #1;
        display_control_signals();
        display_register_value(5);
        $display("Expected: x5 = 30");
        
        // Test 6: ADDI x6, x0, 15
        $display("\n--- Test 6: ADDI x6, x0, 15 ---");
        instr = 32'b000000001111_00000_000_00110_0010011;
        @(posedge clk);
        #1;
        display_control_signals();
        display_register_value(6);
        
        // Test 7: AND x7, x4, x6 (50 & 15 = 2)
        $display("\n--- Test 7: AND x7, x4, x6 ---");
        instr = 32'b0000000_00110_00100_111_00111_0110011;
        @(posedge clk);
        #1;
        display_control_signals();
        display_register_value(7);
        $display("Expected: x7 = 2 (0x32 & 0x0F = 0x02)");
        
        // Test 8: OR x8, x1, x2 (10 | 20 = 30)
        $display("\n--- Test 8: OR x8, x1, x2 ---");
        instr = 32'b0000000_00010_00001_110_01000_0110011;
        @(posedge clk);
        #1;
        display_control_signals();
        display_register_value(8);
        $display("Expected: x8 = 30 (0x0A | 0x14 = 0x1E)");
        
        // Test 9: XOR x9, x1, x2 (10 ^ 20 = 30)
        $display("\n--- Test 9: XOR x9, x1, x2 ---");
        instr = 32'b0000000_00010_00001_100_01001_0110011;
        @(posedge clk);
        #1;
        display_control_signals();
        display_register_value(9);
        $display("Expected: x9 = 30 (0x0A ^ 0x14 = 0x1E)");
        
        // Test 10: SLL x10, x6, x1 (15 << 10)
        $display("\n--- Test 10: SLL x10, x6, x1 (Shift Left) ---");
        instr = 32'b0000000_00001_00110_001_01010_0110011;
        @(posedge clk);
        #1;
        display_control_signals();
        display_register_value(10);
        $display("Expected: x10 = 15360 (15 << 10)");
        
        // Test 11: ADDI x11, x0, 100
        $display("\n--- Test 11: ADDI x11, x0, 100 ---");
        instr = 32'b000001100100_00000_000_01011_0010011;
        @(posedge clk);
        #1;
        display_control_signals();
        display_register_value(11);
        
        // Test 12: SLT x12, x1, x11 (10 < 100 = 1)
        $display("\n--- Test 12: SLT x12, x1, x11 (Set Less Than) ---");
        instr = 32'b0000000_01011_00001_010_01100_0110011;
        @(posedge clk);
        #1;
        display_control_signals();
        display_register_value(12);
        $display("Expected: x12 = 1 (10 < 100)");
        
        // Test 13: LUI x13, 0x12345 (load upper immediate)
        $display("\n--- Test 13: LUI x13, 0x12345 (U-Type) ---");
        instr = 32'b00010010001101000101_01101_0110111;
        @(posedge clk);
        #1;
        display_control_signals();
        display_register_value(13);
        $display("Expected: x13 = 0x12345000");
        
        // Test 14: ADDI x14, x0, -1 (test sign extension)
        $display("\n--- Test 14: ADDI x14, x0, -1 (Sign Extension Test) ---");
        instr = 32'b111111111111_00000_000_01110_0010011;
        @(posedge clk);
        #1;
        display_control_signals();
        display_register_value(14);
        $display("Expected: x14 = -1 (0xFFFFFFFFFFFFFFFF)");
        
        // Test 15: SLLI x15, x6, 2 (15 << 2 = 60)
        $display("\n--- Test 15: SLLI x15, x6, 2 (Shift Left Logical Immediate) ---");
        instr = 32'b0000000_00010_00110_001_01111_0010011;
        @(posedge clk);
        #1;
        display_control_signals();
        display_register_value(15);
        $display("Expected: x15 = 60 (15 << 2)");
        
        // Display complete register file
        $display("\n============================================================");
        $display("               Final Register File State");
        $display("============================================================");
        $display("\nInteger Registers (x0-x31):");
        $display("Reg  | Decimal           | Hexadecimal");
        $display("-----|-------------------|------------------");
        for (integer i = 0; i < 32; i = i + 1) begin
            if (dut.regfile_instance.reg_array[i] != 0 || i < 16) begin
                $display("x%-3d | %-17d | 0x%016h", i, 
                    $signed(dut.regfile_instance.reg_array[i]), 
                    dut.regfile_instance.reg_array[i]);
            end
        end
        
        // Display control signal summary
        $display("\n============================================================");
        $display("               Control Signals Summary");
        $display("============================================================");
        $display("Signal Name       | Current Value | Description");
        $display("------------------|---------------|---------------------------");
        $display("reg_write         | %b             | Register Write Enable", dut.reg_write);
        $display("mem_write         | %b             | Memory Write Enable", dut.mem_write);
        $display("mem_read          | %b             | Memory Read Enable", dut.mem_read);
        $display("mem_to_reg        | %b             | Memory to Register Mux", dut.mem_to_reg);
        $display("alu_src           | %b             | ALU Source Mux (0=reg, 1=imm)", dut.alu_src);
        $display("jump_src          | %b             | Jump Source", dut.jump_src);
        $display("branch_src        | %b             | Branch Source", dut.branch_src);
        $display("jalr_src          | %b             | JALR Source", dut.jalr_src);
        $display("u_src             | %b             | U-Type Source", dut.u_src);
        $display("uj_src            | %b             | UJ-Type Source", dut.uj_src);
        $display("alu_control[1:0]  | %b            | ALU Operation Control", dut.control);
        $display("alu_select[2:0]   | %b           | ALU Function Select", dut.select);
        
        #20;
        $display("\n============================================================");
        $display("Testbench completed at time %0t ns", $time);
        $display("============================================================\n");
        $finish;
    end
    
    // Task to display control signals
    task display_control_signals;
        begin
            $display("Instruction: 0x%h", instr);
            $display("  Opcode: %b | rs1=%d rs2=%d rd=%d | funct3=%b", 
                instr[6:0], dut.rs1, dut.rs2, dut.rd, instr[14:12]);
            $display("  Control Signals:");
            $display("    RegWrite=%b MemWrite=%b MemRead=%b MemToReg=%b ALUSrc=%b",
                dut.reg_write, dut.mem_write, dut.mem_read, dut.mem_to_reg, dut.alu_src);
            $display("    JumpSrc=%b BranchSrc=%b JALRSrc=%b USrc=%b UJSrc=%b",
                dut.jump_src, dut.branch_src, dut.jalr_src, dut.u_src, dut.uj_src);
            $display("  ALU:");
            $display("    Control=%b Select=%b", dut.control, dut.select);
            $display("    In1=0x%h In2=0x%h", dut.alu_in1, dut.alu_in2);
            $display("    Out=0x%h", dut.alu_out);
            $display("    Flags: Zero=%b Neg=%b NegU=%b", dut.zero, dut.neg, dut.negu);
            $display("  Immediate: 0x%h (%0d)", dut.imm, $signed(dut.imm));
            $display("  Register Read:");
            $display("    ReadData1=0x%h (%0d)", dut.read_data1, $signed(dut.read_data1));
            $display("    ReadData2=0x%h (%0d)", dut.read_data2, $signed(dut.read_data2));
        end
    endtask
    
    // Task to display a specific register value
    task display_register_value;
        input integer reg_num;
        begin
            $display("  Result: x%0d = %0d (0x%h)", 
                reg_num, 
                $signed(dut.regfile_instance.reg_array[reg_num]),
                dut.regfile_instance.reg_array[reg_num]);
        end
    endtask

endmodule

