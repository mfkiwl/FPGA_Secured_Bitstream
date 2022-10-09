
module functional_load_bitstream_sha_aes;


    reg [256:0] bitstream0         = 256'h3ad77bb40d7a3660a89ecaf32466ef973ad77bb40d7a3660a89ecaf32466ef97;
    reg [255:0] bitstream_digest   = 256'hd8c9fae7af99ac14bffa31387cd25a3a8315ea1dcb0cf06b5ba8f841c363fca5;
    
    reg [255:0] pmu_header0    = 256'hff484953495354480123456789abcdef0123456789abcdefff4849530012009a; // 548  bits *
    reg [255:0] digest0        = 256'h376ed083cc2122d984f8fff70a1f60931af319db187695aaca15b05851457f4b;

    reg [255:0] pmu_header1    = 256'hff484953495354480123456789abcdef0123456789abcdefff484953001400fa; // 936  bits *
    reg [255:0] digest1        = 256'h3c0250c3bd6df84eb8f7070e5c605483a7d2d345a9348e6d2a541d3387bdd0cb;

    reg [255:0] pmu_header2    = 256'hff484953495354480123456789abcdef0123456789abcdefff4849530009823a; // 2250 bits *
    reg [255:0] digest2       = 256'hcf1e2005e057ae11fc79bb80bcf22e9bd8f80315c760b6e928abb1b4fa5bb633;

    // PMU HEADER
    reg [31:0] load_key_pmu_header = 32'h00000005;

    // AES KEY
    reg [127:0]  key0         = 128'h2b7e151628aed2a6abf7158809cf4f3c;

    localparam period     = 10;
    localparam halfperiod = 5;

    // MEM Wires
    wire mem_clk, mem_we;
    wire [31:0] mem_data_i, mem_data_o;
    wire [7:0]  mem_address;
    
    reg clk = 0; 
    // FPGA Wires
    wire config_enable_w;
    wire prog_clk;
    //wire pReset;
    //wire data_o;
    wire ccff_w;
    wire pReset;

     // AES WIRES
    wire aes_reset_n_w;
    wire aes_reset_dec_w;
    wire aes_init_w;
    wire aes_next_w;
    wire aes_wc_w;
    wire aes_we_w;
    wire [1:0]  aes_address_w;
    wire [31:0] aes_write_data_w;
    wire [31:0] aes_read_data_w;

    // SHA WIRES
    wire sha_reset_n_w;
    wire sha_cs_w;
    wire sha_we_w;
    wire sha_wc_w;
    wire [2:0] sha_address_w;
    wire [31:0] sha_write_data_w;
    wire sha_digest_valid_w;

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

    wire fpga_clk_en;

    //this needs to be added as a pmu output:
    reg fpga_o_clk_en = 0;





    wire [0:`FPGA_IO_SIZE - 1] gfpga_pad_EMBEDDED_IO_HD_SOC_IN;
    wire [0:`FPGA_IO_SIZE - 1] gfpga_pad_EMBEDDED_IO_HD_SOC_OUT;
    wire [0:`FPGA_IO_SIZE - 1] gfpga_pad_EMBEDDED_IO_HD_SOC_DIR;

	assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[0:`FPGA_IO_SIZE - 1] = {`FPGA_IO_SIZE {1'b0}};
	assign gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[0:`FPGA_IO_SIZE - 1] = {`FPGA_IO_SIZE {1'b0}};

         pmu pmu_
        (
        .clk_i(clk),
        .tms_i(tms_i),
        .tck_i(clk),
        .rst_i(rst_i),
        .tdi_i(tdi_i),
        .td_o(),
        .config_enable(config_enable_w),
        .progclk_o(prog_clk),
        .pReset_o(pReset),
        .fpga_rst(fpga_rst),
        .fpga_clk_en(fpga_clk_en),
        .data_o(data_o),
        .ccff_tail_i(ccff_wire),
        .key_ready(),
        .core_ready(),
        .locked(),
        .aes_reset_n(aes_reset_n_w),
        .reset_dec(aes_reset_dec_w),
        .aes_init(aes_init_w),
        .aes_next(aes_next_w),
        .aes_wc(aes_wc_w),
        .aes_we(aes_we_w),
        .aes_address(aes_address_w),
        .aes_write_data(aes_write_data_w),
        .aes_read_data(aes_read_data_w),
        .aes_result_valid(aes_result_valid_w),
        .aes_key_ready(aes_ready_w),
        .sha_reset_n_w(sha_reset_n_w),
        .sha_cs_w(sha_cs_w), 
        .sha_we_w(sha_we_w),
        .sha_wc_w(sha_wc_w),
        .sha_address_w(sha_address_w),
        .sha_write_data_w(sha_write_data_w),
        .sha_digest_valid_w(sha_digest_valid_w)
   
        );

        aes aes128_
        (
        .clk(clk),
        .reset_n(aes_reset_n_w),
        .reset_dec(aes_reset_dec_w),
        .init(aes_init_w),
        .next(aes_next_w),
        .wc(aes_wc_w),
        .we(aes_we_w),
        .address(aes_address_w),
        .write_data(aes_write_data_w),
        .read_data(aes_read_data_w),
        .key_ready(aes_ready_w),
        .result_valid(aes_result_valid_w)
        );
       
        sha256 sha256_
        (
        .clk(clk),
        .reset_n(sha_reset_n_w),
        .cs(sha_cs_w),
        .we(sha_we_w),
        .wc(sha_wc_w),
        .address(sha_address_w),
        .write_data(sha_write_data_w),
        .digest_valid(sha_digest_valid_w)
        );

        fpga_top fpga_top_
        (
        .clk(clk & fpga_o_clk_en),
        .reset(fpga_rst), 
        .config_enable(config_enable_w),
        .pReset(pReset),
        .prog_clk(prog_clk),  ///prog_clk
        .Test_en(test_en),
        .IO_ISOL_N(IO),
		.gfpga_pad_sofa_plus_io_SOC_IN(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[0:`FPGA_IO_SIZE - 1]),
		.gfpga_pad_sofa_plus_io_SOC_OUT(gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[0:`FPGA_IO_SIZE - 1]),
		.gfpga_pad_sofa_plus_io_SOC_DIR(gfpga_pad_EMBEDDED_IO_HD_SOC_DIR[0:`FPGA_IO_SIZE - 1]),        
        .ccff_head(data_o),
        .ccff_tail(ccff_wire)
        );


        
    integer i, j;


    initial begin
        clk = 0;
        forever
        #halfperiod clk = ~clk;
    end



    // JTAG HEADER/FOOTER ==================
    reg [11:0] tdi_header = 12'b001101100000;
    reg [4:0] tdi_footer  =  5'b00000;
    reg [11:0] tms_header = 12'b011000000110;
    reg [4:0] tms_footer  =  5'b11111;
    // JTAG HEADER/FOOTER ==================

    task load_key ();
    begin 
    #period;
    rst_i = 0;
    #period;
    rst_i = 1;

    //LOAD JTAG HEADER
    #period;

    for(i = 0; i < 12; i = i + 1)
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
    for(i = 0; i < 18; i = i + 1)
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
        

    task load_256_bits ();
        begin 
            for(i = 0; i < 256; i = i + 1)
            begin
                tms_i = 0;
                tdi_i = bitstream0[i];
                #period;
            end
        end
    endtask
    task load_digest ();
        begin 
            for(i = 0; i < 256; i = i + 1)
            begin
                tms_i = 0;
                tdi_i = bitstream_digest[i];
                #period;
            end
        end
    endtask


    // ==================================================
    // LOAD BITSTREAM: 0 ================================

    // RESET 
    task load_bitstream0 ();
    begin

    //LOAD JTAG HEADER
    #period;

    for(i = 0; i < 12; i = i + 1)
    begin
        tms_i = tms_header[i];
        tdi_i = tdi_header[i];
        #period;
    end
     // =================
    for(i = 0; i < 256; i = i + 1)
    begin
        tms_i = 0;
        tdi_i = pmu_header0[i];
        #period;

    end
    for(i = 0; i < 256; i = i + 1)
    begin
        tms_i = 0;
        tdi_i = digest0[i];
        #period;

    end


    load_256_bits;
    load_digest;
    load_256_bits;
    load_digest;
    load_256_bits;
    load_digest;

       
    //LOAD JTAG FOOTER
    for(i = 0; i < 5; i = i + 1)
    begin
        tms_i = tms_footer[i];
        tdi_i = tdi_footer[i];
        #period;
    end
    #(period * 20);
    // =================

    // LOAD BITSTREAM 0: ================================
    // ==================================================
    end
    endtask

    initial begin 

    load_key;
    load_bitstream0;
    //load_bitstream1;
    //load_bitstream2;



        
    $stop;
    end





endmodule