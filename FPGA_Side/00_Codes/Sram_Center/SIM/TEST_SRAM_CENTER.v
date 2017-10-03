`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:08:46 10/29/2015
// Design Name:   sram_center
// Module Name:   F:/Saleh/Saleh_Files/FPGA/Boards/02_AINGF V2/01_VerilogPRJ/CamCTRLR_SRAM_CENTER_V2/TEST_SRAM_CENTER.v
// Project Name:  CAM_CTRLR_SRAM_CENTER_V2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sram_center
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TEST_SRAM_CENTER;

	// Inputs
	reg clk_fast;
	reg pclk;
	reg href;
	reg vsync;
	reg [7:0] data;
	reg [15:0]dbg_instruction_input;
	
	// Outputs
	wire led_over_run;
	wire led_green;
	wire led_red;
	wire finished;
	wire dbg_vsync_oneshot;
	wire dbg_fifo_wr_en;
	wire dbg_fifo_wr_ack;
	wire dbg_fifo_full;
	wire dbg_fifo_overflow;
	wire dbg_rst_logic;
	wire dbg_rst_fifo;
	wire [15:0] dbg_fifo_dout;
	wire dbg_fifo_rd_en    ;
	wire dbg_fifo_empty    ;
	wire dbg_fifo_valid    ;
	wire dbg_fifo_underflow;
	 
	wire [19:0] SRAM1_A;
	wire [15:0] SRAM1_D; 
	wire SRAM1_nWE; 
	wire SRAM1_nOE;
	wire SRAM1_nCE1;
	wire SRAM1_CE2;
	wire SRAM1_nBHE;
	wire SRAM1_nBLE;
	
	wire  [15:0]   fdata	;	//  FIFO data lines.
	reg  [15:0]   rfdata	;	//  FIFO data lines.
	wire [1:0]    faddr	;	//  FIFO select lines
	wire          slrd	;	//	Read control line
	wire          slwr	;	//	Write control line
	reg           flagd	;	//	EP6 Full Flag
	reg           flaga	;	//	EP2 Empty Flag
	wire          sloe	;	//	Slave Output Enable Control 
	wire 			pktend;
	wire cam_reset_out;
	wire rst_logic;
	wire reset_n_cam_setup_out;
	wire reset_reg_buff_out;
	
	reg aa=0;
	
	
	// Instantiate the Unit Under Test (UUT)
	sram_center uut (
		.clk_fast(clk_fast), 				//ok
		//.button_capture(0),
		.button_g_reset(1'b1), 				//ok
		.reset_out(rst_logic), 						//ok
		.cam_reset_out(cam_reset_out), 		//ok
		
		
		.reset_n_cam_setup_out(reset_n_cam_setup_out),
		.reset_reg_buff_out(reset_reg_buff_out),
		.cam_setup_done_input(1'b1),
		
		.fdata	(fdata[15:0]), 	//ok	
		.faddr	(faddr), 		//ok
		.slrd	(slrd),	 		//ok
		.slwr	(slwr),	 		//ok
		.flagd	(flagd), 		//ok
		.flaga	(flaga), 		//ok
		.sloe	(sloe),	  		//ok		
		.pktend (pktend), 		//ok
		
		. ad( SRAM1_A )				, 		//ok
		. we_n( SRAM1_nWE )			, 		//ok
		. oe_n( SRAM1_nOE )			, 		//ok
		. dio_a( SRAM1_D )			, 		//ok
		. ce_a_n( SRAM1_nCE1 )		, 		//ok
		. ub_a_n( SRAM1_nBHE )		, 		//ok
		. lb_a_n( SRAM1_nBLE )		, 		//ok
		
		.pclk(pclk),  		//ok
		.href(href),  		//ok
		.vsync(vsync), 		//ok 
		.data(data),  		//ok
		.led_over_run(led_over_run),  		//ok
		.led_green(led_green),  			//ok
		.led_red(led_red),  				//ok
		.finished(finished),  				//ok
		.dbg_vsync_oneshot(dbg_vsync_oneshot), 		
		.dbg_fifo_wr_en(dbg_fifo_wr_en), 
		.dbg_fifo_wr_ack(dbg_fifo_wr_ack), 
		.dbg_fifo_full(dbg_fifo_full), 
		.dbg_fifo_overflow(dbg_fifo_overflow), 
		.dbg_rst_logic(dbg_rst_logic), 
		.dbg_rst_fifo(dbg_rst_fifo), 
		.dbg_fifo_dout(dbg_fifo_dout),
		.dbg_fifo_rd_en    (dbg_fifo_rd_en    ),
		.dbg_fifo_empty    (dbg_fifo_empty    ),
		.dbg_fifo_valid    (dbg_fifo_valid    ),
		.dbg_fifo_underflow(dbg_fifo_underflow),
		.dbg_instruction_input(dbg_instruction_input)
		
		
		
	);

	initial begin
		// Initialize Inputs
		dbg_instruction_input=16'b01000000_00000000;//aquire
		clk_fast = 0;
		pclk = 0;
		href = 0;
		vsync = 0;
		data = 8'hAA;
		flagd = 1'b1;
		flaga = 1'b1;

		// Wait 100 ns for global reset to finish
		#100;
        #18100;
		dbg_instruction_input=16'b01010000_00000000;//resetDeep
		#6000;
		dbg_instruction_input=16'b01000000_00000000;//aquire
		// Add stimulus here

	end
 
	always
	begin
		#0;
		pclk<=~pclk;
		#10;
	end
	
	always
	begin
		#2.304 clk_fast<=~clk_fast;
	end	
	
	always
	begin
		href<=1'b1;
		#800;
		href<=1'b0;
		#100;
	end	
	
	always
	begin
		vsync<=1'b1;
		#200;
		vsync<=1'b0;
		#7000;
	end	
	
/*	always
	begin
		if(sloe==0)
		begin
			aa=1'b1;
		end
	end */
//assign fdata = (aa==0)? 16'bz:rfdata;
 
endmodule

