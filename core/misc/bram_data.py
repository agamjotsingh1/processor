import random

# --- Configuration ---
FILE_NAME = "bram_data.coe"
BRAM_DEPTH = 2048
DATA_WIDTH = 32
RADIX = 16
HEX_FORMAT = f'0{DATA_WIDTH // 4}X'

data = """00000013,
00a00093;"""

data = """00000013,
00a00093,
01400113,
002081b3,
03200213,
402202b3,
00f00313,
006273b3,
0020e433,
0020c4b3,
00131533,
06400593,
00b0a633,
123456b7,
fff00713,
00231793;"""

with open(FILE_NAME, 'w') as f:
    # Write the COE file header
    f.write(f"memory_initialization_radix={RADIX};\n")
    f.write("memory_initialization_vector=\n")

    f.write(data)

    '''
    # Generate and write random data
    for i in range(BRAM_DEPTH):
        # Generate a random integer in the 32-bit range
        # rand_val = random.randint(0, (1 << DATA_WIDTH) - 1)
        
        # Format as a padded hexadecimal string (e.g., 'A0E1B5C9')
        hex_string = format(i, HEX_FORMAT)
        
        # Use a semicolon for the last entry, comma for all others
        terminator = ';\n' if (i == BRAM_DEPTH - 1) else ',\n'
        
        f.write(f"{hex_string}{terminator}")
    '''

