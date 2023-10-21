`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/06 16:08:40
// Design Name: 
// Module Name: test_tb
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
module test_tb();
    reg clk, rst;
    wire [31:0] ins, pc;
    integer file_output;
    integer cnt = 0;

    wire [7:0] o_seg;
    wire [7:0] o_sel;

    initial begin
        clk = 0;
        rst = 1;
        #10;
        rst = 0;
    end

    always begin
        #10;
        clk = ~clk;
        if (clk == 1'b1) begin
            if (cnt == 1200) begin
            end
            else begin
                cnt = cnt + 1;
            end
        end
    end

    wire clk_sc;

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
        .i_data(pc),
        .o_seg(o_seg),
        .o_sel(o_sel)
    );

endmodule