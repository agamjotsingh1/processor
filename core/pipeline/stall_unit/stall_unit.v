module stall_unit (
    input wire clk,
    input wire rst,
    input wire stall,

    output reg out_stall
);
    reg ff [0:2];

    always @(posedge clk) begin
        if(rst | stall) begin
            ff[0] <= 1'b1;
            ff[1] <= 1'b0;
        end
        else begin
            ff[0] <= ff[1];
            ff[1] <= ff[0];
        end

        out_stall = ~ff[0];
    end
endmodule