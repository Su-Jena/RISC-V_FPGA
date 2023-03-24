`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2023 01:49:03
// Design Name: 
// Module Name: dataMemory_tb
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


module dataMemory_tb(

    );
    
    logic clk, wr_en;
    logic [11:0] addr;
    logic [31:0] data_i, data_o;
    
    dataMemory DM (
    .clk_i(clk)
    ,.wr_en(wr_en)
    ,.addr_i(addr)
    ,.data_i(data_i)
    ,.data_o(data_o)
    );
    
    initial
    begin
        clk = 1;
        forever
            begin
                #10;
                clk = ~clk;
            end
    end
    
    initial
    begin
        #100 addr = 0; wr_en = 1; data_i = 9;
        #100 addr = 4; wr_en = 1; data_i = 10;
        #100 addr = 8; wr_en = 1; data_i = 150;
        #100 addr = 12; wr_en = 1; data_i = 9010;
        #100 addr = 0; wr_en = 0; 
        #100 addr = 4; wr_en = 0;
        #100 addr = 8; wr_en = 0;
        #100 addr = 12; wr_en = 0;
     end
     initial   
        #1000 $finish;
    
endmodule
