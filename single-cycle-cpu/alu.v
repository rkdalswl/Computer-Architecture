`include "opcodes.v"

module alu (alu_input_1, alu_input_2, func_code, alu_output);
	input [15:0] alu_input_1;
	input [15:0] alu_input_2;
	input [2:0] func_code;
	output reg [15:0] alu_output;

	always @(*) begin
		if (func_code == `FUNC_ADD) begin
			alu_output <= alu_input_1 + alu_input_2;
		end
		else if (func_code == `FUNC_SUB) begin
			alu_output <= alu_input_1 - alu_input_2;
		end
		else if (func_code == `FUNC_AND) begin
			alu_output <= alu_input_1 & alu_input_2;
		end
		else if (func_code == `FUNC_ORR) begin
			alu_output <= alu_input_1 | alu_input_2;
		end
		else if (func_code == `FUNC_NOT) begin
			alu_output <= ~alu_input_1;
		end
		else if (func_code == `FUNC_TCP) begin
			alu_output <= ~alu_input_1 + 1;
		end
		else if (func_code == `FUNC_SHL) begin
			alu_output <= alu_input_1 <<< 1;
		end
		else if (func_code == `FUNC_SHR) begin
			alu_output <= $signed (alu_input_1) >>> 1;
		end
	end
endmodule