`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:31:33 10/29/2015 
// Design Name: 
// Module Name:    reset_ctrlr 
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
module reset_ctrlr(
    output reg out_rst_logic,
    output reg out_rst_fifo,
	output reg out_rst_cam,
	output reg out_nrst_usbfx,//at least 5mS of active low assertion needed!
	
	
	output reg out_rst_reg_buff, // active low
	output reg out_nrst_cam_setup, // active low
	input cam_setup_done,//active high
	
	input rst_semi, //only resets logic & fifo--not cam_setup   -- ACTIVE HIGH --SYNCED WITH PCLK
	input rst_release,//active low
    input in_clk,
	input global_reset_input  //active low - async
    );

//============================================================================================
parameter S0= 3'd0, S1= 3'd1;
parameter S2= 3'd2, S3= 3'd3;
parameter S4= 3'd4, S5= 3'd5;
parameter S6= 3'd6, S7= 3'd7;

reg [2:0]state = 0;
reg [2:0]state_next = 0;
reg [31:0]r_data,r_data_next;

reg [31:0]r_cnt=0;
reg [31:0]r_cnt_next=0;

reg released=0;
reg semi_rst_req = 0;
//============================================================================================
//sync circuit for rst_semi input from fast_clk's domain!
//reset controller module works with slow_clk
reg rst_semi_synced=0;
reg temp_synced=0;
reg state_sync=0;

always@(posedge rst_semi or posedge in_clk or negedge global_reset_input)
begin
	if(global_reset_input==1'b0)
	begin
		rst_semi_synced = 0;
		state_sync = 0;
		temp_synced = 0;
	end
	else
	begin
		if(rst_semi)
		begin
			temp_synced = 1'b1;
			state_sync = 0;
		end
		else
		begin
			//if(in_clk)
			//begin
				if(temp_synced)
				begin
					if(state_sync==1'b0)
					begin
						state_sync = 1'b1;
						rst_semi_synced = 1'b1;
					end
					else
					begin
						rst_semi_synced = 1'b0;		
						temp_synced = 0;
					end
					
				end
				
			//end
			
		end
	end
end

//============================================================================================


always@(posedge in_clk or negedge global_reset_input)
begin	
	if(global_reset_input==0)
	begin
		state  <= S0;
		r_data <= 0	;
		r_cnt  <= 0	;
	end
	else
	begin
		state  <= state_next	;
		r_data <= r_data_next	;
		r_cnt  <= r_cnt_next	;
	end
end

//=================================WRITING PROCEDURE===========================================

always @(*)//(state, w_ready, addr_reached,read_data_valid,BUTTON_LEFT,BUTTON_RIGHT)
begin: State_tableW
	

r_data_next		= r_data;
r_cnt_next		= r_cnt;
state_next		= state;	
out_nrst_usbfx  = 1'b1;	
	(* parallel_case *) case (state)

	S0: // restarting cam setup module-cycle1
		begin
			
			//##################
			r_data_next= 32'd0;
			out_rst_logic = 1'b1;
			out_rst_fifo  = 1'b1;
			out_rst_cam = 1'b1;		
			out_rst_reg_buff = 1'b0;//active low
			out_nrst_cam_setup = 1'b0;//active low
			
			if(r_cnt > 32'd110000)
			begin
				r_cnt_next = 0;
				state_next = S1;
			end
			else
			begin
				r_cnt_next = r_cnt + 1;
				state_next = S0;
				out_nrst_usbfx = 0;
			end
			
			
			if(rst_semi==1'b1) 
			begin
				state_next = S7;
				semi_rst_req = 1'b1;
			end
		end

	S1: // restarting cam setup module-cycle2
		begin
			state_next = S2;
			//##################
			r_data_next= 32'd0;
			out_rst_logic = 1'b1;
			out_rst_fifo  = 1'b1;
			out_rst_cam = 1'b1;		
			out_rst_reg_buff = 1'b0;//active low
			out_nrst_cam_setup = 1'b0;//active low
			
			
			if(rst_semi==1'b1) 
			begin
				state_next = S7;
				semi_rst_req = 1'b1;
			end
		end

	S2: //loop here till cam setup is done! /(deasserting rst signal of cam_setup Module!)
		begin
			state_next = S2; //was s2
			//##################
			r_data_next= 32'd0;
			out_rst_logic = 1'b1;
			out_rst_fifo  = 1'b1;
			out_rst_cam = 1'b1;		
			out_rst_reg_buff = 1'b1;//active low 
			out_nrst_cam_setup = 1'b1;//active low 
			if(cam_setup_done==1'b1) state_next = S3;
			
			
			if(rst_semi==1'b1) 
			begin
				state_next = S7;
				semi_rst_req = 1'b1;
			end
		end

	S3: //delay
		begin
			state_next = S4;
			
			r_data_next= 32'd0;
			out_rst_logic = 1'b1;
			out_rst_fifo  = 1'b1;
			out_rst_cam = 1'b1;		
			out_rst_reg_buff = 1'b1;//active low 
			
			if(rst_semi==1'b1) 
			begin
				state_next = S7;
				semi_rst_req = 1'b1;
			end
		end

	S4: //delay
		begin
			state_next = S5;
			
			r_data_next= 32'd0;
			out_rst_logic = 1'b1;
			out_rst_fifo  = 1'b1;
			out_rst_cam = 1'b1;		
			out_rst_reg_buff = 1'b1;//active low -- cam setup reset is now deasserted!
			
			
			if(rst_semi==1'b1) 
			begin
				state_next = S7;
				semi_rst_req = 1'b1;
			end
		end

	S5: //delay
		begin
			state_next = S6;
			
			r_data_next= 32'd0;
			out_rst_logic = 1'b1;
			out_rst_fifo  = 1'b1;
			out_rst_cam = 1'b1;		
			out_rst_reg_buff = 1'b1;//active low -- cam setup reset is now deasserted!
			
			
			if(rst_semi==1'b1) 
			begin
				state_next = S7;
				semi_rst_req = 1'b1;
			end
		end

	S6: //waiting to be released by PushButton!
		begin
			if(rst_release==0)
			begin
				released = 1'b1;
				state_next = S7;
				//##################
				r_data_next= 32'd0;
				out_rst_logic = 1'b1;
				out_rst_fifo  = 1'b1;
				out_rst_cam = 1'b1;
				out_rst_reg_buff = 1'b1;//active low -- cam setup reset is now deasserted!

			end
			else
			begin
				state_next = S6;
				//##################
				r_data_next= 32'd0;
				out_rst_logic = 1'b1;
				out_rst_fifo  = 1'b1;
				out_rst_cam = 1'b1;		
				out_rst_reg_buff = 1'b1;
			
				if(rst_semi==1'b1) 
				begin
					state_next = S7;
					semi_rst_req = 1'b1;
				end
			end	
		end
	
	S7: 
		begin
			if(released || rst_semi || semi_rst_req )
			begin
				state_next = S7;
				//##################
				if(r_data<32'h0000000F) //for hardware h0000FFAA            for simulation h00000FAA
				begin //deAsserting first reset signal (fifo reset)
					out_rst_logic = 1'b1;
					out_rst_fifo  = 1'b1;
					out_rst_cam = 1'b1;
					out_rst_reg_buff = 1'b1;
					r_data_next= r_data + 1;
				end
				else
				begin 
					if(r_data<32'h000000F0)//for hardware h0C000000            for simulation h0000F000
					begin//deAsserting second reset signal (logic reset)
						out_rst_logic = 1'b1;
						out_rst_fifo  = 1'b0;
						out_rst_cam = 1'b0;
						out_rst_reg_buff = 1'b1;
						r_data_next= r_data + 1;
					end
					else
					begin
						out_rst_logic = 1'b0;
						out_rst_fifo  = 1'b0;
						out_rst_cam = 1'b0;
						out_rst_reg_buff = 1'b1;
						if( ( semi_rst_req ==1'b1 ) || ( rst_semi == 1'b1 ) )
						begin
							r_data_next= 32'd0;
						end
					end
					
				end
			end
			else
			begin
				state_next = S6;
			end
			
			
		end


	default: 
	begin
		state_next = S0;
		out_rst_logic = 1'b1;
		out_rst_fifo  = 1'b1;
		out_rst_cam   = 1'b1;
		out_rst_reg_buff = 1'b0;
	end
	endcase
end

	

endmodule
