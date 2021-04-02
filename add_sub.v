`include "alu_func.v"

module add_sub #(parameter data_width = 16) (
	input [data_width - 1 : 0] A, 
	input [data_width - 1 : 0] B, 
	input [3 : 0] FuncCode,
       	output reg [data_width - 1: 0] C,
       	output reg OverflowFlag);

	reg [data_width : 0] C_extend;
	wire [data_width-1 : 0] B_ab = ~B + 1;

	always @(*) begin
		if (FuncCode == `FUNC_ADD) begin
			C <= A+B;
			C_extend <= A+B;
			if ((A[data_width-1] == B[data_width-1]) && (C_extend[data_width] != C_extend[data_width-1]))
				OverflowFlag <= 1;
			else
				OverflowFlag <= 0;
		end
		else begin
			C <= A+ B_ab;
			C_extend <= A+ B_ab;
			if ((A[data_width-1] == B_ab[data_width-1]) && (C_extend[data_width] != C_extend[data_width-1]))
				OverflowFlag <= 1;
			else
				OverflowFlag <= 0;
		end
	end
endmodule
