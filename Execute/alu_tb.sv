module alu_tb();
     logic [31:0] rs1, rs2;
     logic [3:0] ALU_control;
     wire [31:0] ALU_result;
     
    /* logic clk;
     initial begin
         clk = 1;
             forever
             begin
                 #10;
                 clk = ~clk;
             end
     end */                                                                                                                                                                                                                                                                                          
         
    // Instantiating ALU module
    //alu ALU_module(
    // rs1, rs2, ALU_control, ALU_result);
    alu ALU_module(
    .r1(rs1),
    .r2(rs2),
    .alu_control(ALU_control),
    .alu_result(ALU_result));

    // Setting up output waveform
    initial 
    begin
        $dumpfile("output_wave.vcd");
        $dumpvars(0, alu_tb);
    end

    //set different values to test few inputs
    initial 
    begin
        rs1= 30; rs2= 15; ALU_control=4'b0000;  //A+B = 45
        #10
        rs1= 16; rs2= 1; ALU_control=4'b0001;  //A<<1 = 32
        #10
        rs1= 30; rs2= 15; ALU_control=4'b0010; //SLT A < B = 0
        #10
        rs1= 15; rs2= 30; ALU_control=4'b0010; //STL A < B = 1
        #10
        rs1= 30; rs2= 15; ALU_control=4'b0011; //SLTI A < B = 0
        #10
        rs1= 15; rs2= 30; ALU_control=4'b0011; //SLTI A < B = 1
        #10
        rs1= 10; rs2= 5; ALU_control=4'b0100; //A XOR B = 15
        #10
        rs1= 16; rs2= 1; ALU_control=4'b0101;  //A>>1 = 8 
        #10
        rs1= 10; rs2= 5; ALU_control=4'b0110;  //A OR B = 15 
        #10
        rs1= 10; rs2= 5; ALU_control=4'b0111;  //A AND B = 0 
        #10
        rs1= 30; rs2= 15; ALU_control=4'b1000; //A - B = 15
        #10
        rs1= 30; rs2= 2; ALU_control=4'b1001;  // 
        #10
        rs1= 30; rs2= 15; ALU_control=4'b1010; //
    end

    initial
    #1000 $finish;

endmodule

