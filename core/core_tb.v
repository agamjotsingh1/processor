`timescale 1ns / 1ps

module core_tb;
    localparam BUS_WIDTH = 64;
    localparam CLK_PERIOD = 10;
    
    reg clk;
    reg rst;
    wire [63:0] debug;
    
    core #(
        .BUS_WIDTH(BUS_WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .debug(debug)
    );

    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    initial begin
        rst = 1;
        @(posedge clk);
        #10 rst = 0;
        //stall = 1;
        //@(posedge clk);
        //#10 stall = 0;

        $finish;
    end
    
endmodule
