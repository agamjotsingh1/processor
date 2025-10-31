module pcfsm (
    input wire clk,

    output reg stall,
    output reg reg_write_stall,
    output reg mem_stall
);
    reg ff [0:5];

    initial begin
        ff[0] <= 1'b1;
        ff[1] <= 1'b0;
        ff[2] <= 1'b0;
        ff[3] <= 1'b0;
        ff[4] <= 1'b0;
        ff[5] <= 1'b0;
    end

    always @(posedge clk) begin
        ff[0] <= ff[5];
        ff[5] <= ff[4];
        ff[4] <= ff[3];
        ff[3] <= ff[2];
        ff[2] <= ff[1];
        ff[1] <= ff[0];

        stall = ~ff[0];
        reg_write_stall = ~ff[5];
        mem_stall = ~(ff[3] | ff[4] | ff[5]);
    end
endmodule