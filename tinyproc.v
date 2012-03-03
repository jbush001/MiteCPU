module tinyproc(input clk, output reg[7:0] result = 0);
	reg[9:0] program_mem[0:255];
	reg[9:0] instr = 0;
	reg[7:0] data_mem[0:255];
	reg[7:0] ip = 8'hff;
	reg[7:0] accumulator = 0;
	integer i;

	initial
	begin
		$readmemh("program.hex", program_mem);
		for (i = 0; i < 255; i = i + 1) data_mem[i] = 0;
	end

	wire[7:0] ip_nxt = (instr[9:8] == 2'b11 && (accumulator[7] || accumulator == 0))	// ble
		? instr[7:0] : ip + 1;
	
	always @(posedge clk)
	begin
		ip <= ip_nxt;
		instr <= program_mem[ip_nxt];
		case (instr[9:8])
			2'b00: accumulator <= instr[7:0];	// Load immediate
			2'b01: accumulator <= accumulator - data_mem[instr[7:0]]; // Sub
			2'b10: // Store
			begin	
				data_mem[instr[7:0]] = accumulator;
				if (instr[7:0] == 0) result <= accumulator;
			end
		endcase
	end
endmodule
