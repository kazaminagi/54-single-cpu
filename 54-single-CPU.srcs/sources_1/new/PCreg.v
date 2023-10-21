`timescale 1ns / 1ps
module PCreg(
    input clk,
    input pc_rst,
    input pc_ena,
    input ok,
    input [31:0]pc_in,
    output [31:0]pc_out
    );
    reg [31:0]PC_reg=32'h00400000;
    reg [31:0]out;
    always @(negedge clk or posedge pc_rst)begin
        if(pc_ena)begin
            if(pc_rst==1'b1)
                PC_reg<=32'h00400000;
            else if(ok)
                PC_reg<=pc_in;
        end
    end
    assign pc_out=PC_reg;
endmodule