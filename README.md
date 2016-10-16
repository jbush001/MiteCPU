# Introduction

This is my attempt to see how small I could make a useful processor.
It is Harvard architecture: instructions and data are stored in
separate memories. Data memory is 8 bits wide and has 256 locations.
Instruction memory is 11 bits wide. Each instruciton has 11 bits:
a 3 bit opcode and 8 bit operand. Here are the opcodes:

| Opcode | Mnemonic | Description |
|----|----|----|
| 000 | ADD [location]   | Add the value at the memory location referenced by the operand to the accumulator and store the result back into the accumulator |
| 001 | SUB [location]   | Subtract memory location from the accumulator and store the result in the accumulator |
| 110 | AND [location]   | Perform logical AND of memory location with accumulator and store result in accumulator. |
| 010 | LDI [value]      | Copy operand value into accumulator |
| 011 | ST [location]    | Store the current value of the accumulator at the memory location |
| 100 | BL [target]      | If the accumulator is less than zero, branch to the target PC. |
| 101 | INDEX [location] | Read the the value from a memory location and add it to the memory address of the next instruction. |

Labels are declared using a colon. The name can be used as a branch target:

    topofloop:
        bl topofloop

The `res` keyword reserves a range of addresses in data memory and assigns a
variable name to it, which can be used as an instruction operand

    res <variable_name> [, <number of locations> ]

For example:

    res counterval
    add counterval

# Running

**Prerequisites:**

- [Icarus Verilog](http://iverilog.icarus.com/)
- Python 2.7


To run in simulation:

    ./run

This will load the program test.asm

To run on FPGA, first compile the program, open tinyproc.qpf in
(Quartus)[https://www.altera.com/downloads/download-center.html]

    python ./compile.py < [source file] > program.hex

The design must be resynthesized whenever the program is changed.
