#!/bin/sh

# compile the verilog module
iverilog -o output_files/spi_mux_test spi_mux.v tests/spi_mux.v

# simulate pls
vvp output_files/spi_mux_test
