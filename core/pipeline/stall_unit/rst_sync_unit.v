module rst_sync_unit (
    input wire sys_clk,
    input wire rst,
    input wire running,
    output wire clk
);
    reg fsm[0:1];
    always @(negedge rst) begin

    end
endmodule