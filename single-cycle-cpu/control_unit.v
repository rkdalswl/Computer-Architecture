`include "opcodes.v" 	   

module control_unit (instr, alu_src, reg_write, mem_read, mem_to_reg, mem_write, jp, jp_reg, branch, write_reg, pc_to_reg);
    input [15:0] instr;
    output reg alu_src; 
    output reg reg_write; 
    output reg mem_read;
    output reg mem_to_reg; 
    output reg mem_write; 
    output reg jp; 
    output reg jp_reg;
    output reg branch;
    output reg [1:0] write_reg;
    output reg pc_to_reg;

    initial begin
        alu_src <= 0;
        reg_write <= 0;
        mem_read <= 0;
        mem_to_reg <= 0;
        mem_write <= 0;
        jp <= 0;
        jp_reg <= 0;
        branch <= 0;
        write_reg <= 0;
        pc_to_reg <= 0;
    end

    wire [3:0] opcode;
    wire [5:0] func_code;
    assign opcode = instr[15:12];
    assign func_code = instr[5:0];

    always @(*) begin
        // alu_src is 1 when ADI_OP | ORI_OP | `LWD_OP | `SWD_OP | `BNE_OP | `BEQ_OP | `BGZ_OP | `BLZ_OP | 
        alu_src <= (opcode <= 4'd8)? 1 : 0;

        // reg_write
        reg_write <= ((opcode == `ALU_OP && func_code[3] == 0) || opcode == `ADI_OP || opcode == `ORI_OP || opcode == `LHI_OP || opcode == `LWD_OP);

        // mem_read is 1 when LWD
        mem_read <= (opcode == `LWD_OP)? 1 : 0;

        // mem_to_reg is 1 when LWD
        mem_to_reg <= (opcode == `LWD_OP)? 1 : 0;

        // mem_write is 1 when SWD
        mem_write <= (opcode == `SWD_OP)? 1 : 0;

        // jp is 1 when JMP, JAL (no save)
        jp <= (opcode == `JMP_OP || opcode == `JAL_OP)? 1 : 0;

        // jp_reg is 1 when JPR, JRL
        jp_reg <= ((opcode == `JPR_OP && func_code == `INST_FUNC_JPR) || (opcode == `JRL_OP && func_code == `INST_FUNC_JRL))? 1 : 0;

        // branch is 1
        branch <= (opcode == `BNE_OP || opcode == `BEQ_OP || opcode ==`BGZ_OP || opcode == `BLZ_OP)? 1 : 0;

        // write_reg
        if (opcode == `ADI_OP || opcode == `ORI_OP || opcode == `LHI_OP || opcode == `LWD_OP || opcode == `SWD_OP)
            write_reg <= 2'd0;
        else if (opcode == `JAL_OP || (opcode == `JRL_OP && func_code == `INST_FUNC_JRL))
            write_reg <= 2'd2;
        else //ALU_OP
            write_reg <= 2'd1;
        
        // pc_to_reg
        pc_to_reg <= (opcode == `JAL_OP || (opcode == `JRL_OP && func_code == `INST_FUNC_JRL))? 1 : 0;
    end

endmodule