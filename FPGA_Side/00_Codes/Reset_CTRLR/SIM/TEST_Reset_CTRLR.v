`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:46:02 10/29/2015
// Design Name:   reset_ctrlr
// Module Name:   F:/Saleh/Saleh_Files/FPGA/Boards/02_AINGF V2/01_VerilogPRJ/CamCTRLR_SRAM_CENTER_V2/TEST_Reset_CTRLR.v
// Project Name:  CAM_CTRLR_SRAM_CENTER_V2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: reset_ctrlr
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TEST_Reset_CTRLR;

	// Inputs
	reg in_clk;

	// Outputs
	wire out_rst_logic;
	wire out_rst_fifo;

	// Instantiate the Unit Under Test (UUT)
	reset_ctrlr uut (
		.out_rst_logic(out_rst_logic), 
		.out_rst_fifo(out_rst_fifo), 
		.in_clk(in_clk)
	);

	initial begin
		// Initialize Inputs
		in_clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
	always
	begin
		#10 in_clk=~in_clk;
	end
      
endmodule

