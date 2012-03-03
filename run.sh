iverilog -o sim.vvp tinyproc.v testbench.v
python assemble.py < test.asm > program.hex
vvp sim.vvp
