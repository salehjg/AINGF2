`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:31:05 01/08/2016
// Design Name:   sync
// Module Name:   F:/Saleh/Saleh_Files/FPGA/Boards/02_AINGF_V2/01_VerilogPRJ/CamCTRLR_SRAM_CENTER_V2/00_Codes/Sync/SIM/TEST_sync.v
// Project Name:  CAM_CTRLR_SRAM_CENTER_V2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sync
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TEST_sync;

	// Inputs
	reg clk_dest;
	reg clk_src;
	reg flag_in_active_high;

	// Outputs
	wire flag_out_active_high;

	// Instantiate the Unit Under Test (UUT)
	sync uut (
		.clk_dest(clk_dest), 
		.clk_src(clk_src), 
		.flag_in_active_high(flag_in_active_high), 
		.flag_out_active_high(flag_out_active_high)
	);

	initial begin
		// Initialize Inputs
		clk_dest = 0;
		clk_src = 0;
		flag_in_active_high = 0;

		// Wait 100 ns for global reset to finish
		#3000;
		flag_in_active_high = 1;
		#900;
		flag_in_active_high=0;
         
		// Add stimulus here

	end
	
	
	always
	begin
		clk_src<=1'b1;
		#200;
		clk_src<=1'b0;
		#200;
	end	


	always
	begin
		clk_dest<=1'b1;
		#77;
		clk_dest<=1'b0;
		#77;
	end		
	
	
      
endmodule

