`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.02.2023 19:53:39
// Design Name: 
// Module Name: execute
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

module execute(
    input clk_i
  , input reset_i
  , input signed [31:0] r1
  , input signed [31:0] r2
  , input [3:0] alu_control
  , input mem_en_i
  , input mem_wr_i
  , input [10:0] mem_addr_i
  , input [4:0] wbAddr_i
  , input wbEnable_i
  , input displayEn_i
  , input stall
  , output logic [31:0] data_o
  , output logic mem_en_o
  , output logic mem_wr_o
  , output logic [10:0] mem_addr_o
  , output logic [4:0] wbAddr_o
  , output logic wbEnable_o
  , output logic displayEn_o
  );
  
  logic [31:0] alu_result;
  
  alu ALU_module(
      .r1(r1),
      .r2(r2),
      .alu_control(alu_control),
      .alu_result(alu_result)
      );
       
  always @ (posedge clk_i, posedge reset_i)
  if (reset_i == 1 | stall == 1) begin
    mem_en_o <= 0;
    mem_wr_o <= 0;
    mem_addr_o <= 0;
    wbAddr_o <= 0;
    wbEnable_o <= 0;
    displayEn_o <= 0;
    data_o <= 0;
  end
  else
  begin
      wbAddr_o <= wbAddr_i;
      wbEnable_o <= wbEnable_i;
      data_o <= alu_result;
      mem_en_o <= mem_en_i;
      mem_wr_o <= mem_wr_i;
      mem_addr_o <= (mem_en_i == 1) ? alu_result : 0;
      displayEn_o <= displayEn_i;
  end
endmodule
