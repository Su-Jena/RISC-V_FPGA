`timescale 1ns / 1ps
module alu (
  input signed [31:0] r1
, input signed [31:0] r2
, input [3:0] alu_control
, output logic signed [31:0] alu_result
);

always_comb
    begin
        case(alu_control)
            4'b0000: alu_result = r1 + r2;
            4'b0001: alu_result = r1<<r2[4:0]; //shift left logical SLL
            4'b0010: begin
            if(r1<r2)
                alu_result = 1;
            else
                alu_result = 0;
                end 
            4'b0011: begin
                if($unsigned(r1) < $unsigned(r2))
                    alu_result = 1;
                else
                    alu_result = 0;
                end 
            4'b0100: alu_result = r1^r2;
            4'b0101: alu_result = r1 >> r2[4:0]; //shift right logical SRL
            4'b0110: alu_result = r1 | r2;
            4'b0111: alu_result = r1 & r2;
            4'b1000: alu_result = r1 - r2;
            4'b1001: alu_result = $signed(r1) >>> r2[4:0]; //shift right arithmetic SRA //Need to check this
            4'b1010: alu_result = r1 << r2; //shift left logical immediate SLLI
            4'b1011: alu_result = r1 >> r2; //shift right logical immediate SRLI
            4'b1100: alu_result = $signed(r1) >>> r2; //shift right arithmetic immediate SRAI //Need to check this
            4'b1101: alu_result = r1 << 12; //LUI
            default: alu_result = 0;
            
        endcase
    end  
endmodule
