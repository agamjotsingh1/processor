// (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// (c) Copyright 2022-2025 Advanced Micro Devices, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:module_ref:core:1.0
// IP Revision: 1

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module design_1_core_0_0 (
  sys_clk,
  running,
  rst,
  axi_if_pc,
  axi_if_instr,
  axi_instr_clk,
  axi_instr_en,
  axi_instr_we,
  axi_instr_addr,
  axi_instr_din,
  axi_instr_dout,
  axi_debug_col,
  axi_debug_row,
  axi_debug_col_dout,
  axi_data_clk,
  axi_data_en,
  axi_data_we,
  axi_data_addr,
  axi_data_din,
  axi_data_dout
);

(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 sys_clk CLK" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME sys_clk, FREQ_HZ 5000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *)
input wire sys_clk;
input wire running;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst RST" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
input wire rst;
output wire [31 : 0] axi_if_pc;
output wire [31 : 0] axi_if_instr;
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 axi_instr_clk CLK" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME axi_instr_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *)
input wire axi_instr_clk;
input wire axi_instr_en;
input wire [3 : 0] axi_instr_we;
input wire [14 : 0] axi_instr_addr;
input wire [31 : 0] axi_instr_din;
output wire [31 : 0] axi_instr_dout;
output wire [2 : 0] axi_debug_col;
output wire [60 : 0] axi_debug_row;
output wire [63 : 0] axi_debug_col_dout;
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 axi_data_clk CLK" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME axi_data_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *)
input wire axi_data_clk;
input wire axi_data_en;
input wire axi_data_we;
input wire [63 : 0] axi_data_addr;
input wire [7 : 0] axi_data_din;
output wire [7 : 0] axi_data_dout;

  core #(
    .BUS_WIDTH(64),
    .INSTR_MEM_LEN(15),
    .INSTR_WIDTH(32),
    .DATA_MEM_LEN(12),
    .DATA_MEM_SUB_WIDTH(8)
  ) inst (
    .sys_clk(sys_clk),
    .running(running),
    .rst(rst),
    .axi_if_pc(axi_if_pc),
    .axi_if_instr(axi_if_instr),
    .axi_instr_clk(axi_instr_clk),
    .axi_instr_en(axi_instr_en),
    .axi_instr_we(axi_instr_we),
    .axi_instr_addr(axi_instr_addr),
    .axi_instr_din(axi_instr_din),
    .axi_instr_dout(axi_instr_dout),
    .axi_debug_col(axi_debug_col),
    .axi_debug_row(axi_debug_row),
    .axi_debug_col_dout(axi_debug_col_dout),
    .axi_data_clk(axi_data_clk),
    .axi_data_en(axi_data_en),
    .axi_data_we(axi_data_we),
    .axi_data_addr(axi_data_addr),
    .axi_data_din(axi_data_din),
    .axi_data_dout(axi_data_dout)
  );
endmodule
