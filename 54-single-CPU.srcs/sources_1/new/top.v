`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/06 16:07:42
// Design Name: 
// Module Name: top
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
module top(
    input clk,
    input rst,
    output [7:0]o_seg,
    output [7:0]o_sel
);
    
    wire clk_sc;
    wire [31:0]ins;
    wire [31:0]pc;
    

    clk_change clk_wiz_0_inst(
        .clk_in1(clk),
        .clk_out1(clk_sc)
    );

    sccomp_dataflow sc(
        .clk_in(clk_sc), .reset(rst),
        .inst(ins), .pc(pc)
    );

    seg7x16 seg7x16_inst(
        .clk(clk),
        .reset(rst),
        .cs(1'b1),
        .i_data(ins),
        .o_seg(o_seg),
        .o_sel(o_sel)
    );

endmodule
