`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/01 16:23:36
// Design Name: 
// Module Name: sccomp_dataflow
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

module sccomp_dataflow(
    input clk_in,
    input reset,
    output[31:0]inst,
    output[31:0]pc
    );
    wire DM_W;
    wire DM_R;
    wire[31:0]_pc;
    wire[31:0]DM_out;
    wire[31:0]DM_in;
    wire[10:0]DM_addr;
    wire[31:0]alur;
    wire[31:0]im_str;
    wire[10:0]im_addr;
    assign im_addr=(_pc-32'h00040000)/4;
    assign inst=im_str;
    assign DM_addr=alur-32'h10010000;
    assign pc=_pc;
    wire DM_ena;
    wire [1:0]Byteselect;
    cpu sccpu(  
        .clk(clk_in),
        .ena(1'b1),
        .rst(reset),
        .DM_ena(DM_ena),
        .DM_W(DM_W),
        .DM_R(DM_R),
        .IM_instr(im_str),
        .DM_out(DM_out),
        .DM_in(DM_in),
        .Byteselect(Byteselect),
        .PC_out(_pc),
        .ALU_RES(alur)
        );
    IMEM _imem(
        .addr(im_addr),
        .str(im_str)
        );
    DMEM _dmem(
        .clk(clk_in),
        .DM_ena(DM_ena),
        .DM_W(DM_W),
        .DM_R(DM_R),
        .DM_addr(DM_addr[8:0]),
        .Byteselect(Byteselect),
        .DM_in(DM_in),
        .DM_out(DM_out)
        );
endmodule
