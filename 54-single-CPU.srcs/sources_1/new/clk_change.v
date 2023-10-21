`timescale 1ns / 1ps
module clk_change(
    input clk_in1,        // 100MHz input clock
    output reg clk_out1 = 0 // 25Hz output clock
    );
    
    reg [31:0] cnt = 0; // Counter large enough for 4,000,000 counts. 2^22 > 4,000,000 so 22 bits are required. We use 21 down to 0 for a total of 22 bits.
    
    always @(posedge clk_in1) begin
        if (cnt == 31'd500000 - 1) begin
            cnt <= 0;     // Reset cnt
            clk_out1 <= ~clk_out1; // Toggle the output clock
        end 
        else 
        begin
            cnt <= cnt + 1; // Increment cnt
        end
    end
    
endmodule