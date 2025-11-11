`timescale 1ns / 1ps

module core_tb;
    localparam BUS_WIDTH = 64;
    localparam CLK_PERIOD = 10;
    
    reg clk;
    reg rst;
    
    core #(
        .BUS_WIDTH(BUS_WIDTH)
    ) dut (
        .sys_clk(clk),
        .running(1'b1),
        .rst(rst),
        .axi_data_clk(1'b0),
        .axi_data_en(1'b0),
        .axi_data_we(1'b0),
        .axi_data_addr(64'h0),
        .axi_data_din(8'h0),
        .axi_data_dout()  // Leave output unconnected
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
