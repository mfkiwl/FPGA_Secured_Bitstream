`timescale 1 ns / 1 ps
`define UNIT_DELAY #10
`define FPGA_IO_SIZE 24


module functional_load_key;

    // PMU HEADER
    reg [31:0] load_key_pmu_header = 32'h00000005;

    // AES KEY
    reg [127:0]  key0         = 128'h0123456789abcdef0123456789abcdef;







    
    // LOAD KEY: AUTHENTICATION PASSING =================
    reg [255:0] sha_load_key0_passing      = 256'hff484953ff484953495354480123456789abcdef0123456789abcdef00000006;
    reg [255:0] sha_digest                 = 256'heb788faedebab8b1f59bfcb007bfed7b809c98a73acab61becccfb3d0435ca46;


 
  
    localparam period     = 100;
    localparam halfperiod = 50;
    reg clk = 1'b0;

    // MEM Wires
    wire mem_clk, mem_we;
    wire [31:0] mem_data_i, mem_data_o;
    wire [7:0]  mem_address;
    
    
    // FPGA Wires
    wire prog_clk;
    //wire pReset;
    //wire data_o;
    wire ccff_w;
    wire pReset;

    // TEST REGISTERS
    //
    //PMU
    reg tms_i    = 0;
    reg rst_i    = 1;
    reg tdi_i    = 0;
    //FPGA
    wire fpga_rst;
    //reg pReset     = 1;
    reg test_en    = 0;
    assign OUT = {23 {1'b0}};
    reg IO         = 0;
    reg p_clk = 0;
    wire data_o; 

 
    //this needs to be added as a pmu output:

    
    wire [0:`FPGA_IO_SIZE - 1] gfpga_pad_EMBEDDED_IO_HD_SOC_IN;
    wire [0:`FPGA_IO_SIZE - 1] gfpga_pad_EMBEDDED_IO_HD_SOC_OUT;
    wire [0:`FPGA_IO_SIZE - 1] gfpga_pad_EMBEDDED_IO_HD_SOC_DIR;

	assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[0:`FPGA_IO_SIZE - 1] = {`FPGA_IO_SIZE {1'b0}};
	assign gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[0:`FPGA_IO_SIZE - 1] = {`FPGA_IO_SIZE {1'b0}};

    reg fpga_o_clk_en = 0;
    
    
    pmu pmu_
        (
        .tms_i(tms_i),
        .tck_i(clk),
        .rst_i(rst_i),
        .tdi_i(tdi_i),
        .td_o(),
        .mem_data_i(mem_data_i),
        .mem_data_o(mem_data_o),
        .mem_address_o(mem_address),
        .mem_we_o(mem_we),
        .mem_clk_o(mem_clk),
        .progclk_o(prog_clk),
        .pReset_o(pReset),
        .fpga_rst(fpga_rst),
        .fpga_clk_en(fpga_clk_en),
        .data_o(data_o),
        .ccff_tail_i(ccff_wire),
        .key_ready(),
        .core_ready(),
        .locked()
        );

        mem mem_
        (
        .clk(mem_clk),
        .we(mem_we),
        .data_i(mem_data_o),
        .address(mem_address),
        .data_o(mem_data_i)
        );

        fpga_top fpga_top_
        (
        .clk(clk & fpga_o_clk_en),
        .reset(fpga_rst), //and another wire coming from top caravel level
        .pReset(pReset),
        .prog_clk(prog_clk),  ///prog_clk
        .Test_en(test_en),
        .IO_ISOL_N(IO),
		.gfpga_pad_EMBEDDED_IO_HD_SOC_IN(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[0:`FPGA_IO_SIZE - 1]),
		.gfpga_pad_EMBEDDED_IO_HD_SOC_OUT(gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[0:`FPGA_IO_SIZE - 1]),
		.gfpga_pad_EMBEDDED_IO_HD_SOC_DIR(gfpga_pad_EMBEDDED_IO_HD_SOC_DIR[0:`FPGA_IO_SIZE - 1]),        
        .ccff_head(data_o),
        .ccff_tail(ccff_wire)
        );


        
    integer i;


    initial begin
        clk = 0;
        forever
        #halfperiod clk = ~clk;
    end


    // JTAG HEADER/FOOTER ==================
    reg [10:0] tdi_header = 11'b01101100000;
    reg [4:0] tdi_footer  =  5'b00000;
    reg [10:0] tms_header = 11'b11000000110;
    reg [4:0] tms_footer  =  5'b11111;
    // JTAG HEADER/FOOTER ==================

    


    // ======================================================
    // LOAD KEY =============================================

    // RESET 
    task load_key ();
    begin
   #period;
    rst_i = 0;
    #period;
    rst_i = 1;

    //LOAD JTAG HEADER
    #period;

    for(i = 0; i < 11; i = i + 1)
    begin
        tms_i = tms_header[i];
        tdi_i = tdi_header[i];
        #period;
    end
     // =================
    for(i = 0; i < 32; i = i + 1)
    begin
        tms_i = 0;
        tdi_i = load_key_pmu_header[i];
        #period;

    end
     // =================
    for(i = 0; i < 128; i = i + 1)
    begin
        tms_i = 0;
        tdi_i = key0[i];
        #period;
    end
    // NOP
    for(i = 0; i < 14; i = i + 1)
    begin
        tms_i = 0;
        tdi_i = 0;
        #period;
    end
    //LOAD JTAG FOOTER
    for(i = 0; i < 5; i = i + 1)
    begin
        tms_i = tms_footer[i];
        tdi_i = tdi_footer[i];
        #period;
    end
    #(period * 10);
    // =================
    end 
    endtask
    // LOAD KEY =============================================
    // ======================================================





    // ======================================================
    // LOAD KEY SHA: SHA AUTHENTICATION PASSING =============

    // RESET 
    task load_key_sha (); 
    begin
    #period;
    rst_i = 0;
    #period;
    rst_i = 1;

    //LOAD JTAG HEADER
    #period;

    for(i = 0; i < 11; i = i + 1)
    begin
        tms_i = tms_header[i];
        tdi_i = tdi_header[i];
        #period;
    end
     // =================
    for(i = 0; i < 256; i = i + 1)
    begin
        tms_i = 0;
        tdi_i = sha_load_key0_passing[i];
        #period;

    end
     // =================
    for(i = 0; i < 256; i = i + 1)
    begin
        tms_i = 0;
        tdi_i = sha_digest[i];
        #period;
    end
    #(period * 15);
    //LOAD JTAG FOOTER
    for(i = 0; i < 5; i = i + 1)
    begin
        tms_i = tms_footer[i];
        tdi_i = tdi_footer[i];
        #period;
    end
    #period;
    // =================
    end
    endtask
    // LOAD KEY SHA: SHA AUTHENTICATION PASSING =============
    // ======================================================
    
    initial begin 
    
    load_key;

    load_key_sha;

    
    $stop;
    end

endmodule 
