vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xpm
vlib questa_lib/msim/blk_mem_gen_v8_4_11
vlib questa_lib/msim/xil_defaultlib

vmap xpm questa_lib/msim/xpm
vmap blk_mem_gen_v8_4_11 questa_lib/msim/blk_mem_gen_v8_4_11
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xpm -64 -incr -mfcu  -sv "+incdir+../../../../../../../Xilinx/2025.1/data/rsb/busdef" \
"/home/agamubuntu/Xilinx/2025.1/Vivado/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93  \
"/home/agamubuntu/Xilinx/2025.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work blk_mem_gen_v8_4_11 -64 -incr -mfcu  "+incdir+../../../../../../../Xilinx/2025.1/data/rsb/busdef" \
"../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../../../../Xilinx/2025.1/data/rsb/busdef" \
"../../../../riscv.gen/sources_1/ip/instr_mem_gen/sim/instr_mem_gen.v" \


vlog -work xil_defaultlib \
"glbl.v"

