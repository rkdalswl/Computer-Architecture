		  
// Opcode
`define	ALU_OP	4'd15
`define	ADI_OP	4'd4    //I : rt = rs + sign-extend(imm)
`define	ORI_OP	4'd5    //I : rt = rs | zero-extend(imm)
`define	LHI_OP	4'd6    //I : rt = imm << 8
`define	LWD_OP	4'd7   	//I : rt = M[ rs + sign-extend(imm) ]  
`define	SWD_OP	4'd8    //I : M[ rs + sign-extend(imm) ] = rt
`define	BNE_OP	4'd0    //I : if rs != rt, then pc += sign-extend(imm)  (Branch Not Equal)
`define	BEQ_OP	4'd1    //I : if rs == rt, then pc += sign-extend(imm) (Branch EQual)
`define BGZ_OP	4'd2    //I : if rs > 0, then pc += sign-extend(imm) (Branch Greater than Zero)
`define BLZ_OP	4'd3    //I : if rs < 0, then pc += sign-extend(imm)  (Branch Less than Zero)
`define	JMP_OP	4'd9    //J : pc = {pc[15:12], off[11:0]} (jump and no return)
`define JAL_OP	4'd10   //J : $2 = pc, pc = {pc[15:12], off[11:0]} (jump and return to origin)
`define	JPR_OP	4'd15   //R : pc = rs
`define	JRL_OP	4'd15   //R : $2 = pc, pc = rs

// ALU Function Codes
`define	FUNC_ADD	3'b000  // rd = rs+rt 
`define	FUNC_SUB	3'b001  // rd = rs + ~rt + 1			 
`define	FUNC_AND	3'b010  // rd = rs & rt
`define	FUNC_ORR	3'b011  // rd = rs | rt			    
`define	FUNC_NOT	3'b100  // rd = ~rs
`define	FUNC_TCP	3'b101 // rd = ~rs+1
`define	FUNC_SHL	3'b110 // rd = rs << 1
`define	FUNC_SHR	3'b111 // rd = rs >> 1

// ALU instruction function codes
`define INST_FUNC_ADD 6'd0
`define INST_FUNC_SUB 6'd1
`define INST_FUNC_AND 6'd2
`define INST_FUNC_ORR 6'd3
`define INST_FUNC_NOT 6'd4
`define INST_FUNC_TCP 6'd5
`define INST_FUNC_SHL 6'd6
`define INST_FUNC_SHR 6'd7
`define INST_FUNC_JPR 6'd25
`define INST_FUNC_JRL 6'd26

`define	WORD_SIZE	16			
`define	NUM_REGS	4