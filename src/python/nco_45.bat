del nco_45.vvp nco_45.vcd nco_45.err
iverilog -onco_45.vvp nco_45.v nco_rom.v 2> nco_45.err
vvp nco_45.vvp 2>> nco_45.err
gtkwave nco_45.vcd

