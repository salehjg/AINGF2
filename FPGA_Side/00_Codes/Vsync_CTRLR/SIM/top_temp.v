`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:52:34 10/29/2015 
// Design Name: 
// Module Name:    top_temp 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top_temp(
    input clk,
    input in_vsync,
	output sync_sig,
	output finished
    );

wire rst_logic;


reset_ctrlr rst01
(
.out_rst_logic(rst_logic),
.out_rst_fifo(),
.in_clk(clk)
);

vsync_ctrlr vsync01
(
.clk(clk),
.reset(rst_logic),
.vsync(in_vsync),
.sync_sig,
.finished
);

endmodule
