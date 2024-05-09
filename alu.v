`include "ctrl_encode_def.v"

module alu(A, B, ALUOp, C, Zero, shamt);

   input  signed [31:0] A, B;
   input         [3:0]  ALUOp;
   input         [4:0] shamt;
   output signed [31:0] C;
   output Zero;
   
   reg [31:0] C;
   integer    i;
       
   always @( * ) begin
      case ( ALUOp )
          `ALU_NOP:  C = A;                          // NOP
          `ALU_ADD:  C = A + B;                      // ADD
          `ALU_SUB:  C = A - B;                      // SUB
          `ALU_AND:  C = A & B;                      // AND/ANDI
          `ALU_OR:   C = A | B;                      // OR/ORI
          `ALU_SLT:  C = (A < B) ? 32'd1 : 32'd0;    // SLT/SLTI
          `ALU_SLTU: C = ({1'b0, A} < {1'b0, B}) ? 32'd1 : 32'd0;
          `ALU_SLL:  C = B << shamt;                 //SLL
          `ALU_NOR:  C = ~(A | B);                   //NOR
          `ALU_LUI:  C = B << 16;                    //LUI
          `ALU_SRL:  C = B >> shamt;                 //SRL
          `ALU_SLLV: C = B << A[4:0];                // SLLV
          `ALU_XOR:  C = A ^ B;                      // XOR
          `ALU_SRA:  C = B >>> shamt;                           // SRA
          default:   C = A;                          // Undefined
      endcase
   end // end always
   
   assign Zero = (C == 32'b0);

endmodule
    
