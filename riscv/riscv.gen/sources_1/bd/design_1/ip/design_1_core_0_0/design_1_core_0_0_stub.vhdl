-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2025.1 (lin64) Build 6140274 Wed May 21 22:58:25 MDT 2025
-- Date        : Wed Nov 12 16:47:59 2025
-- Host        : agam running 64-bit Ubuntu 22.04.5 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/agamubuntu/Github/processor/riscv/riscv.gen/sources_1/bd/design_1/ip/design_1_core_0_0/design_1_core_0_0_stub.vhdl
-- Design      : design_1_core_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity design_1_core_0_0 is
  Port ( 
    sys_clk : in STD_LOGIC;
    running : in STD_LOGIC;
    rst : in STD_LOGIC;
    axi_if_pc : out STD_LOGIC_VECTOR ( 31 downto 0 );
    axi_if_instr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    axi_instr_clk : in STD_LOGIC;
    axi_instr_en : in STD_LOGIC;
    axi_instr_we : in STD_LOGIC_VECTOR ( 3 downto 0 );
    axi_instr_addr : in STD_LOGIC_VECTOR ( 14 downto 0 );
    axi_instr_din : in STD_LOGIC_VECTOR ( 31 downto 0 );
    axi_instr_dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
    axi_debug_col : out STD_LOGIC_VECTOR ( 2 downto 0 );
    axi_debug_row : out STD_LOGIC_VECTOR ( 60 downto 0 );
    axi_debug_col_dout : out STD_LOGIC_VECTOR ( 63 downto 0 );
    axi_data_clk : in STD_LOGIC;
    axi_data_en : in STD_LOGIC;
    axi_data_we : in STD_LOGIC;
    axi_data_addr : in STD_LOGIC_VECTOR ( 63 downto 0 );
    axi_data_din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    axi_data_dout : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );

  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of design_1_core_0_0 : entity is "design_1_core_0_0,core,{}";
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of design_1_core_0_0 : entity is "design_1_core_0_0,core,{x_ipProduct=Vivado 2025.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=core,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,BUS_WIDTH=64,INSTR_MEM_LEN=15,INSTR_WIDTH=32,DATA_MEM_LEN=12,DATA_MEM_SUB_WIDTH=8}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of design_1_core_0_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of design_1_core_0_0 : entity is "module_ref";
end design_1_core_0_0;

architecture stub of design_1_core_0_0 is
  attribute syn_black_box : boolean;
  attribute black_box_pad_pin : string;
  attribute syn_black_box of stub : architecture is true;
  attribute black_box_pad_pin of stub : architecture is "sys_clk,running,rst,axi_if_pc[31:0],axi_if_instr[31:0],axi_instr_clk,axi_instr_en,axi_instr_we[3:0],axi_instr_addr[14:0],axi_instr_din[31:0],axi_instr_dout[31:0],axi_debug_col[2:0],axi_debug_row[60:0],axi_debug_col_dout[63:0],axi_data_clk,axi_data_en,axi_data_we,axi_data_addr[63:0],axi_data_din[7:0],axi_data_dout[7:0]";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of sys_clk : signal is "xilinx.com:signal:clock:1.0 sys_clk CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of sys_clk : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of sys_clk : signal is "XIL_INTERFACENAME sys_clk, FREQ_HZ 5000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of rst : signal is "xilinx.com:signal:reset:1.0 rst RST";
  attribute X_INTERFACE_MODE of rst : signal is "slave";
  attribute X_INTERFACE_PARAMETER of rst : signal is "XIL_INTERFACENAME rst, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of axi_instr_clk : signal is "xilinx.com:signal:clock:1.0 axi_instr_clk CLK";
  attribute X_INTERFACE_MODE of axi_instr_clk : signal is "slave";
  attribute X_INTERFACE_PARAMETER of axi_instr_clk : signal is "XIL_INTERFACENAME axi_instr_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of axi_data_clk : signal is "xilinx.com:signal:clock:1.0 axi_data_clk CLK";
  attribute X_INTERFACE_MODE of axi_data_clk : signal is "slave";
  attribute X_INTERFACE_PARAMETER of axi_data_clk : signal is "XIL_INTERFACENAME axi_data_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of stub : architecture is "core,Vivado 2025.1";
begin
end;
