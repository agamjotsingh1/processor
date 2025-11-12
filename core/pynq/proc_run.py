from pynq import Overlay
from pynq.lib import AxiGPIO
import time

# Load your overlay
ol = Overlay("./design_1.bit")

rst_channel = ol.axi_rst.channel1
running_channel = ol.axi_running.channel1
pc_channel = ol.axi_if_pc.channel1
instr_channel = ol.axi_if_instr.channel1
data_bram = ol.axi_data_mem_controller
data_mmio = data_bram.mmio
instr_bram = ol.axi_instr_mem_controller
instr_mmio = instr_bram.mmio

# DEBUG
debug_addr_channel = ol.axi_debug_addr.channel1
debug_col_channel = ol.axi_debug_col.channel1
debug_row_channel = ol.axi_debug_row.channel1
debug_full_col_channel = ol.axi_debug_col_dout.channel1

def load_instructions(instr_str, clear_amt=100):
    for i in range(clear_amt):
        instr_mmio.array[i] = 0x0
        
    for index, line in enumerate(instr_str.strip().split('\n')):
        instr_mmio.array[index] = int(line.strip(), 16)
    
    time.sleep(1)

instr_str = """
"""
load_instructions(instr_str)

for i in range(16):
    print(f"Address {hex(i)}, Value: {hex(instr_mmio.read(4*i))}")

running_channel.write(1, 0xFFFFFFFF)
time.sleep(0.001)
rst_channel.write(1, 0xFFFFFFFF)
time.sleep(1.005)
print(f"PC: {hex(pc_channel.read())}, INSTR: {hex(instr_channel.read())}")
rst_channel.write(0, 0xFFFFFFFF)
print(f"PC: {hex(pc_channel.read())}, INSTR: {hex(instr_channel.read())}")
time.sleep(1)
for i in range(100):
    print(f"PC: {hex(pc_channel.read())}, INSTR: {hex(instr_channel.read())}")
running_channel.write(0, 0xFFFFFFFF)

for i in range(50):
    print(f"Address {hex(i)}, Value: {hex(data_mmio.array[i])}, COL: {hex(debug_full_col_channel.read())}")