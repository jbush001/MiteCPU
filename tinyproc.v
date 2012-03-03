module tinyproc(input clk, output [7:0] result);
	reg[9:0] instruction_mem[0:255];
	reg[7:0] data_mem[0:255];
	reg[7:0] instruction_pointer = 0;
	reg[7:0] accumulator = 0;
	integer i;

	initial
	begin
		$readmemh("program.hex", instruction_mem);
		for (i = 0; i < 255; i = i + 1) data_mem[i] = 0;
	end

	wire[9:0] instruction = instruction_mem[instruction_pointer];
	assign result = data_mem[0];
	
	always @(posedge clk)
	begin
		case (instruction[9:8])
			2'b00: accumulator <= instruction[7:0];	// Load immediate
			2'b01: accumulator <= accumulator - data_mem[instruction[7:0]]; // Sub
			2'b10: data_mem[instruction[7:0]] = accumulator; // Store
		endcase

		if (instruction[9:8] == 2'b11 && (accumulator[7] || accumulator == 0)) // ble
			instruction_pointer <= instruction[7:0];
		else
			instruction_pointer <= instruction_pointer + 1;
	end
endmodule
