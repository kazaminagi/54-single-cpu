`timescale 1ns / 1ps

module CP0(
    input clk,
    input rst,
    input mfc0,         //CPU instruction is Mfc0
    input mtc0,         //CPU instruction is Mtc0
    input [31:0] pc,    
    input [4:0] Rd,    //Specifies CP0 register
    input [31:0] wdata,   //Data form GP($28) register to replace CP0 register
    input exception,     //SYSCALL,BREAK,TEQ
    input eret,             // Instruction is ERET(Exception Return)
    input [4:0] cause,
    //input intr,           //外部中断输入
    output [31:0]  rdata,  //Data form CP0 register for GP register
    output [31:0] status,
    //output reg_timer_int,  //定时器中断输出
    output [31:0] exc_addr  //Address for PC at the begeinning of an exception
    );
       
    //cause[6:2]异常类型号
    parameter  SYSCALL = 5'b01000,
                 BREAK = 5'b01001,
                 REQ = 5'b01101;
                     
    reg [31:0] cp0_reg [0:31]; //CP0的32个寄存器
    assign  status = cp0_reg [12];
 //12号status寄存器，中断异常时把 Status 寄存器的内容左移 5 位关中断，中断返回时再将 Status 寄存器右移 5 位恢复其内容
 //只用到status[3:0]
 //13号cause寄存器，存放中断原因
 //只用到cause[6:2]
 //14号EPC寄存器，保存上一次异常时的程序计数器             
    always @(posedge clk or posedge rst)
    begin
        if(rst)
              begin 
                cp0_reg [0] <=0 ;
                cp0_reg [1] <=0 ;
                cp0_reg [2] <=0 ;
                cp0_reg [3] <=0 ;
                cp0_reg [4] <=0 ;
                cp0_reg [5] <=0 ;
                cp0_reg [6] <=0 ;
                cp0_reg [7] <=0 ;
                cp0_reg [8] <=0 ;
                cp0_reg [9] <=0 ;
                cp0_reg [10] <=0 ;
                cp0_reg [11] <=0 ;
                cp0_reg [12] <=0 ;
                cp0_reg [13] <=0 ;
                cp0_reg [14] <=0 ;
                cp0_reg [15] <=0 ;
                cp0_reg [16] <=0 ;
                cp0_reg [17] <=0 ;
                cp0_reg [18] <=0 ;
                cp0_reg [19] <=0 ;
                cp0_reg [20] <=0 ;
                cp0_reg [21] <=0 ;
                cp0_reg [22] <=0 ;
                cp0_reg [23] <=0 ;
                cp0_reg [24] <=0 ;
                cp0_reg [25] <=0 ;
                cp0_reg [26] <=0 ;
                cp0_reg [27] <=0 ;
                cp0_reg [28] <=0 ;
                cp0_reg [29] <=0 ;
                cp0_reg [30] <=0 ;
                cp0_reg [31] <=0 ;        
              end
           else 
                 if(mtc0)
                    cp0_reg [Rd] <= wdata;
                 else if (exception)   //enter break
                    begin
                       cp0_reg [14] <=   pc; //epc
                       cp0_reg [12] <=   status<<5; //stauts
                       cp0_reg [13] <=   {24'b0,cause,2'b0}; //cause 
                    end
                 else if(eret) //out break
                        cp0_reg [12] <= status>>5;
   end 
   assign exc_addr  = eret? cp0_reg [14]:32'h00400004;
   assign rdata = mfc0? cp0_reg [Rd]:32'hz; 
endmodule
