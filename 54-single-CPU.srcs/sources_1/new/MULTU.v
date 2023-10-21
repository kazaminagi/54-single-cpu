`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/30 12:56:05
// Design Name: 
// Module Name: MULTU
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

module MULTU(
 input clk, // 乘法器时钟信号
 input reset, 
 input [31:0] a, // 输入 a(被乘数)
 input [31:0] b, // 输入 b(乘数)
 output [63:0] z // 乘积输出 z
) ;
    wire [65:0] result;
    assign result={1'b0,a}*{1'b0,b};
    assign z=result[63:0];
/********
reg [31:0]high_a;
reg [31:0]low_a;
reg [31:0]reg_a;
reg [31:0]reg_b;
integer i;
always@(posedge clk or negedge reset)
begin
    if(!reset)begin
        z=0;
        reg_a=0;
        reg_b=0;
    end
    else begin
        reg_a=a;
        reg_b=b;
        high_a=0;
        low_a=0;
        for(i=0;i<=31;i=i+1)
        begin
            if(reg_b[0]==1)begin
                high_a=high_a+reg_a;
            end
            low_a={high_a[0],low_a[31:1]};
            high_a={1'b0,high_a[31:1]};
            reg_b={1'b0,reg_b[31:1]};
        end
        z={high_a,low_a};
    end
end
******/
endmodule
