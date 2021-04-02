`include "opcodes.v"

module alu_control(instr, func_code);
    input [15:0] instr;
    output reg [2:0] func_code;

    wire [3:0] opcode;
    assign opcode = instr[15:12];

    always @(*) begin
        if(opcode == `ADI_OP || opcode == `LWD_OP ||  opcode == `SWD_OP)
            func_code <= `FUNC_ADD;
        else if (opcode == `ORI_OP)
            func_code <= `FUNC_ORR;
        else //opcode == `ALU_OP
            func_code <= instr[2:0];
    end
endmodule