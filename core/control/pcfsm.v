module pcfsm (
    input wire clk,

    output reg stall,
    output reg reg_write_stall 
);
    reg ff [0:2];

    initial begin
        ff[0] <= 1'b1;
        ff[1] <= 1'b0;
        ff[2] <= 1'b0;
    end

    always @(posedge clk) begin
        ff[0] <= ff[2];
        ff[1] <= ff[0];
        ff[2] <= ff[1];

        stall = ~ff[0];
        reg_write_stall = ~ff[2];
    end
endmodule