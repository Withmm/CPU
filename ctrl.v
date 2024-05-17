// `include "ctrl_encode_def.v"


module ctrl(Op, Funct, Zero, 
            RegWrite, MemWrite,
            EXTOp, ALUOp, NPCOp, 
            ALUSrc, GPRSel, WDSel, LOADSel
            );
            
   input  [5:0] Op;       // opcode
   input  [5:0] Funct;    // funct
   input        Zero;
   
   output       RegWrite; // control signal for register write
   output       MemWrite; // control signal for memory write
   output       EXTOp;    // control signal to signed extension
   output [4:0] ALUOp;    // ALU opertion
   output [3:0] NPCOp;    // next pc operation
   output       ALUSrc;   // ALU source for B

   output [1:0] GPRSel;   // general purpose register selection
   output [1:0] WDSel;    // (register) write data selection
   output [3:0] LOADSel; // lw lb lbu ...
  // r format
   wire rtype  = ~|Op;
   wire i_add  = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]&~Funct[0]; // add
   wire i_sub  = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]&~Funct[0]; // sub
   wire i_and  = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]&~Funct[1]&~Funct[0]; // and
   wire i_or   = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]&~Funct[1]& Funct[0]; // or
   wire i_slt  = rtype& Funct[5]&~Funct[4]& Funct[3]&~Funct[2]& Funct[1]&~Funct[0]; // slt
   wire i_sltu = rtype& Funct[5]&~Funct[4]& Funct[3]&~Funct[2]& Funct[1]& Funct[0]; // sltu
   wire i_addu = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]& Funct[0]; // addu
   wire i_subu = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]& Funct[0]; // subu
   wire i_sll  = rtype&~Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]&~Funct[0]; // sll
   wire i_nor  = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]& Funct[1]& Funct[0]; // nor
   wire i_srl  = rtype&~Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]&~Funct[0]; // srl
   wire i_sllv = rtype&~Funct[5]&~Funct[4]&~Funct[3]& Funct[2]&~Funct[1]&~Funct[0]; // sllv
   wire i_jr   = rtype&~Funct[5]&~Funct[4]& Funct[3]&~Funct[2]&~Funct[1]&~Funct[0]; // jr
   wire i_jalr = rtype&~Funct[5]&~Funct[4]& Funct[3]&~Funct[2]&~Funct[1]& Funct[0]; // jalr
   wire i_xor  = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]& Funct[1]&~Funct[0]; // xor
   wire i_sra  = rtype&~Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]& Funct[0]; // sra
   wire i_srav = rtype&~Funct[5]&~Funct[4]&~Funct[3]& Funct[2]& Funct[1]& Funct[0]; // srav
  // i format
   wire i_addi = ~Op[5]&~Op[4]& Op[3]&~Op[2]&~Op[1]&~Op[0]; // addi
   wire i_ori  = ~Op[5]&~Op[4]& Op[3]& Op[2]&~Op[1]& Op[0]; // ori
   wire i_lw   =  Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]& Op[0]; // lw
   wire i_sw   =  Op[5]&~Op[4]& Op[3]&~Op[2]& Op[1]& Op[0]; // sw
   wire i_beq  = ~Op[5]&~Op[4]&~Op[3]& Op[2]&~Op[1]&~Op[0]; // beq
   wire i_lui  = ~Op[5]&~Op[4]& Op[3]& Op[2]& Op[1]& Op[0]; // lui
   wire i_slti = ~Op[5]&~Op[4]& Op[3]&~Op[2]& Op[1]&~Op[0]; // slti
   wire i_andi = ~Op[5]&~Op[4]& Op[3]& Op[2]&~Op[1]&~Op[0]; // andi
   wire i_lb   =  Op[5]&~Op[4]&~Op[3]&~Op[2]&~Op[1]&~Op[0]; // lb
   wire i_lbu  =  Op[5]&~Op[4]&~Op[3]& Op[2]&~Op[1]&~Op[0]; // lbu
   wire i_lh   =  Op[5]&~Op[4]&~Op[3]&~Op[2]&~Op[1]& Op[0]; // lh
   wire i_lhu  =  Op[5]&~Op[4]&~Op[3]& Op[2]&~Op[1]& Op[0]; // lhu
   wire i_sb   =  Op[5]&~Op[4]& Op[3]&~Op[2]&~Op[1]&~Op[0]; // sb
   wire i_sh   =  Op[5]&~Op[4]& Op[3]&~Op[2]&~Op[1]& Op[0]; // sh
  // j format
   wire i_j    = ~Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]&~Op[0];  // j
   wire i_jal  = ~Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]& Op[0];  // jal
   wire i_bne  = ~Op[5]&~Op[4]&~Op[3]& Op[2]&~Op[1]& Op[0];  // bne
  // generate control signals
  assign RegWrite   = rtype | i_lw | i_addi | i_ori | i_jal | i_lui | i_slti | i_andi | i_lb | i_lbu | i_lh | i_lhu; // register write
  
  assign MemWrite   = i_sw | i_sb | i_sh;                           // memory write
  assign ALUSrc     = i_lw | i_sw | i_addi | i_ori | i_lui | i_slti | i_andi | i_lb | i_lbu | i_lh | i_lhu | i_sb | i_sh;   // ALU B is from instruction immediate
  assign EXTOp      = i_addi | i_lw | i_sw | i_slti | i_andi | i_lb | i_lbu | i_lh | i_lhu | i_sb | i_sh;           // signed extension

  // GPRSel_RD   2'b00
  // GPRSel_RT   2'b01
  // GPRSel_31   2'b10
  assign GPRSel[0] = i_lw | i_addi | i_ori |i_lui | i_slti | i_andi | i_lb | i_lbu | i_lh | i_lhu;
  assign GPRSel[1] = i_jal;
  
  // WDSel_FromALU 2'b00
  // WDSel_FromMEM 2'b01
  // WDSel_FromPC  2'b10 
  assign WDSel[0] = i_lw | i_lb | i_lbu | i_lh | i_lhu;
  assign WDSel[1] = i_jal | i_jalr;

  // NPC_PLUS4   4'b000
  // NPC_BRANCH  4'b001
  // NPC_JUMP    4'b010
  // NPC_JR      4'b011
  // NPC_JALR    4'b100
  assign NPCOp[0] = (i_beq & Zero) | (i_bne &~Zero) | i_jr;
  assign NPCOp[1] = i_j | i_jal | i_jr;
  assign NPCOp[2] = i_jalr;
  assign NPCOp[3] = 0;
  // ALU_NOP   5'b000
  // ALU_ADD   5'b001
  // ALU_SUB   5'b010
  // ALU_AND   5'b011
  // ALU_OR    5'b100
  // ALU_SLT   5'b101
  // ALU_SLTU  5'b110
  // ALU_SLL   5'b111
  // ALU_NOR   5'b1000
  // ALU_LUI   5'b1001
  // ALU_SRL   5'b1010
  // ALU_SLLV  5'b1011
  // ALU_XOR   5'b1100
  // ALU_SRA   5'b1101
  // ALU_SRAV  5'b1110
  // ALU_LB    5'b1111
  assign ALUOp[0] = i_add | i_lw | i_sw | i_addi | i_and | i_andi | i_slt | i_slti | i_addu | i_sll | i_lui | i_sllv | i_sra | i_lb | i_lbu | i_lh | i_lhu | i_sb | i_sh;
  assign ALUOp[1] = i_sub | i_beq | i_and | i_andi | i_sltu | i_subu | i_sll | i_bne | i_srl | i_sllv | i_srav;
  assign ALUOp[2] = i_or | i_ori | i_slt | i_slti | i_sltu | i_sll | i_xor | i_sra | i_srav;
  assign ALUOp[3] = i_nor | i_lui | i_srl | i_sllv | i_xor | i_sra | i_srav;
  assign ALUOp[4] = 0;
  // lw     4'b0000
  // lb     4'b0001
  // lbu    4'b0010
  // lh     4'b0011
  // lhu    4'b0100
  // sb     4'b0101
  // sh     4'b0110
  assign LOADSel[0] = i_lb | i_lh | i_sb;
  assign LOADSel[1] = i_lbu | i_lh | i_sh;
  assign LOADSel[2] = i_lhu | i_sb | i_sh;
  assign LOADSel[3] = 0;
endmodule
