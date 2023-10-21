`timescale 1ns / 1ps

module cpu(  
    input clk,
    input ena,
    input rst,
    output DM_ena,
    output DM_W,
    output DM_R,
    input [31:0] IM_instr,
    input [31:0] DM_out,
    output [31:0] DM_in,
    output [1:0] Byteselect,
    output [31:0] PC_out,
    output [31:0] ALU_RES
    );
    //index of orders in the decode
    parameter ADD=0;
    parameter ADDU=1;
    parameter SUB=2;
    parameter SUBU=3;
    parameter AND=4;
    parameter OR=5;
    parameter XOR=6;
    parameter NOR=7;
    parameter SLT=8;
    parameter SLTU=9;
    parameter SLL=10;
    parameter SRL=11;
    parameter SRA=12;
    parameter SLLV=13;
    parameter SRLV=14;
    parameter SRAV=15;
    parameter JR=16;
    parameter ADDI=17;
    parameter ADDIU=18;
    parameter ANDI=19;
    parameter ORI=20;
    parameter XORI=21;
    parameter LW=22;
    parameter SW=23;
    parameter BEQ=24;
    parameter BNE=25;
    parameter SLTI=26;
    parameter SLTIU=27;
    parameter LUI=28;
    parameter J=29;
    parameter JAL=30;
    parameter BREAK=31;
    parameter SYSCALL=32;
    parameter TEQ=33;
    parameter ERET=34;
    parameter MFC0=35;
    parameter MTC0=36;
    parameter CLZ=37;
    parameter DIVU=38;
    parameter DIV=39;
    parameter LB=40;
    parameter LBU=41;
    parameter LH=42;
    parameter LHU=43;
    parameter SB=44;
    parameter SH=45;
    parameter MFHI=46;
    parameter MFLO=47;
    parameter MTHI=48;
    parameter MTLO=49;
    parameter MUL=50;
    parameter MULTU=51;
    parameter BGEZ=52;
    parameter JALR=53;
    
    wire[31:0]PC;    
    wire[31:0]NPC;
    wire[31:0]alu_r;
    assign ALU_RES=alu_r;
    wire[31:0]Rs;
    wire[31:0]Rt;
    wire[31:0]Rd;
    wire[4:0]Rsc;
    wire[4:0]Rtc;
    wire[4:0]Rdc;
    wire Rs_ena;
    wire Rt_ena;
    wire Rd_ena1;
    wire Rd_ena2;
    
    wire M1_0,M1_1,M1_2,M1_3,M2_0,M3,M3_1,M4,M4_1;
    wire[3:0]M_RD;
    
    wire[31:0]MUX1_0_out;
    wire[31:0]MUX1_1_out;
    wire[31:0]MUX1_2_out;
    wire[31:0]MUX1_3_out;
    wire[31:0]MUX2_0_out;
    wire[31:0]MUX_RD_out;
    wire[31:0]MUX3_out;
    wire[31:0]MUX3_1_out;
    wire[31:0]MUX4_out;
    wire[31:0]MUX4_1_out;
    
    wire[31:0]UEXT16;
    wire[31:0]SEXT16;
    wire[31:0]EXT16;
    wire[31:0]EXT5;
    wire[31:0]EXT18;
    wire[31:0]CAT;
    wire[3:0]aluc;
    wire RF_W,RF_R;
    wire RF_CLK;
    wire[53:0]order;
    Decoder decoder(.order_str(IM_instr),.order_decode(order));
    wire zero;
    wire carry;
    wire negative;
    wire overflow;
    //CP0相关变量
    wire[31:0]exc_addr;
    wire[31:0]cp0_rdata;
    wire exception;
    wire [31:0]cp0_wdata;
    wire [4:0]cause;
    wire [31:0]status;
    wire [31:0] CLZ_tmp;
    assign exception=order[BREAK]||order[SYSCALL]||(order[TEQ]&zero);
    assign cause = order[BREAK]?5'b01001:(order[SYSCALL]?5'b01000:(order[TEQ]?5'b01101:5'b00000));
    assign cp0_wdata = Rt; 
    assign CLZ_tmp =Rs[31]==1? 32'h00000000:Rs[30]==1? 32'h00000001:Rs[29]==1? 32'h00000002:Rs[28]==1? 32'h00000003:Rs[27]==1? 32'h00000004:
             Rs[26]==1? 32'h00000005:Rs[25]==1? 32'h00000006:Rs[24]==1? 32'h00000007:Rs[23]==1? 32'h00000008:Rs[22]==1? 32'h00000009:
             Rs[21]==1? 32'h0000000a:Rs[20]==1? 32'h0000000b:Rs[19]==1? 32'h0000000c:Rs[18]==1? 32'h0000000d:Rs[17]==1? 32'h0000000e:
             Rs[16]==1? 32'h0000000f:Rs[15]==1? 32'h00000010:Rs[14]==1? 32'h00000011:Rs[13]==1? 32'h00000012:Rs[12]==1? 32'h00000013:
             Rs[11]==1? 32'h00000014:Rs[10]==1? 32'h00000015:Rs[9]==1? 32'h00000016:Rs[8]==1? 32'h00000017:Rs[7]==1? 32'h00000018:
             Rs[6]==1? 32'h00000019:Rs[5]==1? 32'h0000001a:Rs[4]==1? 32'h0000001b:Rs[3]==1? 32'h0000001c:Rs[2]==1? 32'h0000001d:
             Rs[1]==1? 32'h0000001e:Rs[0]==1? 32'h0000001f:32'h00000020;
    
    //乘除法相关连线
    wire[31:0]div_q;
    wire[31:0]div_r;
    wire[31:0]divu_q;
    wire[31:0]divu_r;
    wire div_busy,divu_busy;
    wire busy;
    wire[63:0]multu_z;
    wire[31:0]in_hi;
    wire[31:0]in_lo;
    wire[31:0]out_hi;
    wire[31:0]out_lo;
    wire hi_ena,lo_ena;
    assign hi_ena=order[DIVU]||order[DIV]||order[MTHI]||order[MULTU];
    assign lo_ena=order[DIVU]||order[DIV]||order[MTLO]||order[MULTU];
    assign in_hi=order[DIVU]?divu_r:(order[DIV]?div_r:(order[MULTU]?multu_z[63:32]:(order[MTHI]?Rs:32'hz)));
    assign in_lo=order[DIVU]?divu_q:(order[DIV]?div_q:(order[MULTU]?multu_z[31:0]:(order[MTLO]?Rs:out_lo)));
    assign busy=div_busy||divu_busy;
    HLreg _hi(
        .clk(clk),
        .rst(rst),
        .ena(hi_ena),
        .in(in_hi),
        .out(out_hi)
    );
    HLreg _lo(
        .clk(clk),
        .rst(rst),
        .ena(lo_ena),
        .in(in_lo),
        .out(out_lo)
        );
    
    //DMEM相关控制信号
    assign DM_W=order[SW]||order[SB]||order[SH];
    assign DM_R=order[LW]||order[LB]||order[LBU]||order[LH]||order[LHU];
    assign DM_in=DM_W?Rt:32'hz;
    assign DM_ena=order[SW]||order[LW]||order[SB]||order[SH]||order[LB]
    ||order[LBU]||order[LH]||order[LHU];
    assign Byteselect=order[SB]?2'b00:(order[SH]?2'b01:2'b10);
    
    //寄存器堆读写的选择地址及内容
    assign Rs_ena=order[ADD]||order[ADDU]||order[SUB]||order[SUBU]||order[AND]||order[OR]
    ||order[XOR]||order[NOR]||order[SLT]||order[SLTU]||order[JR]||order[SLLV]
    ||order[SRLV]||order[SRAV]||order[ADDI]||order[ADDIU]||order[ANDI]||order[ORI]
    ||order[XORI]||order[SW]||order[LW]||order[BEQ]||order[BNE]||order[SLTI]
    ||order[SLTIU]||order[LB]||order[LBU]||order[LH]||order[LHU]||order[SB]
    ||order[SH]||order[BGEZ]||order[DIV]||order[DIVU]||order[MUL]||order[MULTU]
    ||order[MTHI]||order[MTLO]||order[CLZ]||order[JALR];
    assign Rsc=Rs_ena?IM_instr[25:21]:5'hz;
    
    assign Rt_ena=order[ADD]||order[ADDU]||order[SUB]||order[SUBU]||order[AND]||order[OR]
    ||order[XOR]||order[NOR]||order[SLT]||order[SLTU]||order[JR]||order[SLL]||order[SW]
    ||order[SRL]||order[SRA]||order[SLLV]||order[SRLV]||order[SRAV]||order[BEQ]
    ||order[BNE]||order[TEQ]||order[DIV]||order[DIVU]||order[MUL]||order[MULTU]
    ||order[SB]||order[SH]||order[MTC0]||order[MFC0];
    assign Rtc=Rt_ena?IM_instr[20:16]:5'hz;
    
    assign Rd_ena1=order[ADD]||order[ADDU]||order[SUB]||order[SUBU]||order[AND]||order[OR]
    ||order[XOR]||order[NOR]||order[SLT]||order[SLTU]||order[SLLV]
    ||order[SRL]||order[SRA]||order[SLL]||order[SRLV]||order[SRAV]
    ||order[CLZ]||order[MFHI]||order[MFLO]||order[MUL]||order[JALR];
    assign Rd_ena2=order[ADDI]||order[ADDIU]||order[ANDI]||order[ORI]
    ||order[XORI]||order[SLTI]||order[SLTIU]||order[LW]||order[LUI]
    ||order[LB]||order[LBU]||order[LH]||order[LHU]||order[MFC0];
    assign Rdc=Rd_ena1?IM_instr[15:11]:(Rd_ena2?IM_instr[20:16]:(order[JAL]||order[JALR]?5'd31:5'hz));
    
    //M1_0,M1_1,M1_2,M1_3:进入PC数据的选择器的选择信号
    wire signed [31:0]S_Rs;
    assign S_Rs=Rs;
    assign M1_0=order[ADD]||order[ADDU]||order[SUB]||order[SUBU]||order[AND]||order[OR]
    ||order[XOR]||order[NOR]||order[SLT]||order[SLTU]||order[SLL]||order[SRL]||order[SRA]
    ||order[SLLV]||order[SRLV]||order[SRAV]||order[ADDI]||order[ADDIU]||order[ANDI]
    ||order[ORI]||order[XORI]||order[SW]||order[LW]||(order[BEQ]&~zero)||(order[BNE]&zero)
    ||order[SLTI]||order[SLTIU]||order[LUI]||order[BREAK]||order[SYSCALL]||order[TEQ]||order[MFC0]
    ||order[MTC0]||order[CLZ]||order[DIV]||order[DIVU]||order[LB]||order[LBU]||order[LH]||order[LHU]
    ||order[SB]||order[SH]||order[MFHI]||order[MFLO]||order[MTHI]||order[MTLO]||order[MUL]
    ||order[MULTU]||(order[BGEZ]&~(S_Rs>=0));
    
    assign M1_1=order[J]||order[JAL];
    
    assign M1_2=order[ADD]||order[ADDU]||order[SUB]||order[SUBU]||order[AND]||order[OR]
    ||order[XOR]||order[NOR]||order[SLT]||order[SLTU]||order[SLL]||order[SRL]||order[SRA]
    ||order[SLLV]||order[SRLV]||order[SRAV]||order[ADDI]||order[ADDIU]||order[ANDI]
    ||order[ORI]||order[XORI]||order[SW]||order[LW]||order[BEQ]||order[BNE]
    ||order[SLTI]||order[SLTIU]||order[LUI]||order[BREAK]||order[SYSCALL]||order[TEQ]||order[MFC0]
    ||order[MTC0]||order[CLZ]||order[DIV]||order[DIVU]||order[LB]||order[LBU]||order[LH]||order[LHU]
    ||order[SB]||order[SH]||order[MFHI]||order[MFLO]||order[MTHI]||order[MTLO]||order[MUL]
    ||order[MULTU]||order[BGEZ]||order[ERET];
    
    assign M1_3=order[ERET];
    
    //M2_0,M_RD:需要写入寄存器堆数据的选择信号
    assign M2_0=order[ADD]||order[ADDU]||order[SUB]||order[SUBU]||order[AND]||order[OR]
    ||order[XOR]||order[NOR]||order[SLT]||order[SLTU]||order[SLL]||order[SRL]||order[SRA]
    ||order[SLLV]||order[SRLV]||order[SRAV]||order[ADDI]||order[ADDIU]||order[ANDI]
    ||order[ORI]||order[XORI]||order[SLTI]||order[SLTIU]||order[LUI]||order[JALR];//进入rf的是ALU运算结果
    
    assign M_RD[3]=order[LHU]||order[MFHI]||order[MFLO]||order[MUL];
    assign M_RD[2]=order[CLZ]||order[LB]||order[LBU]||order[LH];
    assign M_RD[1]=order[JAL]||order[MFC0]||order[LBU]||order[LH]||order[MFLO]||order[MUL];
    assign M_RD[0]=order[LW]||order[MFC0]||order[LB]||order[LH]||order[MFHI]||order[MUL];
    MUX_rd mrd(
        .M_RD(M_RD),
        
        .alu_r(alu_r),
        .dmem_data(DM_out),
        .Rs(Rs),
        .Rt(Rt),
        .cp0_rdata(cp0_rdata),
        .hi(out_hi),
        .lo(out_lo),
        .PC(PC),
        .CLZ_tmp(CLZ_tmp),
            
        .Rd(MUX_RD_out)        
    );
    assign Rd=MUX_RD_out;
    
    //M3,M3_1:alu_A 
    assign M3=order[SLL]||order[SRL]||order[SRA];
    assign M3_1=~order[JALR];
    
    //M4,M4_1:alu_B
    assign M4=order[ADDI]||order[ADDIU]||order[ANDI]||order[ORI]||order[XORI]
    ||order[LW]|| order[SW]||order[SLTI]||order[SLTIU]||order[LUI]||order[LB]
    ||order[LBU]||order[LH]||order[LHU]||order[SB]||order[SH];
    assign M4_1=order[BGEZ]||order[JALR];
    
    //alu控制信号
    assign aluc[3]=order[SLT]||order[SLTU]||order[SLL]||order[SRL]||order[SRA]||order[SLLV]
    ||order[SRLV]||order[SRAV]||order[SLTI]||order[SLTIU]||order[LUI];
    
    assign aluc[2]=order[AND]||order[OR]||order[XOR]||order[NOR]||order[SLL]||order[SRL]
    ||order[SRA]||order[SLLV]||order[SRLV]||order[SRAV]||order[ANDI]||order[ORI]||order[XORI];
    
    assign aluc[1]=order[SUB]||order[SUBU]||order[XOR]||order[NOR]||order[SLT]||order[SLTU]
    ||order[SLL]||order[SLLV]||order[XORI]||order[BEQ]||order[BNE]||order[SLTI]||order[SLTIU]
    ||order[TEQ]||order[BGEZ];
    
    assign aluc[0]=order[ADD]||order[SUB]||order[OR]||order[NOR]||order[SLT]||order[SRL]
    ||order[SRLV]||order[ADDI]||order[ORI]||order[SLTI]||order[LB]||order[LBU]||order[LH]
    ||order[LHU]||order[SB]||order[SH]||order[BGEZ]||order[JALR];
    
    //寄存器堆写有效
    assign RF_W=order[ADD]||order[ADDU]||order[SUB]||order[SUBU]||order[AND]||order[OR]
    ||order[XOR]||order[NOR]||order[SLT]||order[SLTU]||order[SLL]||order[SRL]
    ||order[SRA]||order[SLLV]||order[SRLV]||order[SRAV]||order[ADDI]||order[ADDIU]
    ||order[ANDI]||order[ORI]||order[XORI]||order[LW]||order[SLTI]||order[SLTIU]||order[LUI]
    ||order[JAL]||order[MFC0]||order[CLZ]||order[LB]||order[LBU]||order[LH]||order[LHU]
    ||order[MFHI]||order[MFLO]||order[MUL]||order[JALR];
    
    
    assign UEXT16={16'h0,IM_instr[15:0]};
    assign SEXT16={{16{IM_instr[15]}},IM_instr[15:0]};
    assign EXT16=(order[ADDI]||order[ADDIU]||order[LW]||order[SW]||order[SLTI]||order[SLTIU]
    ||order[LB]||order[LBU]||order[LH]||order[LHU]||order[SB]||order[SH])?SEXT16:UEXT16;
    assign EXT5=(order[SLL]||order[SRL]||order[SRA])?{27'b0,IM_instr[10:6]}:32'hz;
    assign EXT18=(order[BEQ]||order[BNE]||order[BGEZ])?{{14{IM_instr[15]}},IM_instr[15:0],2'b0}:32'hz;
    assign NPC=PC+4;
    assign CAT=(order[J]||order[JAL])?{PC[31:28],IM_instr[25:0],2'b0}:32'hz;
    
    //进入PC的选择器
    assign MUX1_0_out=M1_0?NPC:EXT18+NPC;
    assign MUX1_3_out=M1_3?exc_addr:MUX1_0_out;
    assign MUX1_1_out=M1_1?CAT:Rs;
    assign MUX1_2_out=M1_2?MUX1_3_out:MUX1_1_out;
    
    //assign MUX2_0_out=M2_0?alu_r:DM_out;
    //alu输入数据选择器
    assign MUX3_out=M3?EXT5:Rs;
    assign MUX3_1_out=M3_1?MUX3_out:PC;
    assign MUX4_out=M4?EXT16:Rt;
    assign MUX4_1_out=M4_1?(order[BGEZ]?32'd0:32'd4):MUX4_out;
    
    assign PC_out=PC;
    
   DIV _div(
       .dividend(Rs),
       .divisor(Rt),
       .start(order[DIV]),
       .clock(clk),
       .reset(rst),
       .q(div_q),
       .r(div_r),
       .busy(div_busy)
   );

    DIVU _divu(
       .dividend(Rs),
       .divisor(Rt),
       .start(order[DIVU]),
       .clock(clk),
       .reset(rst),
       .q(divu_q),
       .r(divu_r),
       .busy(divu_busy)
   );
   //wire multu_start;
  // assign multu_start=order[MULTU];
   MULTU _multu(
       .clk(clk),
       .reset(rst),
      // .start(multu_start),
       .a(Rs),
       .b(Rt),
       .z(multu_z)
   );
             
   CP0 _cp0(
        .clk(clk),
       .rst(rst),
       .mfc0(order[MFC0]),         //CPU instruction is Mfc0
       .mtc0(order[MTC0]),         //CPU instruction is Mtc0
       .pc(PC),    
       .Rd(IM_instr[15:11]),    //Specifies CP0 register
       .wdata(cp0_wdata),   //Data form GP($28) register to replace CP0 register
       .exception(exception),     //SYSCALL,BREAK,TEQ
       .eret(order[ERET]),             // Instruction is ERET(Exception Return)
       .cause(cause),
       //input intr,           //外部中断输入
       .rdata(cp0_rdata),  //Data form CP0 register for GP register
       .status(status),
       //output reg_timer_int,  //定时器中断输出
       .exc_addr(exc_addr)
   );
     PCreg _pcreg(
        .clk(clk),
        .pc_rst(rst),
        .pc_ena(1'b1),
        .ok(~busy),
        .pc_in(MUX1_2_out),
        .pc_out(PC)
        );
   regfile cpu_ref(
        .RF_ena(1'b1),
        .RF_rst(rst),
        .RF_clk(clk),
        .Rdc(Rdc),
        .Rsc(Rsc),
        .Rtc(Rtc),
        .Rd(Rd),
        .Rs(Rs),
        .Rt(Rt),
        .RF_W(RF_W)
        );
    ALU _alu(
       .A(MUX3_1_out),
       .B(MUX4_1_out),
       .aluc(aluc),
       .F(alu_r),
       .zero(zero),
       .carry(carry),
       .negative(negative),
       .overflow(overflow)
       );
endmodule