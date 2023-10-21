`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/31 10:06:38
// Design Name: 
// Module Name: HLreg
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


module HLreg(
    input clk,
    input rst,
    input ena,
    input [31:0]in,
    output [31:0]out
    );
    reg[31:0]hlreg;
    always@(negedge clk or posedge rst)
    begin
        if(rst)
            hlreg<=32'b0;
        else if(~rst&ena)
            hlreg<=in;
        else
            hlreg<=hlreg;
    end
    assign out=hlreg;
endmodule
