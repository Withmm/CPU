// NPC control signal
`define NPC_PLUS4   2'b00
`define NPC_BRANCH  2'b01
`define NPC_JUMP    2'b10


// ALU control signal
`define ALU_NOP   4'b000 
`define ALU_ADD   4'b001
`define ALU_SUB   4'b010 
`define ALU_AND   4'b011
`define ALU_OR    4'b100
`define ALU_SLT   4'b101
`define ALU_SLTU  4'b110
`define ALU_SLL   4'b111
`define ALU_NOR   4'b1000
`define ALU_LUI   4'b1001
`define ALU_SRL   4'b1010