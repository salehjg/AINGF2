`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:55:38 10/29/2015
// Design Name:   top_temp
// Module Name:   F:/Saleh/Saleh_Files/FPGA/Boards/02_AINGF V2/01_VerilogPRJ/CamCTRLR_SRAM_CENTER_V2/TEST_Vsync_CTRLR.v
// Project Name:  CAM_CTRLR_SRAM_CENTER_V2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top_temp
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TEST_Vsync_CTRLR;

	// Inputs
	reg clk;
	reg in_vsync;

	// Outputs
	wire sync_sig;
	wire finished;

	// Instantiate the Unit Under Test (UUT)
	top_temp uut (
		.clk(clk), 
		.in_vsync(in_vsync), 
		.sync_sig(sync_sig), 
		.finished(finished)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		in_vsync = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
	always
	begin
		#10 clk=~clk;
	end
	
	always
	begin
		#10 ;
		in_vsync = 1;
		#300;
		in_vsync = 0;
		#3000;
	end
      
endmodule

