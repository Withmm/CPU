// NPC control signal
`define NPC_PLUS4   4'b0000
`define NPC_BRANCH  4'b0001
`define NPC_JUMP    4'b0010
`define NPC_JR      4'b0011
`define NPC_JALR    4'b0100


// ALU control signal
`define ALU_NOP   5'b000 
`define ALU_ADD   5'b001
`define ALU_SUB   5'b010 
`define ALU_AND   5'b011
`define ALU_OR    5'b100
`define ALU_SLT   5'b101
`define ALU_SLTU  5'b110
`define ALU_SLL   5'b111
`define ALU_NOR   5'b1000
`define ALU_LUI   5'b1001
`define ALU_SRL   5'b1010
`define ALU_SLLV  5'b1011
`define ALU_XOR   5'b1100
`define ALU_SRA   5'b1101
`define ALU_SRAV  5'b1110
