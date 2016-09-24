This is my attempt to see how small I could make a useful processor. It has an
8 bit accumulator register and 256 memory locations, each which is 8 bits. This
is Harvard architecture: instructions are stored in a separate memory space.
Each instruction is 11 bits and has a 3 bit opcode and an 8 bit immediate
operand.

    +--------+--------------------+
    | opcode |      operand       |
    +--------+--------------------+

These are the instructions:

| Opcode | Mnemonic | Description |
|----|----|----|
| 000 | ADD [location]   | Add the value at the memory location to the accumulator |
| 001 | SUB [location]   | Subtract the value at the memory location from the accumulator and store the result in the accumulator |
| 110 | AND [location]   | Logical AND of memory operand with accumulator.  Store result in accumulator. |
| 010 | LDI [value]      | Load an immediate value into the accumulator |
| 011 | ST [location]    | Store the current value of the accumulator at the memory address specified. |
| 100 | BL [target]      | If the accumulator is less than zero, branch to the target. |
| 101 | INDEX [location] | Read the the value from a memory location and add it to the memory address of the next instruction. |

The `res` keyword reserves a range of addresses in data memory and assigns a
variable name to it, which can be used as an instruction operand

    res <variable_name> [, <number of locations> ]

For example:

    res counterval
    add counterval

Labels are declared using a colon. The name can be used as a branch target:

    topofloop:
        bl topofloop

To run in simulation (requires iverilog and python 2.7)

    ./run

To run on FPGA, first compile the program, open tinyproc.qpf in
(Quartus)[https://www.altera.com/downloads/download-center.html]

    python ./compile.py < [source file] > program.hex

The design must be resynthesized whenever the program is changed.
