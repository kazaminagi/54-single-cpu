`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/30 12:55:24
// Design Name: 
// Module Name: DIV
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

module DIV(
     input [31:0]dividend,         //dividend
     input [31:0]divisor,           //divisor
     input start,       //start = is_div & ~busy
     input clock,
     input reset,
     output [31:0]q,
     output [31:0]r,
     output reg busy
         );
wire ready;
reg[5:0]count;
reg [31:0] reg_q;//����̣���ʼ��Ϊ������
reg [31:0] reg_r;//�������
reg [31:0] reg_b;//��ų���
reg r_sign;
//assign ready = ~busy & busy2;
wire [32:0] sub_add = r_sign?({reg_r,reg_q[31]} + {1'b0,reg_b}):({reg_r,reg_q[31]} - {1'b0,reg_b});//�Ӽ�����
assign r = dividend[31]?(~(r_sign? reg_r + reg_b : reg_r)+1):(r_sign? reg_r + reg_b : reg_r);
assign q = (dividend[31]^divisor[31])?(~reg_q+1):reg_q;    
always @ (posedge clock or posedge reset)
begin
     if (reset == 1) begin                     //����
         count <=0;
         busy <= 0;;
     end
     else 
     begin
           if (start&~busy) 
           begin                      //��ʼ�������㣬��ʼ��
               reg_r <= 32'b0;
               r_sign <= 0;
               reg_q <= dividend[31]?(~dividend+1):dividend;
               reg_b <= divisor[31]?(~divisor+1):divisor;
               count <= 0;
               busy <= 1;
           end 
           else if (busy) 
           begin                     //ѭ������
               reg_r <= sub_add[31:0];                 //��������
               r_sign <= sub_add[32];                  //���Ϊ�����´����
               reg_q <= {reg_q[30:0],~sub_add[32]};     
               count <= count +5'b1;                  //��������һ
               if (count == 5'b11111) 
                    busy <= 0;            //������������
           end
    end
end
endmodule
