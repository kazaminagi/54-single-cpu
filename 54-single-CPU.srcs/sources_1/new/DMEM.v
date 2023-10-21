`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/30 11:01:28
// Design Name: 
// Module Name: DMEM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DMEM(
    input clk,
    input DM_ena,
    input DM_W,
    input DM_R,
    input [8:0] DM_addr,
    input [31:0] DM_in,
    input [1:0] Byteselect,//0:×Ö½Ú 1:°ë×Ö 2:×Ö
    output [31:0] DM_out
    );
      reg [7:0] mem[0:511];
      always @(posedge clk) begin
          if (DM_W && DM_ena)
          begin
            case(Byteselect)
            2'b00:
                mem[DM_addr]<=DM_in[7:0];
            2'b01:
            begin
                mem[DM_addr]<=DM_in[7:0];
                mem[DM_addr+1]<=DM_in[15:8];
            end
            2'b10:
            begin
                mem[DM_addr]<=DM_in[7:0];
                mem[DM_addr+1]<=DM_in[15:8];
                mem[DM_addr+2]<=DM_in[23:16];
                mem[DM_addr+3]<=DM_in[31:24];
            end               
          endcase
        end
      end
      
      assign DM_out = DM_ena?(DM_R?({mem[DM_addr+3],mem[DM_addr+2],mem[DM_addr+1],mem[DM_addr]}):32'bz):32'bz;
endmodule

