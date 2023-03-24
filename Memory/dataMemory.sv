`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2023 01:49:03
// Design Name: 
// Module Name: dataMemory
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


module dataMemory(
    input clk_i,
    input reset_i,
    input mem_en,
    input [10:0] addr_i,
    input wr_en,
    input [31:0] data_i,
    input [4:0] wbAddr_i,
    input wbEnable_i,
    output logic [31:0] data_o,
    output logic [4:0] wbAddr_o,
    output logic wbEnable_o
    );
    
    reg [7:0] ram [63:0];
            
    always @ (posedge clk_i, posedge reset_i)
    begin
        if (reset_i == 1) begin
            $readmemh("data.mem", ram);
            wbAddr_o <= 0;
            wbEnable_o <= 0;
            data_o <= 0;
        end
        else if (wr_en & mem_en)
        begin
            wbAddr_o <= wbAddr_i;
            wbEnable_o <= wbEnable_i;
            data_o <= 0;
            {ram[addr_i[5:0]+3],ram[addr_i[5:0]+2],ram[addr_i[5:0]+1],ram[addr_i[5:0]]} <= data_i;
        end 
        else if (mem_en)
        begin
            wbAddr_o <= wbAddr_i;
            wbEnable_o <= wbEnable_i;
            data_o <= {ram[addr_i[5:0]+3],ram[addr_i[5:0]+2],ram[addr_i[5:0]+1],ram[addr_i[5:0]]};
        end
        else
        begin
            data_o <= data_i;
            wbAddr_o <= wbAddr_i;
            wbEnable_o <= wbEnable_i;
        end
    end
endmodule
