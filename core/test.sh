#!/bin/bash

# Check if name argument is provided
if [ $# -ne 2 ]; then
    echo "Error: Incorrect Usage"
    echo "Usage: $0 <module> <submodule>"
    exit 1
fi

# Get the module name from the first argument
mod="$1"
submod="$2"

# Create build directory if it doesn't exist
mkdir -p ./build
mkdir -p ./build/${mod}

# Check existence of files
if [ ! -f ./${mod}/${submod}.v ]; then
    echo "Design source file not found!"
    exit 1
fi

if [ ! -f ./tb/${mod}/${submod}_tb.v ]; then
    echo "Testbench file not found!"
    exit 1
fi

# Execute iverilog command
iverilog -g2005-sv -o ./build/${mod}/${submod}.vvp ./tb/${mod}/${submod}_tb.v ./${mod}/${submod}.v

# Check if compilation was successful
if [ $? -eq 0 ]; then
    echo "Successfully compiled ${submod} to ./build/${mod}/${submod}.vvp"
else
    echo "Compilation failed for ${mod}/${submod}"
    exit 1
fi

vvp ./build/${mod}/${submod}.vvp