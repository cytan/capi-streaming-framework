if { [info exists 1] !=  1 } {
    puts "Please pass in the PSLVER as a number"
    exit
} else {
    set PSLVER $1
}

if { $PSLVER != 8 && $PSLVER != 9 } {
    puts "Invalid PSLVER!"
    exit
}

# recompile
proc r  {} {

  global PSLVER

  # compile vhdl files

  # compile libs
  echo "Compiling libs"
  vcom -2008 -quiet ../accelerator/lib/functions.vhd
  vcom -2008 -quiet ../accelerator/lib/psl.vhd
  vcom -2008 -quiet ../accelerator/lib/wed.vhd

  # compile packages
  echo "Compiling packages"
  vcom -2008 -quiet ../accelerator/pkg/frame_package.vhd
  vcom -2008 -quiet ../accelerator/pkg/mmio_package.vhd
  vcom -2008 -quiet ../accelerator/pkg/dma_package.vhd
  vcom -2008 -quiet ../accelerator/pkg/cu_package.vhd
  vcom -2008 -quiet ../accelerator/pkg/control_package.vhd

  # compile rtl
  echo "Compiling rtl"
  vcom -2008 -quiet ../accelerator/rtl/ram.vhd
  vcom -2008 -quiet ../accelerator/rtl/fifo.vhd
  vcom -2008 -quiet ../accelerator/rtl/dma.vhd
  vcom -2008 -quiet ../accelerator/rtl/cu.vhd
  vcom -2008 -quiet ../accelerator/rtl/control.vhd
  vcom -2008 -quiet ../accelerator/rtl/mmio.vhd
  vcom -2008 -quiet ../accelerator/rtl/frame.vhd
  vcom -2008 -quiet ../accelerator/rtl/afu.vhd

  # compile verilog files

  # compile top level
  # -sv is needed because modelsim doesn't recognise import "dpi-c"
  # as valid for v files
  echo "Compiling top level"
  vlog -sv   -quiet +define+PSL$PSLVER pslse/afu_driver/verilog/top.v

}

# simulate
proc s  {} {
  vsim -t ns -novopt -c -sv_lib pslse/afu_driver/src/libdpi +nowarnTSCALE work.top
  view wave
  radix h
  log * -r
  do wave.do
  view structure
  view signals
  view wave
  run -all
}

# shortcut for recompilation + simulation
proc rs {} {
  r
  s
}

# init libs
vlib work
vmap work work

# automatically recompile on first call
r
