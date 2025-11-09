transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+div_unsigned_gen  -L xil_defaultlib -L xpm -L xbip_utils_v3_0_14 -L axi_utils_v2_0_10 -L xbip_pipe_v3_0_10 -L xbip_dsp48_wrapper_v3_0_7 -L mult_gen_v12_0_23 -L floating_point_v7_0_25 -L div_gen_v5_1_24 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.div_unsigned_gen xil_defaultlib.glbl

do {div_unsigned_gen.udo}

run 1000ns

endsim

quit -force
