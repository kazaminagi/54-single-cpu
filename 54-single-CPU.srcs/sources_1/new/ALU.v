`timescale 1ns / 1ps

module ALU(
   input [31:0]A,
   input [31:0]B,
   input [3:0]aluc,
   output [31:0]F,
   output zero,
   output carry,
   output negative,
   output overflow
    );
    parameter ADDU=4'b0000;
    parameter ADD=4'b0001;
    parameter SUBU=4'b0010;
    parameter SUB=4'b0011;
    parameter AND=4'b0100;
    parameter OR=4'b0101;
    parameter XOR=4'b0110;
    parameter NOR=4'b0111;
    parameter LUI1=4'b1000;
    parameter LUI2=4'b1001;
    parameter SLTU=4'b1010;
    parameter SLT=4'b1011;
    parameter SRA=4'b1100;
    parameter SRL=4'b1101;
    parameter SLL=4'b1110;
    reg [32:0] r;
    wire signed [31:0] S_A,S_B;
    assign S_A=A;
    assign S_B=B;

    always @(*)
    begin
        case(aluc)
            ADD:r=S_A+S_B;
            ADDU:r=A+B;
            SUB:r=S_A-S_B;
            SUBU:r=A-B;
            AND:r=A&B;
            OR:r=A|B;
            XOR:r=A^B;
            NOR:r=~(A|B);
            SLT:r=S_A<S_B?1:0;
            SLTU:r=A<B?1:0;
            SLL:r=B<<A;
            SRL:r=B>>A;
            SRA:r=S_B>>>S_A;
            LUI1,LUI2: r={B[15:0],16'b0};                                                          
        endcase
    end
    assign F=r[31:0];
    assign carry=r[32];
    assign zero=(r==0)?1:0;
    assign overflow=r[32];
    assign negative=(aluc == SLT||aluc==SUB ? (S_A < S_B) : ((aluc == SLTU) ? (A < B) : 1'b0));
endmodule