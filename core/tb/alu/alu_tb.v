`timescale 1ns/1ps

module tb_alu;
    reg [63:0] in1;
    reg [63:0] in2;
    reg [2:0] funct3;
    reg [6:0] funct7;
    wire [63:0] out;

    // Expected value
    reg [63:0] expected_out;
    reg [127:0] temp_mul_result;
    reg [64:0] temp_add_result;
    
    // Test counters
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate DUT
    alu dut (
        .in1(in1),
        .in2(in2),
        .funct3(funct3),
        .funct7(funct7),
        .out(out)
    );

    // Task to check results
    task check_result;
        input [1000:0] test_name;
        begin
            test_num = test_num + 1;
            #1; // Small delay for signals to settle
            if (out === expected_out) begin
                $display("[PASS] Test %0d: %s", test_num, test_name);
                $display("       Inputs: in1=%h, in2=%h, funct3=%b, funct7=%b", in1, in2, funct3, funct7);
                $display("       Expected: out=%h", expected_out);
                $display("       Got:      out=%h", out);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] Test %0d: %s", test_num, test_name);
                $display("       Inputs: in1=%h, in2=%h, funct3=%b, funct7=%b", in1, in2, funct3, funct7);
                $display("       Expected: out=%h", expected_out);
                $display("       Got:      out=%h", out);
                fail_count = fail_count + 1;
            end
            $display("");
        end
    endtask

    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;
        in1 = 0;
        in2 = 0;
        funct3 = 0;
        funct7 = 0;

        $display("========================================");
        $display("Starting ALU Module Testbench");
        $display("========================================\n");

        // ========================================
        // ADD/SUB/SLT/SLTU TESTS (select = 3'b000)
        // ========================================
        $display("--- ADD TESTS ---\n");

        // Test 1: ADD
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        in1 = 64'h0000000000000005;
        in2 = 64'h0000000000000003;
        expected_out = in1 + in2;
        check_result("ADD: 5 + 3 = 8");

        // Test 2: ADD with overflow
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        in1 = 64'hFFFFFFFFFFFFFFFF;
        in2 = 64'h0000000000000001;
        expected_out = in1 + in2;
        check_result("ADD: MAX + 1 (overflow)");

        $display("--- SUB TESTS ---\n");

        // Test 3: SUB
        funct3 = 3'b000;
        funct7 = 7'b0100000;
        in1 = 64'h0000000000000008;
        in2 = 64'h0000000000000003;
        expected_out = in1 - in2;
        check_result("SUB: 8 - 3 = 5");

        // Test 4: SUB with borrow
        funct3 = 3'b000;
        funct7 = 7'b0100000;
        in1 = 64'h0000000000000000;
        in2 = 64'h0000000000000001;
        expected_out = in1 - in2;
        check_result("SUB: 0 - 1 (borrow)");

        $display("--- SLT TESTS ---\n");

        // Test 5: SLT (true)
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        in1 = 64'h0000000000000003;
        in2 = 64'h0000000000000005;
        expected_out = ($signed(in1) < $signed(in2)) ? 64'b1 : 64'b0;
        check_result("SLT: 3 < 5 (true)");

        // Test 6: SLT (false)
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        in1 = 64'h0000000000000005;
        in2 = 64'h0000000000000003;
        expected_out = ($signed(in1) < $signed(in2)) ? 64'b1 : 64'b0;
        check_result("SLT: 5 < 3 (false)");

        // Test 7: SLT negative
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        in1 = 64'hFFFFFFFFFFFFFFFE; // -2
        in2 = 64'h0000000000000005;
        expected_out = ($signed(in1) < $signed(in2)) ? 64'b1 : 64'b0;
        check_result("SLT: -2 < 5 (true)");

        $display("--- SLTU TESTS ---\n");

        // Test 8: SLTU (true)
        funct3 = 3'b011;
        funct7 = 7'b0000000;
        in1 = 64'h0000000000000003;
        in2 = 64'h0000000000000005;
        expected_out = ($unsigned(in1) < $unsigned(in2)) ? 64'b1 : 64'b0;
        check_result("SLTU: 3 < 5 (true)");

        // Test 9: SLTU (false)
        funct3 = 3'b011;
        funct7 = 7'b0000000;
        in1 = 64'hFFFFFFFFFFFFFFFE;
        in2 = 64'h0000000000000005;
        expected_out = ($unsigned(in1) < $unsigned(in2)) ? 64'b1 : 64'b0;
        check_result("SLTU: large < 5 (false)");

        // ========================================
        // MULTIPLICATION TESTS (select = 3'b001)
        // ========================================
        $display("--- MUL TESTS ---\n");

        // Test 10: MUL
        funct3 = 3'b000;
        funct7 = 7'b0000001;
        in1 = 64'h0000000000000005;
        in2 = 64'h0000000000000003;
        temp_mul_result = $signed(in1) * $signed(in2);
        expected_out = temp_mul_result[63:0];
        check_result("MUL: 5 * 3 = 15");

        // Test 11: MUL negative
        funct3 = 3'b000;
        funct7 = 7'b0000001;
        in1 = 64'h0000000000000007;
        in2 = 64'hFFFFFFFFFFFFFFFE; // -2
        temp_mul_result = $signed(in1) * $signed(in2);
        expected_out = temp_mul_result[63:0];
        check_result("MUL: 7 * (-2) = -14");

        $display("--- MULH TESTS ---\n");

        // Test 12: MULH
        funct3 = 3'b001;
        funct7 = 7'b0000001;
        in1 = 64'h7FFFFFFFFFFFFFFF;
        in2 = 64'h0000000000000002;
        temp_mul_result = $signed(in1) * $signed(in2);
        expected_out = temp_mul_result[127:64];
        check_result("MULH: MAX_INT * 2 (upper)");

        $display("--- MULHSU TESTS ---\n");

        // Test 13: MULHSU
        funct3 = 3'b010;
        funct7 = 7'b0000001;
        in1 = 64'hFFFFFFFFFFFFFFFE; // -2 signed
        in2 = 64'h0000000000000005; // 5 unsigned
        temp_mul_result = $signed(in1) * $unsigned(in2);
        expected_out = temp_mul_result[127:64];
        check_result("MULHSU: (-2) * 5u (upper)");

        $display("--- MULHU TESTS ---\n");

        // Test 14: MULHU
        funct3 = 3'b011;
        funct7 = 7'b0000001;
        in1 = 64'hFFFFFFFFFFFFFFFF;
        in2 = 64'h0000000000000002;
        temp_mul_result = $unsigned(in1) * $unsigned(in2);
        expected_out = temp_mul_result[127:64];
        check_result("MULHU: MAX_UINT * 2 (upper)");

        // ========================================
        // DIVISION TESTS (select = 3'b010)
        // ========================================
        $display("--- DIV TESTS ---\n");

        // Test 15: DIV
        funct3 = 3'b100;
        funct7 = 7'b0000001;
        in1 = 64'h000000000000000A; // 10
        in2 = 64'h0000000000000002; // 2
        expected_out = $signed(in1) / $signed(in2);
        check_result("DIV: 10 / 2 = 5");

        // Test 16: DIV negative
        funct3 = 3'b100;
        funct7 = 7'b0000001;
        in1 = 64'hFFFFFFFFFFFFFFF6; // -10
        in2 = 64'h0000000000000002; // 2
        expected_out = $signed(in1) / $signed(in2);
        check_result("DIV: (-10) / 2 = -5");

        $display("--- DIVU TESTS ---\n");

        // Test 17: DIVU
        funct3 = 3'b101;
        funct7 = 7'b0000001;
        in1 = 64'h000000000000000A; // 10
        in2 = 64'h0000000000000002; // 2
        expected_out = $unsigned(in1) / $unsigned(in2);
        check_result("DIVU: 10 / 2 = 5");

        $display("--- REM TESTS ---\n");

        // Test 18: REM
        funct3 = 3'b110;
        funct7 = 7'b0000001;
        in1 = 64'h000000000000000B; // 11
        in2 = 64'h0000000000000003; // 3
        expected_out = $signed(in1) % $signed(in2);
        check_result("REM: 11 % 3 = 2");

        $display("--- REMU TESTS ---\n");

        // Test 19: REMU
        funct3 = 3'b111;
        funct7 = 7'b0000001;
        in1 = 64'h000000000000000B; // 11
        in2 = 64'h0000000000000003; // 3
        expected_out = $unsigned(in1) % $unsigned(in2);
        check_result("REMU: 11 % 3 = 2");

        // ========================================
        // SHIFT LEFT TESTS (select = 3'b011)
        // ========================================
        $display("--- SLL TESTS ---\n");

        // Test 20: SLL
        funct3 = 3'b001;
        funct7 = 7'b0000000;
        in1 = 64'h0000000000000001;
        in2 = 64'h0000000000000004; // shift by 4
        expected_out = in1 << in2[5:0];
        check_result("SLL: 1 << 4 = 16");

        // Test 21: SLL large
        funct3 = 3'b001;
        funct7 = 7'b0000000;
        in1 = 64'h123456789ABCDEF0;
        in2 = 64'h0000000000000008; // shift by 8
        expected_out = in1 << in2[5:0];
        check_result("SLL: X << 8");

        // ========================================
        // SHIFT RIGHT TESTS (select = 3'b100)
        // ========================================
        $display("--- SRL TESTS ---\n");

        // Test 22: SRL (logical)
        funct3 = 3'b101;
        funct7 = 7'b0000000;
        in1 = 64'h00000000000000F0;
        in2 = 64'h0000000000000004; // shift by 4
        expected_out = in1 >> in2[5:0];
        check_result("SRL: 0xF0 >> 4 = 0x0F");

        // Test 23: SRL negative value
        funct3 = 3'b101;
        funct7 = 7'b0000000;
        in1 = 64'h8000000000000000;
        in2 = 64'h0000000000000004; // shift by 4
        expected_out = in1 >> in2[5:0];
        check_result("SRL: 0x8000... >> 4 (logical)");

        $display("--- SRA TESTS ---\n");

        // Test 24: SRA (arithmetic)
        funct3 = 3'b101;
        funct7 = 7'b0100000;
        in1 = 64'h00000000000000F0;
        in2 = 64'h0000000000000004; // shift by 4
        expected_out = $signed(in1) >>> in2[5:0];
        check_result("SRA: 0xF0 >>> 4 (positive)");

        // Test 25: SRA negative value (sign extend)
        funct3 = 3'b101;
        funct7 = 7'b0100000;
        in1 = 64'h8000000000000000;
        in2 = 64'h0000000000000004; // shift by 4
        expected_out = $signed(in1) >>> in2[5:0];
        check_result("SRA: 0x8000... >>> 4 (sign extend)");

        // Test 26: SRA -1
        funct3 = 3'b101;
        funct7 = 7'b0100000;
        in1 = 64'hFFFFFFFFFFFFFFFF; // -1
        in2 = 64'h0000000000000008; // shift by 8
        expected_out = $signed(in1) >>> in2[5:0];
        check_result("SRA: -1 >>> 8 = -1");

        // ========================================
        // LOGICAL OPERATION TESTS
        // ========================================
        $display("--- XOR TESTS ---\n");

        // Test 27: XOR
        funct3 = 3'b100;
        funct7 = 7'b0000000;
        in1 = 64'h5555555555555555;
        in2 = 64'hAAAAAAAAAAAAAAAA;
        expected_out = in1 ^ in2;
        check_result("XOR: 0x5555 ^ 0xAAAA = 0xFFFF");

        // Test 28: XOR self (zero)
        funct3 = 3'b100;
        funct7 = 7'b0000000;
        in1 = 64'h123456789ABCDEF0;
        in2 = 64'h123456789ABCDEF0;
        expected_out = in1 ^ in2;
        check_result("XOR: X ^ X = 0");

        $display("--- OR TESTS ---\n");

        // Test 29: OR
        funct3 = 3'b110;
        funct7 = 7'b0000000;
        in1 = 64'h5555555555555555;
        in2 = 64'hAAAAAAAAAAAAAAAA;
        expected_out = in1 | in2;
        check_result("OR: 0x5555 | 0xAAAA = 0xFFFF");

        // Test 30: OR with zero
        funct3 = 3'b110;
        funct7 = 7'b0000000;
        in1 = 64'h123456789ABCDEF0;
        in2 = 64'h0000000000000000;
        expected_out = in1 | in2;
        check_result("OR: X | 0 = X");

        $display("--- AND TESTS ---\n");

        // Test 31: AND
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        in1 = 64'h5555555555555555;
        in2 = 64'hAAAAAAAAAAAAAAAA;
        expected_out = in1 & in2;
        check_result("AND: 0x5555 & 0xAAAA = 0");

        // Test 32: AND with all 1s (identity)
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        in1 = 64'h123456789ABCDEF0;
        in2 = 64'hFFFFFFFFFFFFFFFF;
        expected_out = in1 & in2;
        check_result("AND: X & 0xFFFF = X");

        // Test 33: AND masking
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        in1 = 64'h123456789ABCDEF0;
        in2 = 64'h00000000FFFFFFFF;
        expected_out = in1 & in2;
        check_result("AND: mask lower 32 bits");

        // ========================================
        // FINAL RESULTS
        // ========================================
        $display("========================================");
        $display("Testbench Complete");
        $display("========================================");
        $display("Total Tests: %0d", test_num);
        $display("Passed:      %0d", pass_count);
        $display("Failed:      %0d", fail_count);
        $display("========================================");
        
        if (fail_count == 0) begin
            $display("*** ALL TESTS PASSED ***");
        end else begin
            $display("*** SOME TESTS FAILED ***");
        end
        $display("========================================\n");

        $finish;
    end

endmodule
