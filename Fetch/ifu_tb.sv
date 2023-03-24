`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.02.2023 16:13:03
// Design Name: 
// Module Name: ifu_tb
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


module ifu_tb(

    );
    
    logic clk, reset;
    logic [31:0] instruction;
    initial begin
        clk = 1;
        forever
            begin
                #10;
                clk = ~clk;
            end
        end
      
      initial begin
              reset = 0;
              #130 reset = 1;
              #10 reset = 0;
      end
      initial
                #1000 $finish;
                
      ifu IFU_TEST(
       .clk_i(clk)
      ,.reset_i(reset)
      ,.instruction_o(instruction)
      );
      
endmodule
