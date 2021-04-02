`include "opcodes.v"

module bit_extender (
    input [3:0] opcode,
    input [7:0] imm,
    output reg [15:0] extend_imm
    );

    always @(*) begin
        if (opcode == `ORI_OP)
            extend_imm <= {{8{1'b0}}, imm};
        else if (opcode == `LHI_OP)
            extend_imm <= {imm, {8{1'b0}}};
        else //(opcode == `ADI_OP | `LWD_OP | `SWD_OP | `BNE_OP | `BEQ_OP | `BGZ_OP | `BLZ_OP)
            extend_imm <= {{8{imm[7]}}, imm};
    end
endmodule