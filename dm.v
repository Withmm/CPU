
// data memory
module dm(clk, DMWr, LOADSel, byte, addr, din, dout);
    input          clk;
    input          DMWr;
    input  [8:2]   addr;
    input  [31:0]  din;
    input  [3:0]   LOADSel;
    input  [1:0]   byte;
    output [31:0]  dout;

    reg [31:0] dmem[127:0];
    wire [31:0] addrByte;
    reg [31:0] tmp_out;
    wire [31:0] tmp;
    assign addrByte = addr<<2;
    assign tmp = dmem[addrByte[8:2]];
    always @(posedge clk) begin
      if (DMWr) begin
        case (LOADSel)
        4'b0101: begin // sb
          case (byte) 
            2'b00: dmem[addrByte[8:2]][7:0] = din[7:0];
            2'b01: dmem[addrByte[8:2]][15:8] = din[7:0];
            2'b10: dmem[addrByte[8:2]][23:16] = din[7:0];
            2'b11: dmem[addrByte[8:2]][31:24] = din[7:0];
            default: $display("byte error");
          endcase
          /*
          $display("byte = 0x%8X", byte);
          $display("din = 0x%8X", din[7:0]);
          $display("dmem[0x%8X] = 0x%8X,", addrByte, dmem[addrByte[8:2]]); 
          */
        end
        4'b0110: begin // sh
          case (byte) 
            2'b00: dmem[addrByte[8:2]][15:0] = din[15:0];
            2'b01: $display("sh: error");
            2'b10: dmem[addrByte[8:2]][31:16] = din[31:16];
            2'b11: $display("sh: error");
            default: $display("byte error");
          endcase
          /*
          $display("byte = 0x%8X", byte);
          $display("din = 0x%8X", din[15:0]);
          $display("dmem[0x%8X] = 0x%8X,", addrByte, dmem[addrByte[8:2]]); 
          */
        end
        default: begin 
          dmem[addrByte[8:2]] <= din;
          $display("dmem[0x%8X] = 0x%8X,", addrByte, din); 
        end
        endcase 
      end
    end
    always @(*) begin
      case (LOADSel)
        4'b0000: begin  //lw
            tmp_out = tmp; 
        end
        4'b0001: begin  //lb
          case (byte) 
            2'b00: tmp_out = {{24{tmp[7]}}, {tmp[7:0]}};
            2'b01: tmp_out = {{24{tmp[15]}}, {tmp[15:8]}};
            2'b10: tmp_out = {{24{tmp[23]}}, {tmp[23:16]}};
            2'b11: tmp_out = {{24{tmp[31]}}, {tmp[31:24]}};
            default: $display("byte error!");
          endcase 
          /*
          $display("from lb:");
          $display("addr = 0x%8X", addr);
          $display("byte = 0x%8X", byte);
          $display("addrByte = 0x%8X", addrByte);
          $display("tmp_out = 0x%8X", tmp_out);
          */
        end
        4'b0010: begin  //lbu
          case (byte)
            2'b00: tmp_out = {24'b0, {tmp[7:0]}};
            2'b01: tmp_out = {24'b0, {tmp[15:8]}};
            2'b10: tmp_out = {24'b0, {tmp[23:16]}};
            2'b11: tmp_out = {24'b0, {tmp[31:24]}};
            default: $display("byte error!");
          endcase
          /*
          $display("from lbu:");
          $display("addr = 0x%8X", addr);
          $display("byte = 0x%8X", byte);
          $display("addrByte = 0x%8X", addrByte);
          $display("tmp_out = 0x%8X", tmp_out);
          */
        end 
        4'b0011: begin //lh
          case (byte)
            2'b00: tmp_out = {{24{tmp[15]}}, {tmp[15:0]}};
            2'b01: $display("lh error");
            2'b10: tmp_out = {{24{tmp[31]}}, {tmp[31:16]}};
            2'b11: $display("lh error");
            default: $display("byte error!");
          endcase
          /*
          $display("from lh:");
          $display("addr = 0x%8X", addr);
          $display("byte = 0x%8X", byte);
          $display("addrByte = 0x%8X", addrByte);
          $display("tmp_out = 0x%8X", tmp_out);
          */
        end 
        4'b0100: begin //lhu
          case (byte)
            2'b00: tmp_out = {24'b0, {tmp[15:0]}};
            2'b01: $display("lhu error");
            2'b10: tmp_out = {24'b0, {tmp[31:16]}};
            2'b11: $display("lhu error");
            default: $display("byte error!");
          endcase
          /*
          $display("from lhu:");
          $display("addr = 0x%8X", addr);
          $display("byte = 0x%8X", byte);
          $display("addrByte = 0x%8X", addrByte);
          $display("tmp_out = 0x%8X", tmp_out);
          */
        end  
        default: tmp_out = tmp;
      endcase
    end
    assign dout = tmp_out;
endmodule    
