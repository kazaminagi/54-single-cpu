`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/30 19:15:14
// Design Name: 
// Module Name: MUX_rd
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


module MUX_rd(
    input [3:0] M_RD,//—°‘Ò–≈∫≈
    
    input [31:0]alu_r,
    input [31:0]dmem_data,
    input [31:0]Rs,
    input [31:0]Rt,
    input [31:0]cp0_rdata,
    input [31:0]hi,
    input [31:0]lo,
    input [31:0]PC,
    input [31:0]CLZ_tmp,
    
    output [31:0]Rd
    );
    reg [31:0] sel;
    /*************
    wire [31:0]alu_r_reg;
    wire [31:0]dmem_data_reg;
    wire [31:0]Rs_reg;
    wire [31:0]Rt_reg;
    wire [31:0]cp0_rdata_reg;
    wire [31:0]hi_reg;
    wire [31:0]lo_reg;
    wire [31:0]PC_reg;
    
    assign alu_r_reg=alu_r;
    assign dmem_data_reg=dmem_data;
    assign Rs_reg=Rs;
    assign Rt_reg=Rt;
    assign cp0_rdata_reg=cp0_rdata;
    assign hi_reg=hi;
    assign lo_reg=lo;
    assign PC_reg=PC;
    **********/
    parameter alur=4'b0000,dmem32=4'b0001,pc=4'b0010,cp0r=4'b0011,clz=4'b0100;
    parameter dms8=4'b0101,dmu8=4'b0110,dms16=4'b0111,dmu16=4'b1000;
    parameter _hi=4'b1001,_lo=4'b1010,_mul=4'b1011;
    always@(*) begin
        case(M_RD)
        alur:sel<=alu_r;
        dmem32:sel<=dmem_data;
        pc:sel<=PC+4;
        cp0r:sel<=cp0_rdata;
        clz:sel<=CLZ_tmp;
        dms8:sel<={{24{dmem_data[7]}},dmem_data[7:0]};
        dmu8:sel<={24'b0,dmem_data[7:0]};
        dms16:sel<={{16{dmem_data[15]}},dmem_data[15:0]};
        dmu16:sel<={16'b0,dmem_data[15:0]};
        _hi:sel<=hi;
        _lo:sel<=lo;
        _mul:sel<=Rs*Rt;
        default:sel<=32'hz;
        endcase
    end
    assign Rd=sel;
endmodule
