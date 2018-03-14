#!/bin/bash
set -e
echo "Vivado Modelsim 2016.4"

export VPI_USER_H_DIR=/home/chingyang/Xilinx/Vivado/2016.4/data/xsim/include/
export PSLVER=8

rm -rf xsim.dir
rm -rf xvlog.*
rm -rf xvhdl.*
rm -rf xsc.*
rm -rf xelab.*

cd pslse && make
cd ..

echo "Library directory of CAPI"
xvhdl -nolog -2008   ../accelerator/lib/functions.vhd
xvhdl -nolog -2008   ../accelerator/lib/psl.vhd
xvhdl -nolog -2008   ../accelerator/lib/wed.vhd


echo "Package direcor of CAPI"
xvhdl -nolog -2008   ../accelerator/pkg/dma_package.vhd
xvhdl -nolog -2008   ../accelerator/pkg/mmio_package.vhd
xvhdl -nolog -2008   ../accelerator/pkg/cu_package.vhd
xvhdl -nolog -2008   ../accelerator/pkg/frame_package.vhd
xvhdl -nolog -2008   ../accelerator/pkg/control_package.vhd

echo "RTL directory of CAPI"
xvhdl -nolog -2008   ../accelerator/rtl/ram.vhd
xvhdl -nolog -2008   ../accelerator/rtl/mmio.vhd
xvhdl -nolog -2008   ../accelerator/rtl/fifo.vhd
xvhdl -nolog -2008   ../accelerator/rtl/cu.vhd
xvhdl -nolog -2008   ../accelerator/rtl/control.vhd
xvhdl -nolog -2008   ../accelerator/rtl/dma.vhd
xvhdl -nolog -2008   ../accelerator/rtl/frame.vhd
xvhdl -nolog -2008   ../accelerator/rtl/afu.vhd

echo "Creating the db file for CAPI"
#xvlog -sv sim/pslse/afu_driver/verilog/top.v
xvlog  -nolog -d PSL$PSLVER -sv pslse/afu_driver/verilog/top.v

echo "Elaborate the design"

xelab -nolog -d PSL$PSLVER -timescale 1ns/1ps -svlog pslse/afu_driver/verilog/top.v -sv_root pslse/afu_driver/src/ -sv_lib libdpi -debug all

xsim -nolog -g work.top



