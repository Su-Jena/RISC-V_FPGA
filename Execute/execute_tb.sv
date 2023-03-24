`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.02.2023 11:34:11
// Design Name: 
// Module Name: execute_tb
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


module execute_tb(

    );
    
        logic clk, reset;
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
                    
          execute Execute(
           .clk_i(clk)
          ,.reset_i(reset)
          );                    
endmodule
