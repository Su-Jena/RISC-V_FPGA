`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.03.2023 00:01:38
// Design Name: 
// Module Name: hazardUnit
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


module hazardUnit(
    input clk_i,
    input reset_i,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] alurd_i,
    input [4:0] loadrd_i,
    input memEn_i,
    input memWr_i,
    input signed [31:0] op1_i,
    input signed [31:0] op2_i,
    input signed [31:0] aluResult,
    input signed [31:0] loadResult,
    output logic signed [31:0] op1_o,
    output logic signed [31:0] op2_o,
    output logic stall 
    );
    
    logic [4:0] rs1_i, rs2_i;
    logic stall_n;
    
    always_comb
    begin
        if (reset_i)
        begin
            stall_n = 0;
            op1_o = 0;
            op2_o = 0;
        end
        else if (stall == 1)
            begin
                if((rs1_i == loadrd_i) & (rs1_i != 0))
                        begin
                            stall_n = 0;
                            op1_o = loadResult;
                            op2_o = op2_i;
                        end
                        else if ((rs2_i == loadrd_i) & (rs2_i != 0))
                        begin
                            stall_n = 0;
                            op1_o = op1_i;
                            op2_o = loadResult;
                        end
                        else if ((rs1_i == loadrd_i) & (rs2_i == loadrd_i) & (rs1_i != 0) & (rs2_i != 0))
                        begin
                            stall_n = 0;
                            op1_o = loadResult;
                            op2_o = loadResult;
                        end
                        else
                        begin
                            stall_n = 0;
                            op1_o = op1_i;
                            op2_o = op2_i;
                        end
            end
        else if ((memEn_i == 0) & (memWr_i == 0))
        begin
            stall_n = 0;
            if((rs1_i == alurd_i) & (rs1_i != 0))
            begin
                op1_o = aluResult;
                op2_o = op2_i;
            end
            else if ((rs2_i == alurd_i) & (rs2_i != 0))
            begin
                op1_o = op1_i;
                op2_o = aluResult;
            end
            else if ((rs1_i == alurd_i) & (rs2_i == alurd_i) & (rs1_i != 0) & (rs2_i != 0))
            begin
                op1_o = aluResult;
                op2_o = aluResult;
            end
            else
            begin
            op1_o = op1_i;
            op2_o = op2_i;
            end
        end
        else if ((memEn_i == 1) & (memWr_i == 0))
        begin
            if((rs1_i == alurd_i) & (rs1_i != 0))
            begin
                stall_n = 1;
                op1_o = 0;
                op2_o = 0;
            end
            else if ((rs2_i == alurd_i) & (rs2_i != 0))
            begin
                stall_n = 1;
                op1_o = 0;
                op2_o = 0;
            end
            else if ((rs1_i == alurd_i) & (rs2_i == alurd_i) & (rs1_i != 0) & (rs2_i != 0))
            begin
                stall_n = 1;
                op1_o = 0;
                op2_o = 0;
            end
            else
            begin
                stall_n = 0;
                op1_o = op1_i;
                op2_o = op2_i;
            end
        end
        else
        begin
            stall_n = 0;
            op1_o = op1_i;
            op2_o = op2_i;
        end
    end
    
    always @(posedge clk_i, posedge reset_i)
    begin
        if(reset_i)
        begin
            rs1_i <= 0;
            rs2_i <= 0;
            stall <= 0;
        end
        else
        begin
            stall <= stall_n;
            rs1_i <= rs1;
            rs2_i <= rs2;
        end
    end
endmodule
