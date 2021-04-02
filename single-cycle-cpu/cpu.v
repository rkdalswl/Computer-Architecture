`include "opcodes.v"
`include "register_file.v"
`include "alu.v"
`include "control_unit.v"
`include "bit_extender.v"
`include "alu_control.v"

module cpu (readM, writeM, address, data, ackOutput, inputReady, reset_n, clk);
	output reg readM;									
	output reg writeM;								
	output [15:0] address;
	inout [15:0] data;		
	input ackOutput;								
	input inputReady;								
	input reset_n;									
	input clk;

	wire alu_src, reg_write, mem_read, mem_to_reg, mem_write, jp, jp_reg, branch, pc_to_reg;
	wire [1:0] write_reg_ctr, write_reg;
	wire [2:0] func_code;
	wire [15:0] read_out1, read_out2, extend_imm, alu_input_2, alu_result, tmp_write_data, write_data;

	reg [15:0] pc, pc_next, instr, mem_read_data;
	reg [3:0] opcode;
	reg [1:0] rs, rt, rd;
	reg [7:0] imm;
	reg [11:0] tar_address;

	initial begin
		pc <= 0;
	end

	// fetch instruction
	always @(posedge inputReady) begin
		readM <= 0;
		if (clk) begin // fetch instruction when clk is 1
			instr <= data;
			opcode <= data[15:12];
			rs <= data[11:10];
			rt <= data[9:8];
			rd <= data[7:6];
			imm <= data[7:0];
			tar_address <= data[11:0];
		end
		else mem_read_data <= data; // fetch read_data from memory when clk is 0
	end

	// pc update : calculate pc_next and update pc by pc_next when clk is 0 -> 1
	always @(*) begin
		if ((opcode == `BNE_OP && read_out1 != read_out2) || 
		(opcode == `BEQ_OP && read_out1 == read_out2) || 
		(opcode == `BGZ_OP && read_out1 > 0) || 
		(opcode == `BLZ_OP && read_out1 < 0)) 
			pc_next <= pc + 1 + extend_imm;
		else if (jp == 1)
			pc_next <= {pc[15:12], tar_address};
		else if (jp_reg == 1)
			pc_next <= read_out1;
		else
			pc_next <= pc + 1;
	end

	always @(posedge clk) begin
		if (reset_n) begin
			readM <= 1;
			pc <= pc_next;
		end
	end

	// calculate control signal for components of datapath
	control_unit control (instr, alu_src, reg_write, mem_read, mem_to_reg, mem_write, jp, jp_reg, branch, write_reg_ctr, pc_to_reg);

	// read data from register 
	register_file register (read_out1, read_out2, rs, rt, write_reg, write_data, reg_write, clk, reset_n);

	// alu 
	bit_extender extender (opcode, imm, extend_imm);
	assign alu_input_2 = (alu_src)? extend_imm : read_out2;
	alu_control ALU_control (instr, func_code);
	alu ALU (read_out1, alu_input_2, func_code, alu_result);

	// access to memory
	assign address = clk? pc : alu_result;
	assign data = (readM || inputReady)? 16'dz : read_out2;

	always @(negedge clk) begin //send signal to memory when clk is 1->0
		readM <= mem_read;
		writeM <= mem_write;
	end

	always @(posedge ackOutput) begin
		writeM <= 0;
	end

	// write to register
	assign write_reg = (write_reg_ctr == 2'd0)? rt : (write_reg_ctr == 2'd1)? rd : 2'b10;
	assign tmp_write_data = (mem_to_reg)? mem_read_data : alu_result;
	assign write_data = pc_to_reg ? (pc + 1) : (opcode == `LHI_OP)? extend_imm : tmp_write_data; 

	// reset
	always @(negedge reset_n) begin
		pc_next <= 0;
	end
																												
endmodule
