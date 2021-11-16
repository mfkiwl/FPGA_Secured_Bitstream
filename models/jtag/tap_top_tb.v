//------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------
//
//      File Name       : tap_top_tb.v
//      Brief           : testbench for JTAG
//
//------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------
//

`timescale 1ns/10ps     // time-unit = 1ns, precision = 10ps
`default_nettype none

module tap_top_tb;

	reg  	clk = 1'b0;	

    //simulation parameters
    localparam period       = 20;
    localparam halfperiod   = 10;

	reg tms  		        = 1'b1;
	reg	tck  		        = 1'b0;
	reg	tdi  		        = 1'b0;
	reg	trst 		        = 1'b0;

    
    //tap initialization
	tap_top uut
	(
	.tms_pad_i               (tms),
	.tck_pad_i               (clk), 
	.trst_pad_i             (trst),    
	.tdi_pad_i               (tdi),      
	.tdo_pad_o                  (), 
    .tdo_padoe_o                (),
        
	.shift_dr_o                 (),
	.pause_dr_o                 (),
	.update_dr_o                (),
	.capture_dr_o               (),

	.extest_select_o            (),
	.sample_preload_select_o    (),
	.mbist_select_o             (),
	.debug_select_o             (),
    .pmu_select_o               (),

	.tdo_o                      (),
    .pmu_enable                 (),
    .pmu_tck_o                  (),

	.debug_tdi_i                (),
	.bs_chain_tdi_i             (),
	.mbist_tdi_i                (),
    .pmu_tdi_i                  ()

	);


    reg [3:0] bitstream = 4'b1011;
    integer i;


    //start of simulation
    initial   
    begin
    clk = 0;
    forever
        #halfperiod clk = ~clk;
    end
    
    initial begin
        //reset to initiate tap logic
        trst <= 1'b1;
        #halfperiod
        trst <= 1'b0; 
       
        //----------------------------
        // Configure JTAG FSM
        // ---------------------------
        #period
        tms  <= 1'b0;
        #period
        tms  <= 1'b1;
        #period
        #period
        tms  <= 1'b0;
        #period
        #period
        #period
        tdi  <= 1'b1;
        #period
        tdi  <= 1'b0;
        #period 

        tdi  <= 1'b1;
        tms  <= 1'b1;
        #period         // shift_ir       -> exit_ir
        tdi  <= 1'b0;
        #period         // exit_ir        -> update_ir
        #period         // update_ir      -> select_dr_scan
        tms  <= 1'b0;
        #period         // select_dr_scan -> capture_dr  
        #period         // capture_dr     -> shift_dr     at this point tap is configured in bypass mode and data can be shifted from in to out thru bypass reg:x
        #period         // 0 keeps tap in shift_dr

        
        for(i = 0; i < 5; i = i + 1)
            begin
            if(i < 4) begin
            tdi = bitstream[i];
                #period;
            end
            else if(i == 4) begin
                tdi = 0; end
            end
        // end of message
         
        //drive tms high for at least 5 cycles = reset
        tms  <= 1'b1;
        tdi  = 0;
        #period
        #period
        #period
        #period
        #period
        #period
        $stop; 
    end

endmodule

