`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2023 00:02:04
// Design Name: 
// Module Name: programMemory
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


module programMemory(
    input [31:0] addr_i,
    output logic [31:0] data_o
    );
    
    reg [7:0] memory[127:0];
    
    initial
        begin
            $readmemh("helloworld.mem", memory);
            //data_o = 0;
        end
        
    assign data_o = (addr_i < 127) ? {memory[addr_i[6:0]+3],memory[addr_i[6:0]+2],memory[addr_i[6:0]+1],memory[addr_i[6:0]]} : 32'b0;

endmodule
