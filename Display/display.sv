`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.02.2023 20:56:04
// Design Name: 
// Module Name: display
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
module display(
    input clk_i,
    input reset_i,
    input [7:0] hex_i,
    input displayEn_i,
    output logic [6:0] display_o
    );
    
    logic [7:0] buffer[31:0], displayChar;
    logic [31:0] counter;
    logic outputEnable;
    
    displaySegments CA (
         .segments(display_o)
        ,.hexInput(displayChar)
        );
    
    fifo FIFO (
         .clk_i(clk_i)
        ,.reset_i(reset_i)
        ,.data_i(hex_i)
        ,.wren_i(displayEn_i)
        ,.rden_i(outputEnable)
        ,.data_o(displayChar)
        );
        
    always @ (posedge clk_i, posedge reset_i)
    begin
    if (reset_i)
    begin
        counter <= 0;
        outputEnable <= 0;
    end
    else if (counter == 200)
        begin
                outputEnable <= 1;
                counter <= 0;
        end
    else
        begin
        outputEnable <= 0;
        counter <= counter + 1'b1;
        end
    end
endmodule
