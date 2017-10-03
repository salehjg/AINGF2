
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:22:23 08/09/2015 
// Design Name: 
// Module Name:    TOP_001 
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
module vsync_ctrlr(
	input  clk,
	input  reset,
	input  vsync,
	output sync_sig,
	output finished
    );
	//==========================================================
	reg state,r_finished;
	//---------------------------------------
	reg r_sync_sig;
	//---------------------------------------
	assign finished = r_finished;
	//---------------------------------------
	assign sync_sig = r_sync_sig;
	//==========================================================
	
	always @(posedge vsync,posedge reset)
	begin
		if(reset) 
			begin
				state<=1'b0;
				r_finished <=1'b0;
			end
		
		else
		
			begin
				if(!state && !r_finished) state <= 1'b1;
				
				if(state) 
				begin
					state <= 1'b0;
					r_finished<= 1'b1;
				end
			end
		
	end	
	//==========================================================
	
	always@(posedge clk)
	begin
		if(state) r_sync_sig<= 1'b1;
		else r_sync_sig<= 1'b0;
	end
	//==========================================================
	
	
endmodule
