`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:26:04 01/01/2016
// Design Name:   I3C_BUS
// Module Name:   F:/Saleh/Saleh_Files/FPGA/Boards/02_AINGF V2/01_VerilogPRJ/CamCTRLR_SRAM_CENTER_V2/00_Codes/I3C_BUS/SIM/TEST_I3C.v
// Project Name:  CAM_CTRLR_SRAM_CENTER_V2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: I3C_BUS
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TEST_I3C;

	// Inputs
	reg bus_clk;
	reg bus_din;
	reg [15:0] parallel_din;

	// Outputs
	wire bus_dout;
	wire [15:0] parallel_dout;
	wire data_ready;
	wire dbg_state;

	// Instantiate the Unit Under Test (UUT)
	I3C_BUS uut (
		.bus_clk(bus_clk), 
		.bus_dout(bus_dout), 
		.bus_din(bus_din), 
		.parallel_din(parallel_din), 
		.parallel_dout(parallel_dout), 
		.data_ready(data_ready),
		.dbg_state(dbg_state)
	);

	initial begin
		// Initialize Inputs
		bus_clk = 0;
		bus_din = 0;
		parallel_din = 16'hF0FF;

		// Wait 100 ns for global reset to finish
		#100;

		#1 bus_clk = 0;		bus_din = 1;	 #1 bus_clk = 1;
 		#3;       
		#1 bus_clk = 0;		bus_din = 1;	 #1 bus_clk = 1;			
		#1 bus_clk = 0;		bus_din = 1;	 #1 bus_clk = 1;			
		#1 bus_clk = 0;		bus_din = 1;	 #1 bus_clk = 1;			
		#1 bus_clk = 0;		bus_din = 0;	 #1 bus_clk = 1;			
		#1 bus_clk = 0;		bus_din = 1;	 #1 bus_clk = 1;			
		#1 bus_clk = 0;		bus_din = 0;	 #1 bus_clk = 1;			
		#1 bus_clk = 0;		bus_din = 1;	 #1 bus_clk = 1;			
		#1 bus_clk = 0;		bus_din = 0;	 #1 bus_clk = 1;			
		#1;						
		#1 bus_clk = 0;		bus_din = 1;	 #1 bus_clk = 1;			
		#1 bus_clk = 0;		bus_din = 0;	 #1 bus_clk = 1;			
		#1 bus_clk = 0;		bus_din = 1;	 #1 bus_clk = 1;			
		#1 bus_clk = 0;		bus_din = 0;	 #1 bus_clk = 1;			
		#1 bus_clk = 0;		bus_din = 1;	 #1 bus_clk = 1;			
		#1 bus_clk = 0;		bus_din = 1;	 #1 bus_clk = 1;			
		#1 bus_clk = 0;		bus_din = 1;	 #1 bus_clk = 1;			
		#1 bus_clk = 0;		bus_din = 1;	 #1 bus_clk = 1;
		#3;
		#1 bus_clk = 0;		bus_din = 1;	 #1 bus_clk = 1;
		#1 bus_clk = 0;		bus_din = 1;	 #1 bus_clk = 1;
		// Add stimulus here

	end
      
endmodule

