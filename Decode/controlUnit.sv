`timescale 1ns / 1ps

module controlUnit(
    input clk_i,
    input reset_i,
    input [31:0] instruction_i,
    input [31:0] pc_i,
    input [31:0] write_data,
    input [4:0] wbAddr_i,
    input wbEnable_i,
    input stall,
    output logic [3:0] aluControl_o,
    output logic signed [31:0] op1,
    output logic signed [31:0] op2,
    output logic mem_en,
    output logic mem_wr,
    output logic [10:0] mem_addr,
    output logic branch_en,
    output logic signed [19:0] pc_imm,
    output logic displayEn_o,
    output logic [4:0] wbAddr_o,
    output logic wbEnable_o,
    output logic [4:0] rs1_address, 
    output logic [4:0] rs2_address
);

logic [6:0] opcode, funct7;
logic [2:0] funct3;

logic signed [31:0] rs1, rs2, immediate;
logic signed [19:0] pcIMM;
logic [3:0] alu_control;

logic [4:0] rf_writeAddress;
logic [11:0] memoryAddress;
logic rf_writeEnable, outputEnable;

registerFile RF(
     .write_enable(wbEnable_i)                        
    ,.rs1_address(rs1_address)
    ,.rs2_address(rs2_address)
    ,.write_address(wbAddr_i)                       //rf_writeAddress
    ,.write_data(write_data)
    ,.rs1(rs1)
    ,.rs2(rs2)
    ,.reset_i(reset_i)
    ,.clk_i(clk_i)
);

assign opcode = instruction_i[6:0];
assign funct7 = instruction_i[31:25];
assign funct3 = instruction_i[14:12];

always_comb
    begin
        if (reset_i)
        begin
            alu_control = 4'b1111;
            rs1_address = 0;
            rs2_address = 0;
            pcIMM = 0;
            rf_writeAddress = 0;
            memoryAddress = 0;
            rf_writeEnable = 0;
            outputEnable = 0;
            immediate = 0;
        end
        else if (opcode == 7'b0110011) 
        begin 
            case(funct3)
            0: begin
                if(funct7==0)
                alu_control= 4'b0000; //ADD
                else
                alu_control= 4'b1000; //SUB
            end
            1: alu_control= 4'b0001; //SLL
            2: alu_control= 4'b0010; //SLT
            3: alu_control= 4'b0011;//SLTU
            4: alu_control= 4'b0100; // XOR
            5: begin
                if(funct7==0)
                alu_control= 4'b0101; //SRL
                else
                alu_control= 4'b1001; //SRA
            end
            6: alu_control= 4'b0110; // OR
            7: alu_control= 4'b0111; // AND
            default: alu_control = 4'b1111;
            endcase
            rs1_address = instruction_i[19:15];
            rs2_address = instruction_i[24:20];
            immediate = 0;
            pcIMM = 0;
            rf_writeAddress = instruction_i [11:7];
            memoryAddress = 0;
            rf_writeEnable = 1;
            outputEnable = 0;
        end

        else if (opcode == 7'b0010011) 
        begin // I-type instructions
       // regwrite_control = 1;
            case(funct3)
            0: alu_control= 4'b0000; //ADDI
            1: alu_control= 4'b0001; //SLLI
            2: alu_control= 4'b0010; //SLTI
            3: alu_control= 4'b0011;//SLTIU
            4: alu_control= 4'b0100; // XORI
            5: begin
                if(funct7==0)
                alu_control=  4'b1011; //SRLI
                else
                alu_control=  4'b1100; //SRAI
            end
            6: alu_control= 4'b0110; // ORI
            7: alu_control= 4'b0111; // ANDI
            default: alu_control = 4'b1111;
            endcase
            rs1_address = instruction_i[19:15];
            rs2_address = 0;
            pcIMM = 0;
            rf_writeAddress = instruction_i [11:7];
            memoryAddress = 0;
            rf_writeEnable = 1;
            outputEnable = 0;
            if (instruction_i [31] == 0)
                immediate = {20'b0, instruction_i[31:20]};
            else
                immediate = {20'b11111111111111111111, instruction_i[31:20]};
        end

        else if (opcode == 7'b0110111)  //LUI
           begin 
           alu_control=  4'b1101;
           rs1_address = 0;
           rs2_address = 0;
           immediate = 0;
           pcIMM = 0; 
           rf_writeAddress = instruction_i [11:7];
           memoryAddress = 0;
           rf_writeEnable = 1;
           outputEnable = 0;
           end
           
        
        else if (opcode == 7'b0000011)  //Load
           begin
           alu_control = 4'b0000;
           rs1_address = instruction_i[19:15];
           rs2_address = 0;
           pcIMM = 0;
           rf_writeAddress = instruction_i [11:7];
           memoryAddress = rs1[11:0] + $signed(instruction_i [31:20]);
           rf_writeEnable = 1;
           outputEnable = 0;
           if (instruction_i [31] == 0)
                immediate = {20'b0, instruction_i[31:20]};
           else
                immediate = {20'b11111111111111111111, instruction_i[31:20]};
           end

        else if (opcode == 7'b0100011)  //Store
           begin
           alu_control= 4'b0000;
           rs1_address = instruction_i[19:15];
           rs2_address = instruction_i[24:20];
           pcIMM = 0;
           rf_writeAddress = 0;
           memoryAddress = rs1[11:0] + $signed({instruction_i [31:25], instruction_i [11:7]});
           rf_writeEnable = 0;
           outputEnable = 0;
           immediate = 0;
           end
           
          else if (opcode == 7'b1101111)  //JAL
           begin
                alu_control = 4'b0000;
                rs1_address = 0;
                rs2_address = 0;
                pcIMM = {instruction_i [31], instruction_i [19:12], instruction_i [20],instruction_i [30:21]};
                pcIMM = pcIMM <<< 1; //Need to check this for signed
                rf_writeAddress = instruction_i [11:7];
                memoryAddress = 0;
                rf_writeEnable = 1;
                outputEnable = 0;
                immediate = 0;
           end
           
           else if (opcode == 7'b1100111)  //JALR
                      begin
                           alu_control = 4'b0000;
                           rs1_address = instruction_i[19:15];
                           rs2_address = 0;
                           pcIMM = {8'b0,instruction_i [31], instruction_i [7], instruction_i [30:25],instruction_i [11:8]};             
                           rf_writeAddress = instruction_i [11:7];
                           memoryAddress = 0;
                           rf_writeEnable = 1;
                           outputEnable = 0;
                           immediate = 0;
                      end
           else if (opcode == 7'b1100011)  //Branching
                begin
                    alu_control = 4'b1111;
                    rs1_address = instruction_i[19:15];
                    rs2_address = instruction_i[24:20];
                    pcIMM[11:0] = {instruction_i [31], instruction_i [7], instruction_i [30:25],instruction_i [11:8]};
                    pcIMM = pcIMM <<< 1;
                    rf_writeAddress = 0;
                    memoryAddress = 0;
                    rf_writeEnable = 0;
                    outputEnable = 0;
                    immediate = 0;
                    if (pcIMM[12] == 0)
                        pcIMM = {8'b0, pcIMM[11:0]};  // Need to handle this
                    else
                        pcIMM = {8'b11111111, pcIMM[11:0]};
                end
           else if (opcode == 7'b1110011)  //ecall
           begin
                alu_control = 4'b0000;
                rs1_address = 5'b10001;
                rs2_address = 0;
                pcIMM = 0;
                rf_writeAddress = 0;
                memoryAddress = 0;
                rf_writeEnable = 0;
                outputEnable = 1;
                immediate = 0;
           end
           else
           begin
                alu_control = 4'b1111;
                rs1_address = 0;
                rs2_address = 0;
                pcIMM = 0;
                rf_writeAddress = 0;
                memoryAddress = 0;
                rf_writeEnable = 0;
                outputEnable = 0;
                immediate = 0;
           end
    end


    always @ (posedge clk_i, posedge reset_i)
    begin
        if (reset_i == 1 | stall == 1) begin
            aluControl_o <= 0;
            op1 <= 0;
            op2 <= 0;
            mem_en <= 0;
            mem_wr <= 0;
            mem_addr <= 0;
            branch_en <= 0;
            pc_imm <= 0;
            displayEn_o <= 0;
            wbAddr_o <= 0;
            wbEnable_o <= 0;
        end
        else begin
            wbAddr_o <= rf_writeAddress;
            wbEnable_o <= rf_writeEnable;
            if (opcode == 7'b0110011)    //ALU
            begin
                op1 <= rs1;
                op2 <= rs2;
                aluControl_o <= alu_control;
                mem_en <= 0;
                mem_wr <= 0;
                mem_addr <= 0;
                branch_en <= 0;
                pc_imm <= 0;
                displayEn_o <= 0;
            end
            else if(opcode == 7'b0010011)  //ALU
            begin
                op1 <= rs1;
                op2 <= immediate; // Need to check this
                aluControl_o <= alu_control;
                mem_en <= 0;
                mem_wr <= 0;
                mem_addr <= 0;
                branch_en <= 0;
                pc_imm <= 0;
                displayEn_o <= 0;
            end
            else if(opcode == 7'b0110111)  //ALU
            begin
                op1 <= {12'b0,instruction_i[31:12]};
                op2 <= 0;
                aluControl_o <= alu_control;
                mem_en <= 0;
                mem_wr <= 0;
                mem_addr <= 0;
                branch_en <= 0;
                pc_imm <= 0;
                displayEn_o <= 0;
            end
            else if(opcode == 7'b0000011) //Load
            begin
                op1 <= rs1;
                op2 <= immediate;
                aluControl_o <= 0;
                mem_en <= 1;
                mem_wr <= 0;
                mem_addr <= memoryAddress[10:0];
                branch_en <= 0;
                pc_imm <= 0;
                displayEn_o <= 0;
            end
           else if(opcode == 7'b0100011) //Store
            begin
                  op1 <= rs2;
                  op2 <= 0;
                  aluControl_o <= alu_control;
                  mem_en <= 1;
                  mem_wr <= 1;
                  mem_addr <= memoryAddress[10:0];
                  branch_en <= 0;
                  pc_imm <= 0;
                  displayEn_o <= 0;
            end
            else if (opcode == 7'b1101111)       //JAL
            begin
                branch_en <= 1;
                pc_imm <= pcIMM;
                op1 <= pc_i;
                op2 <= 4;
                aluControl_o <= alu_control;
                mem_en <= 0;
                mem_wr <= 0;
                mem_addr <= 0;
                displayEn_o <= 0;
            end
            else if (opcode == 7'b1100111)  //JALR
            begin
                branch_en <= 1;
                pc_imm <= rs1[19:0] + pcIMM;
                op1 <= 0;
                op2 <= 0;
                aluControl_o <= alu_control;
                mem_en <= 0;
                mem_wr <= 0;
                mem_addr <= 0;
                displayEn_o <= 0;
            end
            else if (opcode == 7'b1100011)  //Branching
            begin
                op1 <= 0;
                op2 <= 0;
                aluControl_o <= alu_control;
                pc_imm <= pcIMM;
                mem_en <= 0;
                mem_wr <= 0;
                mem_addr <= 0;
                displayEn_o <= 0;
            case(funct3)
                        0: begin branch_en <= (rs1 == rs2) ? 1 : 0; end    //BEQ
                        1: begin branch_en <= (rs1 != rs2) ? 1 : 0; end    //BNE
                        4: begin branch_en <= (rs1  < rs2) ? 1 : 0; end    //BLT
                        5: begin branch_en <= (rs1 >= rs2) ? 1 : 0; end    //BGE
                        6: begin branch_en <= ($unsigned(rs1)  < $unsigned(rs2)) ? 1 : 0; end    //BLTU
                        7: begin branch_en <= ($unsigned(rs1) >= $unsigned(rs2)) ? 1 : 0; end    // BGEU
                        default: branch_en <= 0;
            endcase
            end
            else if (opcode == 7'b1110011) //ecall
            begin
                op1 <= rs1;
                op2 <= immediate;
                aluControl_o <= alu_control;
                mem_en <= 0;
                mem_wr <= 0;
                mem_addr <= 0;
                branch_en <= 0;
                pc_imm <= 0;
                displayEn_o <= 1;
            end
            else
            begin
                op1 <= 0;
                op2 <= 0;
                aluControl_o <= alu_control;
                mem_en <= 0;
                mem_wr <= 0;
                mem_addr <= 0;
                branch_en <= 0;
                pc_imm <= 0;
                displayEn_o <= 0;
            end
        end
    end
endmodule