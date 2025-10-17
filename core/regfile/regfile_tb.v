`timescale 1ns/1ps

module regfile_tb;
    reg clk;
    reg write_enable;
    reg [5:0] read_addr1, read_addr2, write_addr;
    reg [63:0] write_data;
    wire [63:0] read_data1, read_data2;

    // Instantiate the regfile
    regfile DUT (
        .clk(clk),
        .write_enable(write_enable),
        .read_addr1(read_addr1),
        .read_data1(read_data1),
        .read_addr2(read_addr2),
        .read_data2(read_data2),
        .write_addr(write_addr),
        .write_data(write_data)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Test sequence start
        $display("Time\twrite_en\twrite_addr\twrite_data\tread_addr1\tread_data1\tread_addr2\tread_data2");
        $monitor("%0t\t%b\t%h\t%h\t%h\t%h\t%h\t%h", 
                 $time, write_enable, write_addr, write_data, read_addr1, read_data1, read_addr2, read_data2);

        // Initialize signals
        write_enable = 0;
        write_addr = 6'd0;
        write_data = 64'd0;
        read_addr1 = 6'd0;
        read_addr2 = 6'd0;

        #10;
        // Write to register 0
        write_enable = 1;
        write_addr = 6'd0;
        write_data = 64'hA5A5A5A5A5A5A5A5;
        #10;

        write_enable = 0;
        read_addr1 = 6'd0;  // Read register 0
        read_addr2 = 6'd1;  // Read register 1 (expect 0)
        #10;

        // Write to register 1
        write_enable = 1;
        write_addr = 6'd1;
        write_data = 64'h5A5A5A5A5A5A5A5A;
        #10;

        write_enable = 0;
        read_addr1 = 6'd1;  // Read register 1
        read_addr2 = 6'd0;  // Read register 0
        #10;

        // Write to register 63 (last register)
        write_enable = 1;
        write_addr = 6'd63;
        write_data = 64'hDEADBEEFDEADBEEF;
        #10;

        write_enable = 0;
        read_addr1 = 6'd63;
        read_addr2 = 6'd0;
        #10;

        // Finish simulation
        $finish;
    end
endmodule
