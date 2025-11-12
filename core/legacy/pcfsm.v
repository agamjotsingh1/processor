module pcfsm (
    input wire clk,
    input wire rst,

    output reg stall,
    output reg reg_write_stall,
    output reg mem_stall
);
    reg ff [0:5];

    always @(posedge clk) begin
        if(rst) begin
            ff[0] <= 1'b1;
            ff[1] <= 1'b0;
            ff[2] <= 1'b0;
            ff[3] <= 1'b0;
            ff[4] <= 1'b0;
            ff[5] <= 1'b0;


        end
        else begin
            ff[0] <= ff[5];
            ff[5] <= ff[4];
            ff[4] <= ff[3];
            ff[3] <= ff[2];
            ff[2] <= ff[1];
            ff[1] <= ff[0];
        end

        stall = ~ff[0];
        reg_write_stall = ~ff[5];
        mem_stall = ~(ff[3] | ff[4]);
    end
endmodule

module pcfsm_legacy (
    input wire clk,
    input wire rst,

    output reg stall,
    output reg div_en,
    output reg reg_write_stall,
    output reg mem_stall
);
    reg ff [0:10];

    initial begin
        ff[0] <= 1'b1;
        ff[1] <= 1'b0;
        ff[2] <= 1'b0;
        ff[3] <= 1'b0;
        ff[4] <= 1'b0;
        ff[5] <= 1'b0;
        ff[6] <= 1'b0;
        ff[7] <= 1'b0;
        ff[8] <= 1'b0;
        ff[9] <= 1'b0;
        ff[10] <= 1'b0;
    end

    always @(posedge clk) begin
        if(rst) begin
            ff[0] <= 1'b1;
            ff[1] <= 1'b0;
            ff[2] <= 1'b0;
            ff[3] <= 1'b0;
            ff[4] <= 1'b0;
            ff[5] <= 1'b0;
            ff[6] <= 1'b0;
            ff[7] <= 1'b0;
            ff[8] <= 1'b0;
            ff[9] <= 1'b0;
            ff[10] <= 1'b0;
        end
        else begin
            ff[0] <= ff[10];
            ff[10] <= ff[9];
            ff[9] <= ff[8];
            ff[8] <= ff[7];
            ff[7] <= ff[6];
            ff[6] <= ff[5];
            ff[5] <= ff[4];
            ff[4] <= ff[3];
            ff[3] <= ff[2];
            ff[2] <= ff[1];
            ff[1] <= ff[0];
        end

        stall = ~ff[0];
        reg_write_stall = ~ff[10];
        mem_stall = ~(ff[8] | ff[9]);
        div_en = ~(ff[3] | ff[4] | ff[5] | ff[6] | ff[7]);
    end
endmodule