`timescale 1ns / 1ps

/*module core_tb;
    reg clk;
    wire [63:0] out;
    
    core uut (
        .clk(clk),
        .out(out)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        $dumpfile("core.vcd");
        $dumpvars(0, core_tb);
        
        $display("Starting test...");
        
        #100;
        
        $display("Test complete.");
        $finish;
    end
endmodule
*/
`timescale 1ns / 1ps

module core_tb;
    reg clk;
    reg [14:0] addr;
    wire [63:0] out;
    
    core uut (
        .clk(clk),
        .addr(addr),
        .out(out)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        $dumpfile("core.vcd");
        $dumpvars(0, core_tb);
        
        $display("Starting test...");
        
        addr = 15'd0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        addr = 15'd1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        addr = 15'd2;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        addr = 15'd4;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        addr = 15'd8;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        addr = 15'd16;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        addr = 15'd32;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        addr = 15'd63;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        addr = 15'd100;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        addr = 15'd255;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        addr = 15'd512;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        addr = 15'd1000;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        addr = 15'd1023;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        addr = 15'd2048;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        addr = 15'd4095;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        addr = 15'd8192;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        addr = 15'd16383;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        addr = 15'd32767;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        #50;
        
        $display("Test complete.");
        $finish;
    end
endmodule
