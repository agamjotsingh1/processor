vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xpm
vlib questa_lib/msim/xbip_utils_v3_0_14
vlib questa_lib/msim/axi_utils_v2_0_10
vlib questa_lib/msim/xbip_pipe_v3_0_10
vlib questa_lib/msim/xbip_dsp48_wrapper_v3_0_7
vlib questa_lib/msim/mult_gen_v12_0_23
vlib questa_lib/msim/floating_point_v7_0_25
vlib questa_lib/msim/div_gen_v5_1_24
vlib questa_lib/msim/xil_defaultlib

vmap xpm questa_lib/msim/xpm
vmap xbip_utils_v3_0_14 questa_lib/msim/xbip_utils_v3_0_14
vmap axi_utils_v2_0_10 questa_lib/msim/axi_utils_v2_0_10
vmap xbip_pipe_v3_0_10 questa_lib/msim/xbip_pipe_v3_0_10
vmap xbip_dsp48_wrapper_v3_0_7 questa_lib/msim/xbip_dsp48_wrapper_v3_0_7
vmap mult_gen_v12_0_23 questa_lib/msim/mult_gen_v12_0_23
vmap floating_point_v7_0_25 questa_lib/msim/floating_point_v7_0_25
vmap div_gen_v5_1_24 questa_lib/msim/div_gen_v5_1_24
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xpm -64 -incr -mfcu  -sv "+incdir+../../../../../../../Xilinx/2025.1/data/rsb/busdef" \
"/home/agamubuntu/Xilinx/2025.1/Vivado/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93  \
"/home/agamubuntu/Xilinx/2025.1/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xbip_utils_v3_0_14 -64 -93  \
"../../../ipstatic/hdl/xbip_utils_v3_0_vh_rfs.vhd" \

vcom -work axi_utils_v2_0_10 -64 -93  \
"../../../ipstatic/hdl/axi_utils_v2_0_vh_rfs.vhd" \

vcom -work xbip_pipe_v3_0_10 -64 -93  \
"../../../ipstatic/hdl/xbip_pipe_v3_0_vh_rfs.vhd" \

vcom -work xbip_dsp48_wrapper_v3_0_7 -64 -93  \
"../../../ipstatic/hdl/xbip_dsp48_wrapper_v3_0_vh_rfs.vhd" \

vcom -work mult_gen_v12_0_23 -64 -93  \
"../../../ipstatic/hdl/mult_gen_v12_0_vh_rfs.vhd" \

vcom -work floating_point_v7_0_25 -64 -93  \
"../../../ipstatic/hdl/floating_point_v7_0_vh_rfs.vhd" \

vcom -work div_gen_v5_1_24 -64 -93  \
"../../../ipstatic/hdl/div_gen_v5_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93  \
"../../../../riscv.gen/sources_1/ip/div_signed_gen/sim/div_signed_gen.vhd" \


vlog -work xil_defaultlib \
"glbl.v"

