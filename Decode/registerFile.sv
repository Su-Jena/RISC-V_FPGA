`timescale 1ns / 1ps

module registerFile(
      input write_enable
    , input clk_i  
    , input reset_i
    , input [4:0] rs1_address
    , input [4:0] rs2_address
    , input [4:0] write_address
    , input [31:0] write_data
    , output logic [31:0] rs1
    , output logic [31:0] rs2
    );

    reg [31:0] x[0:31];
    integer i;
    
    always @(posedge clk_i, posedge reset_i)
    begin
        if (reset_i)
          begin
            for(i=0;i<=31;i=i+1)
                begin x[i] <= 32'b0; end
          end
        else if (write_enable)
                begin               
                x[write_address] <= write_data;
                x[0] <= 0;
                end
        else
        begin
            x[0] <= 0;
        end
    end
    
    always @(negedge clk_i, posedge reset_i)
    begin
        if (reset_i)
          begin
            rs1 <= 0;
            rs2 <= 0;
          end
        else begin
                rs1 <= x[rs1_address];
                rs2 <= x[rs2_address];
                end
    end
endmodule
