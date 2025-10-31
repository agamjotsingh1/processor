`timescale 1ns/1ps

module core_tb;
    reg clk;
    
    core core_inst (
        .clk(clk)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #20 clk = ~clk;
    end
    
    // Simulation control
    initial begin
        #1000;
        $finish;
    end
endmodule

