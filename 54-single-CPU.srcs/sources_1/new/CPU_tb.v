`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/01 16:30:01
// Design Name: 
// Module Name: CPU_tb
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

module CPU_tb();
    reg clk;
    reg rst;
    wire[31:0]im_str;
    wire[31:0]pc;
    sccomp_dataflow sc_inst(
    .clk_in(clk),
    .reset(rst),
    .inst(im_str),
    .pc(pc)
        );
    reg[31:0]cnt;
    integer file_open;
    initial begin
        clk=0;
        rst=1;
        #10 rst=0;
        cnt=0;
    end
    always begin #10 clk=~clk; end
   
    always @ (posedge clk) begin
        cnt <= cnt + 1'b1;
        file_open = $fopen("D:\\output.txt", "a+");
        $fdisplay(file_open, "OP: %d", cnt);
        $fdisplay(file_open, "Instr_addr = %h", sc_inst.im_str);
        $fdisplay(file_open, "$zero = %h", sc_inst.sccpu.cpu_ref.array_reg[0]);
        $fdisplay(file_open, "$at   = %h", sc_inst.sccpu.cpu_ref.array_reg[1]);
        $fdisplay(file_open, "$v0   = %h", sc_inst.sccpu.cpu_ref.array_reg[2]);
        $fdisplay(file_open, "$v1   = %h", sc_inst.sccpu.cpu_ref.array_reg[3]);
        $fdisplay(file_open, "$a0   = %h", sc_inst.sccpu.cpu_ref.array_reg[4]);
        $fdisplay(file_open, "$a1   = %h", sc_inst.sccpu.cpu_ref.array_reg[5]);
        $fdisplay(file_open, "$a2   = %h", sc_inst.sccpu.cpu_ref.array_reg[6]);
        $fdisplay(file_open, "$a3   = %h", sc_inst.sccpu.cpu_ref.array_reg[7]);
        $fdisplay(file_open, "$t0   = %h", sc_inst.sccpu.cpu_ref.array_reg[8]);
        $fdisplay(file_open, "$t1   = %h", sc_inst.sccpu.cpu_ref.array_reg[9]);
        $fdisplay(file_open, "$t2   = %h", sc_inst.sccpu.cpu_ref.array_reg[10]);
        $fdisplay(file_open, "$t3   = %h", sc_inst.sccpu.cpu_ref.array_reg[11]);
        $fdisplay(file_open, "$t4   = %h", sc_inst.sccpu.cpu_ref.array_reg[12]);
        $fdisplay(file_open, "$t5   = %h", sc_inst.sccpu.cpu_ref.array_reg[13]);
        $fdisplay(file_open, "$t6   = %h", sc_inst.sccpu.cpu_ref.array_reg[14]);
        $fdisplay(file_open, "$t7   = %h", sc_inst.sccpu.cpu_ref.array_reg[15]);
        $fdisplay(file_open, "$s0   = %h", sc_inst.sccpu.cpu_ref.array_reg[16]);
        $fdisplay(file_open, "$s1   = %h", sc_inst.sccpu.cpu_ref.array_reg[17]);
        $fdisplay(file_open, "$s2   = %h", sc_inst.sccpu.cpu_ref.array_reg[18]);
        $fdisplay(file_open, "$s3   = %h", sc_inst.sccpu.cpu_ref.array_reg[19]);
        $fdisplay(file_open, "$s4   = %h", sc_inst.sccpu.cpu_ref.array_reg[20]);
        $fdisplay(file_open, "$s5   = %h", sc_inst.sccpu.cpu_ref.array_reg[21]);
        $fdisplay(file_open, "$s6   = %h", sc_inst.sccpu.cpu_ref.array_reg[22]);
        $fdisplay(file_open, "$s7   = %h", sc_inst.sccpu.cpu_ref.array_reg[23]);
        $fdisplay(file_open, "$t8   = %h", sc_inst.sccpu.cpu_ref.array_reg[24]);
        $fdisplay(file_open, "$t9   = %h", sc_inst.sccpu.cpu_ref.array_reg[25]);
        $fdisplay(file_open, "$k0   = %h", sc_inst.sccpu.cpu_ref.array_reg[26]);
        $fdisplay(file_open, "$k1   = %h", sc_inst.sccpu.cpu_ref.array_reg[27]);
        $fdisplay(file_open, "$gp   = %h", sc_inst.sccpu.cpu_ref.array_reg[28]);
        $fdisplay(file_open, "$sp   = %h", sc_inst.sccpu.cpu_ref.array_reg[29]);
        $fdisplay(file_open, "$fp   = %h", sc_inst.sccpu.cpu_ref.array_reg[30]);
        $fdisplay(file_open, "$ra   = %h", sc_inst.sccpu.cpu_ref.array_reg[31]);
        $fdisplay(file_open, "$hi   = %h", sc_inst.sccpu._hi.hlreg);
        $fdisplay(file_open, "$lo   = %h", sc_inst.sccpu._lo.hlreg);
        $fdisplay(file_open, "$pc   = %h\n", sc_inst.pc);
        $fclose(file_open);
        end
endmodule
