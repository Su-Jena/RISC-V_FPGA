`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.02.2023 16:13:03
// Design Name: 
// Module Name: ifu
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
module ifu(
    input clk_i
    ,input reset_i
    ,input branch_en
    ,input stall
    ,input signed [19:0] pc_imm
    ,output logic [31:0] instruction_o
    ,output logic [31:0] PC
    );
    
 initial begin
    PC = 32'b0;  // 32-bit program counter is initialized to zero
    //instruction_o = 0;
 end   
        programMemory progMem(
        .addr_i(PC)
       ,.data_o(instruction_o)
       );
        
        always @(posedge clk_i, posedge reset_i)
        begin
            if (reset_i == 1) begin
                PC <= 0;
            end
            else if (stall)
            begin
                PC <= PC - 8;
            end
            else if (branch_en == 1) begin
                PC[19:0] <= PC[19:0] + pc_imm - 4;
            end
            else
            begin
                PC <= PC + 4;
            end
        end
endmodule
