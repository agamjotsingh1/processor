// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (lin64) Build 6140274 Wed May 21 22:58:25 MDT 2025
// Date        : Wed Nov 12 18:46:59 2025
// Host        : agam running 64-bit Ubuntu 22.04.5 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/agamubuntu/Github/processor/riscv/riscv.gen/sources_1/bd/design_1/ip/design_1_core_0_0/design_1_core_0_0_stub.v
// Design      : design_1_core_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CHECK_LICENSE_TYPE = "design_1_core_0_0,core,{}" *) (* CORE_GENERATION_INFO = "design_1_core_0_0,core,{x_ipProduct=Vivado 2025.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=core,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,BUS_WIDTH=64,INSTR_MEM_LEN=15,INSTR_WIDTH=32,DATA_MEM_LEN=12,DATA_MEM_SUB_WIDTH=8}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) 
(* IP_DEFINITION_SOURCE = "module_ref" *) (* X_CORE_INFO = "core,Vivado 2025.1" *) 
module design_1_core_0_0(sys_clk, running, rst, axi_if_pc, axi_if_instr, 
  axi_instr_clk, axi_instr_en, axi_instr_we, axi_instr_addr, axi_instr_din, axi_instr_dout, 
  axi_debug_col, axi_debug_row, axi_debug_col_dout, axi_data_clk, axi_data_en, axi_data_we, 
  axi_data_addr, axi_data_din, axi_data_dout)
/* synthesis syn_black_box black_box_pad_pin="sys_clk,running,rst,axi_if_pc[31:0],axi_if_instr[31:0],axi_instr_en,axi_instr_we[3:0],axi_instr_addr[14:0],axi_instr_din[31:0],axi_instr_dout[31:0],axi_debug_col[2:0],axi_debug_row[60:0],axi_debug_col_dout[63:0],axi_data_en,axi_data_we,axi_data_addr[63:0],axi_data_din[7:0],axi_data_dout[7:0]" */
/* synthesis syn_force_seq_prim="axi_instr_clk" */
/* synthesis syn_force_seq_prim="axi_data_clk" */;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 sys_clk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME sys_clk, FREQ_HZ 5000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input sys_clk;
  input running;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input rst;
  output [31:0]axi_if_pc;
  output [31:0]axi_if_instr;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 axi_instr_clk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME axi_instr_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input axi_instr_clk /* synthesis syn_isclock = 1 */;
  input axi_instr_en;
  input [3:0]axi_instr_we;
  input [14:0]axi_instr_addr;
  input [31:0]axi_instr_din;
  output [31:0]axi_instr_dout;
  output [2:0]axi_debug_col;
  output [60:0]axi_debug_row;
  output [63:0]axi_debug_col_dout;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 axi_data_clk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME axi_data_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input axi_data_clk /* synthesis syn_isclock = 1 */;
  input axi_data_en;
  input axi_data_we;
  input [63:0]axi_data_addr;
  input [7:0]axi_data_din;
  output [7:0]axi_data_dout;
endmodule
