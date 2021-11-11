






`timescale 1ns / 10ps


module nv_memory_tb;

    reg clk = 1'b0;

    localparam period     = 20;
    localparam halfperiod = 10;

    reg mem_rw;
    reg [7 :0] mem_addr_in;
    reg [63:0] mem_data_in;
    
    nv_memory uut
    (
    .fpga_clk(clk),
    .mem_erase(),
    .mem_rw(mem_rw),
    .mem_addr_in(mem_addr_in),
    .mem_data_in(mem_data_in),
    .mem_data_out()
    );

    initial
    begin
        clk = 0;
        forever
            #halfperiod clk = ~clk;
    end
    
    initial 
    begin
    mem_rw = 1'b0;
    #period;
    #period;
    
    mem_addr_in =  8'd0;
    mem_data_in = 64'd256;

    #period;
    
    mem_addr_in =  8'd1;
    mem_data_in = 64'd555;

    #period;

    mem_addr_in =  8'd200;
    mem_data_in = 64'd2560;

        
    #period;
    mem_addr_in = 8'd0;
    mem_rw = 1'b1;

    #period;

    mem_addr_in = 8'd1;

    #period;

    mem_addr_in = 8'd200;

    #period;
    #period;
    #period;
    $stop;
    end
    
endmodule
