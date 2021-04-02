`include "alu_func.v"
`include "add_sub.v"
`include "bitwise.v"
`include "shift.v"
`include "others.v"

module ALU #(parameter data_width = 16) (
	input [data_width - 1 : 0] A, 
	input [data_width - 1 : 0] B, 
	input [3 : 0] FuncCode,
       	output reg [data_width - 1: 0] C,
       	output reg OverflowFlag);
// Do not use delay in your implementation.

// You can declare any variables as needed.
wire [data_width - 1: 0] c1;
wire [data_width - 1: 0] c2;
wire [data_width - 1: 0] c3;
wire [data_width - 1: 0] c4;
wire of;

initial begin
	C = 0;
	OverflowFlag = 0;
end   	

add_sub add_sub0 (.A(A), .B(B), .FuncCode(FuncCode), .C(c1), .OverflowFlag(of));
bitwise bitwise0 (.A(A), .B(B), .FuncCode(FuncCode), .C(c2));
shift shift0 (.A(A), .FuncCode(FuncCode), .C(c3));
others others0 (.A(A), .FuncCode(FuncCode), .C(c4));

always @(*) begin
	if (FuncCode == `FUNC_ID || FuncCode == `FUNC_TCP || FuncCode == `FUNC_ZERO) 
		C <= c4;
	else if (FuncCode == `FUNC_LLS || FuncCode == `FUNC_LRS || FuncCode == `FUNC_ALS || FuncCode == `FUNC_ARS)
		C <= c3; 
	else if (FuncCode == `FUNC_ADD || FuncCode == `FUNC_SUB) begin
		C <= c1;
		OverflowFlag <= of;
	end
	else
		C <= c2;
end

endmodule

