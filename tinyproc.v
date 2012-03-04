module tinyproc(input clk, output reg[7:0] result = 0);
	reg[10:0] program_mem[0:255];
	reg[10:0] instr = 0;
	reg[7:0] data_mem[0:255];
	reg[7:0] ip = 8'hff;
	reg[7:0] accumulator = 0;
	integer i;

	initial
	begin
		$readmemh("program.hex", program_mem);
		for (i = 0; i < 255; i = i + 1) data_mem[i] = 0;
	end

	wire[7:0] ip_nxt = (instr[10:8] == 3'b100 && accumulator[7]) 	// bl
		? instr[7:0] : ip + 1;
	wire[7:0] memory_operand = data_mem[instr[7:0]];
	
	always @(posedge clk)
	begin
		ip <= ip_nxt;
		instr <= program_mem[ip_nxt];
		case (instr[10:8])
			3'b000: accumulator <= accumulator + memory_operand; // Add
			3'b001: accumulator <= accumulator - memory_operand; // Sub
			3'b010: accumulator <= instr[7:0];	// Load immediate
			3'b011: // Store
			begin	
				data_mem[instr[7:0]] <= accumulator;
				if (instr[7:0] == 0) result <= accumulator;
			end
		endcase
	end
endmodule
