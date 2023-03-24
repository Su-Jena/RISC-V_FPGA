`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2023 11:15:24
// Design Name: 
// Module Name: fifo
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


module fifo 
    (
        input clk_i,        
        input reset_i,        
        input wren_i,       
        input [7:0] data_i,        
        input rden_i,        
        output [7 : 0] data_o 
    );

logic [7:0] data [32];        
logic [4:0] wrptr, rdptr;
logic [5:0] dcount;
      
logic wr_en, rd_en, full, empty;

always @ (posedge clk_i, posedge reset_i) begin

   if (reset_i) begin             
      data   <= '{default: '0} ;
      wrptr  <= 0;
      rdptr  <= 0;      
      dcount <= 0;
   end

   else begin 
      if (wr_en) begin 
         data [wrptr] <= data_i ;       
         if (wrptr == 31) begin
            wrptr <= 0               ;         
         end
         else begin
            wrptr <= wrptr + 1    ;                 
         end
      end
      if (rd_en) begin         
         if (rdptr == 31) begin
            rdptr <= 0               ;        
         end
         else begin
            rdptr <= rdptr + 1    ;                   
         end
      end
      if (wr_en && !rd_en) begin              
         dcount <= dcount + 1 ;
      end                    
      else if (!wr_en && rd_en) begin          
         dcount <= dcount - 1 ;         
      end
   end
end


assign full      = (dcount == 32) ? 1'b1 : 0 ;
assign empty     = (dcount == 0) ? 1'b1 : 0 ;

assign wr_en     = wren_i & !full;  
assign rd_en      = rden_i & !empty;

assign data_o    = data[rdptr];
endmodule
