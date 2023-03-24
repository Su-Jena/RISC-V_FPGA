module registerFile_tb ();
    logic [4:0] read_reg_num1;
    logic [4:0] read_reg_num2;
    logic [4:0] write_reg;
    logic [31:0] write_data;
    logic [31:0] read_data1;
    logic [31:0] read_data2;
    logic regwrite;
    logic clock;
    logic reset;
   
    // Instantiating register file module
    registerFile REG_FILE_module(
    .rs1_address(read_reg_num1),
    .rs2_address(read_reg_num2),
    .write_address(write_reg),
    .write_data(write_data),
    .rs1(read_data1),
    .rs2(read_data2),
    .write_enable(regwrite));

    // Setting up output waveform
    initial begin
        $dumpfile("output_wave.vcd");
        $dumpvars(0, registerFile_tb);
    end

    // Initializing the registers
    initial begin
        reset = 0;
        #10 reset = 1;
    end

    // Writing values to different registers
    initial begin
        regwrite = 0;
        #10
        regwrite = 1; write_data = 20; write_reg = 1;
        #10
        regwrite = 1; write_data = 30; write_reg = 2;
        #10
        regwrite = 1; write_data = 40; write_reg = 3;
        #10;
        regwrite = 1; write_data = 50; write_reg = 1;
        #10;
        
    end

    // Reading values of different registers
    initial begin
        
        #50 read_reg_num1 = 0; read_reg_num2 = 0;
        #50 read_reg_num1 = 4; read_reg_num2 = 6;
        #50 read_reg_num1 = 0; read_reg_num2 = 1;
        #50 read_reg_num1 = 1; read_reg_num2 = 2;
        #50 read_reg_num1 = 2; read_reg_num2 = 3;
    
    end

    // Setting up clock
    initial begin
        
        clock = 0;
        forever #10 clock = ~clock;

    end

    initial begin
        #1000 $finish;
    end

endmodule