`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.02.2023 20:56:04
// Design Name: 
// Module Name: display_tb
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


module display_tb(

    );
    
    logic clk, enable;
    logic [7:0] hex;
    logic [6:0] display;
    
    initial begin
            clk = 1;
            forever
                begin
                    #10;
                    clk = ~clk;
                end
            end
    
    initial begin
        #20 enable = 0;
        #100 hex = 8'h68; enable = 1;
        #20 enable = 0;
        #100 hex = 8'h65; enable = 1;
        #20 enable = 0;
        #100 hex = 8'h6C; enable = 1;
        #20 enable = 0;
        #100 hex = 8'h6C; enable = 1;
        #20 enable = 0;
        #100 hex = 8'h6F; enable = 1;
        #20 enable = 0;
        #100 hex = 8'hA0; enable = 1;
        #20 enable = 0;
        #100 hex = 8'h77; enable = 1;
        #20 enable = 0;
        #100 hex = 8'h6F; enable = 1;
        #20 enable = 0;
        #100 hex = 8'h72; enable = 1;
        #20 enable = 0;
        #100 hex = 8'h6C; enable = 1;
        #20 enable = 0;
        #100 hex = 8'h64; enable = 1;
        #20 enable = 0;
    end
            
    initial
            #10000 $finish;
            
    display out (
    .clk_i(clk),
    .hex_i(hex),
    .displayEn_i(enable),
    .display_o(display)
    );
    
endmodule
