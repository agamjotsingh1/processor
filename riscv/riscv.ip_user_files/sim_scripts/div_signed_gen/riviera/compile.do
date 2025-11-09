transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xpm
vlib riviera/xbip_utils_v3_0_14
vlib riviera/axi_utils_v2_0_10
vlib riviera/xbip_pipe_v3_0_10
vlib riviera/xbip_dsp48_wrapper_v3_0_7
vlib riviera/mult_gen_v12_0_23
vlib riviera/floating_point_v7_0_25
vlib riviera/div_gen_v5_1_24
vlib riviera/xil_defaultlib

vmap xpm riviera/xpm
vmap xbip_utils_v3_0_14 riviera/xbip_utils_v3_0_14
vmap axi_utils_v2_0_10 riviera/axi_utils_v2_0_10
vmap xbip_pipe_v3_0_10 riviera/xbip_pipe_v3_0_10
vmap xbip_dsp48_wrapper_v3_0_7 riviera/xbip_dsp48_wrapper_v3_0_7
vmap mult_gen_v12_0_23 riviera/mult_gen_v12_0_23
vmap floating_point_v7_0_25 riviera/floating_point_v7_0_25
vmap div_gen_v5_1_24 riviera/div_gen_v5_1_24
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xpm  -incr "+incdir+../../../../../../../Xilinx/2025.1/data/rsb/busdef" -l xpm -l xbip_utils_v3_0_14 -l axi_utils_v2_0_10 -l xbip_pipe_v3_0_10 -l xbip_dsp48_wrapper_v3_0_7 -l mult_gen_v12_0_23 -l floating_point_v7_0_25 -l div_gen_v5_1_24 -l xil_defaultlib \
"/home/agamubuntu/Xilinx/2025.1/Vivado/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  -incr \
"/home/agamubuntu/Xilinx/2025.1/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xbip_utils_v3_0_14 -93  -incr \
"../../../ipstatic/hdl/xbip_utils_v3_0_vh_rfs.vhd" \

vcom -work axi_utils_v2_0_10 -93  -incr \
"../../../ipstatic/hdl/axi_utils_v2_0_vh_rfs.vhd" \

vcom -work xbip_pipe_v3_0_10 -93  -incr \
"../../../ipstatic/hdl/xbip_pipe_v3_0_vh_rfs.vhd" \

vcom -work xbip_dsp48_wrapper_v3_0_7 -93  -incr \
"../../../ipstatic/hdl/xbip_dsp48_wrapper_v3_0_vh_rfs.vhd" \

vcom -work mult_gen_v12_0_23 -93  -incr \
"../../../ipstatic/hdl/mult_gen_v12_0_vh_rfs.vhd" \

vcom -work floating_point_v7_0_25 -93  -incr \
"../../../ipstatic/hdl/floating_point_v7_0_vh_rfs.vhd" \

vcom -work div_gen_v5_1_24 -93  -incr \
"../../../ipstatic/hdl/div_gen_v5_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../../riscv.gen/sources_1/ip/div_signed_gen/sim/div_signed_gen.vhd" \


vlog -work xil_defaultlib \
"glbl.v"

