del cordic.vvp cordic.vcd cordic.err
iverilog -ocordic.vvp cordic.v 2> cordic.err
vvp cordic.vvp 2>> cordic.err
gtkwave cordic.vcd

