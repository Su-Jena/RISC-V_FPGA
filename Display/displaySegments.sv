`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.03.2023 16:56:22
// Design Name: 
// Module Name: displaySegments
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


module displaySegments(
    input [7:0] hexInput,
    output logic [6:0] segments
    );
    
always_comb
begin
    case(hexInput)
    8'h68: segments = 9;
    8'h65: segments = 6;
    8'h6C: segments = 71;
    8'h6F: segments = 64;
    8'hA0: segments = 119;
    8'h77: segments = 65;
    8'h72: segments = 8;
    8'h64: segments = 33;
    default: segments = 127;
    endcase
end
endmodule
