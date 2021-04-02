`include "alu_func.v"

module shift #(parameter data_width = 16) (
	input [data_width - 1 : 0] A,
	input [3 : 0] FuncCode,
       	output reg [data_width - 1: 0] C);

	always @(*) begin
		if (FuncCode == `FUNC_LLS)
			C <= A<<1;
		else if (FuncCode == `FUNC_LRS)
			C <= A>>1;
		else if (FuncCode == `FUNC_ALS)
			C <= A<<<1;
		else
			C <= $signed (A)>>>1;
	end

endmodule
