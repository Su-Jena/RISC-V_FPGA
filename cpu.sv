`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.02.2023 18:27:24
// Design Name: 
// Module Name: cpu
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
module cpu(
     input clk_i,
     input reset_i,
     output logic [6:0] led
    );
    
    logic [31:0] instruction, pc;               //IFU to CU
    
    logic [19:0] pc_imm;                    //CU to IFU
    
    logic branchEnable;                     //CU to IFU
    
    logic [31:0] op1, op2, operand1, operand2;                  //CU to Execute
    
    logic [3:0] aluControl;                 //CU to Execute
    
    logic [31:0] executeData;               //Execute to Data Memory
    
    logic memoryEnable1, memoryWrite1, memoryEnable2, memoryWrite2;  //CU to Execute to Data Memory 
    
    logic [10:0] memoryAddress1, memoryAddress2;             //CU to Execute to Data Memory
    
    logic [31:0] registerData;              //Data Memory to CU Register
    
    logic [4:0] writeBackAddress1, writeBackAddress2, writeBackAddress3;           //CU to Execute to Memory to CU
    
    logic writeBackEnable1, writeBackEnable2, writeBackEnable3;                   //CU to Execute to Memory to CU
    
    logic displayEn1, displayEn;                        //CU to Display
    
    logic [4:0] rs1Addr, rs2Addr;
    
    logic stall;
    
    ifu fetch (
     .clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.stall(stall)
    ,.instruction_o(instruction)
    ,.branch_en(branchEnable)
    ,.pc_imm(pc_imm)
    ,.PC(pc)
    );
    
    controlUnit decode (
     .clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.instruction_i(instruction)
    ,.write_data(registerData)
    ,.aluControl_o(aluControl)
    ,.op1(op1)
    ,.op2(op2)
    ,.mem_en(memoryEnable1)
    ,.mem_wr(memoryWrite1)
    ,.mem_addr(memoryAddress1)
    ,.pc_i(pc)
    ,.branch_en(branchEnable)
    ,.pc_imm(pc_imm)
    ,.displayEn_o(displayEn1)
    ,.wbAddr_i(writeBackAddress3)
    ,.wbEnable_i(writeBackEnable3)
    ,.wbAddr_o(writeBackAddress1)
    ,.wbEnable_o(writeBackEnable1)
    ,.rs1_address(rs1Addr)
    ,.rs2_address(rs2Addr)
    ,.stall(stall)
    );
    
    hazardUnit hazard (
     .rs1(rs1Addr)
    ,.rs2(rs2Addr)
    ,.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.alurd_i(writeBackAddress2)
    ,.loadrd_i(writeBackAddress3)
    ,.aluResult(executeData)
    ,.loadResult(registerData)
    ,.op1_i(op1)
    ,.op2_i(op2)
    ,.op1_o(operand1)
    ,.op2_o(operand2)
    ,.memEn_i(memoryEnable2)
    ,.memWr_i(memoryWrite2)
    ,.stall(stall)
    );
    
    execute execute (
     .clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.alu_control(aluControl)
    ,.r1(operand1)
    ,.r2(operand2)
    ,.mem_en_i(memoryEnable1)
    ,.mem_wr_i(memoryWrite1)
    ,.mem_addr_i(memoryAddress1)
    ,.mem_en_o(memoryEnable2)
    ,.mem_wr_o(memoryWrite2)
    ,.mem_addr_o(memoryAddress2)
    ,.displayEn_i(displayEn1)
    ,.displayEn_o(displayEn)
    ,.data_o(executeData)
    ,.wbAddr_i(writeBackAddress1)
    ,.wbEnable_i(writeBackEnable1)
    ,.wbAddr_o(writeBackAddress2)
    ,.wbEnable_o(writeBackEnable2)
    ,.stall(stall)
    );
    
    dataMemory memory (
     .clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.mem_en(memoryEnable2)
    ,.addr_i(memoryAddress2)
    ,.wr_en(memoryWrite2)
    ,.data_i(executeData)
    ,.data_o(registerData)
    ,.wbAddr_i(writeBackAddress2)
    ,.wbEnable_i(writeBackEnable2)
    ,.wbAddr_o(writeBackAddress3)
    ,.wbEnable_o(writeBackEnable3) 
    );
    
    display hexa (
     .clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.hex_i(executeData[7:0])
    ,.displayEn_i(displayEn)
    ,.display_o(led)
    );
    
endmodule
