/*======================================================================*
**	I3C_CENTER Module.
**
*************************************************************************	
*************************************************************************
**	
**	Desc.:	This module monitors I3C_BUS and manage requests and responds
**			with desired data-word(16 bits).
**			this module produces sync-triggers for external modules on 
**			system within different clock domains of clk_fast & clk_slow.
**
*************************************************************************
*************************************************************************
**
**  w_parallel_dout Structure:
**		{ MSbyte,LSbyte}
**		MSbyte: M-nibble: group code   L-nibble: subcode
**		LSbyte: data
**
**
//======================================================================*/


module I3C_CENTER
(
	input rst	  ,
	input clk_fast,	
	input clk_slow, //should be PCLK

	
	
	input 		bus_clk		,
	output  	bus_dout	,
	input 		bus_din		,
	
	
	
	output  	o_trig_async_g_nrst			, 	//  -global reset 		- activeLOW 	- ASYNC
	output reg 	o_trig_pclk_semi_rst		, 	//  -semi reset 		- activeHIGH 	- pclk		/posedge
	output  	o_trig_pclk_reset_release	, 	//  -reset release		- activeLOW 	- pclk		/posedge
	output 		o_trig_async_cam_setup_nrst ,	//  -cam_setup_nrst		- activeLOW 	- ASYNC

	output  	buff_port_wr	            ,   //output synced by module   buff_port_wr_synced
	output  	buff_port_rd	            ,   //output synced by module   buff_port_rd_synced
	
	input 		[15:0]	buff_port_dout	   	,
	output reg 	[15:0]	buff_port_din	   	,
	output reg 	[5:0]	buff_port_indx	   	,
	

	
	output			dbg_data_ready,
	output 			dbg_I3C_CTRLR_state,
	output [3:0]	dbg_state
	
);

//======================================================================
parameter 	group_reset_control				= 4'd1;
			parameter	subcode_reset_semi	= 4'd1;
			parameter	subcode_reset_deep	= 4'd2;
			
			
parameter	group_aquire_control			= 4'd2;
			parameter	subcode_aquire_send = 4'd1;
			parameter	subcode_sccb_commit = 4'd2;
			
			
parameter	group_sccb_mono					= 4'd3;


parameter	group_sccb_burst_w				= 4'd4;
			parameter	subcode_burst_w_start = 4'd1;
			parameter	subcode_burst_w_loop0 = 4'd2;
			parameter	subcode_burst_w_loop1 = 4'd3;
			parameter	subcode_burst_w_stop  = 4'd4;

parameter	group_sccb_burst_r				= 4'd5;
			parameter	subcode_burst_r_start = 4'd1;
			parameter	subcode_burst_r_loop0 = 4'd2;
			parameter	subcode_burst_r_loop1 = 4'd3;
			parameter	subcode_burst_r_stop  = 4'd4;
			

//======================================================================
parameter 	opcode_modify_sccb_buffer_address 	= 8'b000_00001 ,
			opcode_modify_sccb_buffer_data		= 8'b000_00010 ,
			opcode_modify_sccb_commit			= 8'b000_00011 ,
			opcode_aquire_single_frame_and_send = 8'b000_01000 , //0x08
			opcode_reset_entire					= 8'b000_01010 , //0x0A
			opcode_reset_semi					= 8'b000_01011 ; //0x0B
//======================================================================
localparam S0  = 4'D0 ;
localparam S1  = 4'D1 ;
localparam S2  = 4'D2 ;
localparam SS3 = 4'D3 ;
localparam SS4 = 4'D4 ;
localparam SS5 = 4'D5 ;
localparam SS6 = 4'D6 ;
localparam SS7 = 4'D7 ;
localparam S8  = 4'D8 ;
localparam S9  = 4'D9 ;
localparam S10 = 4'D10;
localparam S11 = 4'D11;
localparam S12 = 4'D12;
localparam S13 = 4'D13;
localparam S14 = 4'D14;
localparam S15 = 4'D15;

reg	[3:0] state=0;
assign dbg_state = state;

//======================================================================
wire w_data_ready; assign dbg_data_ready = w_data_ready;
reg [15:0]  parallel_din;
//reg [15:0]  parallel_din_next;
wire [15:0] w_parallel_dout;
reg r_trig_async_g_nrst = 1'b1; assign o_trig_async_g_nrst = r_trig_async_g_nrst;
reg r_trig_pclk_reset_release = 1'b1; assign o_trig_pclk_reset_release = r_trig_pclk_reset_release;
reg r_trig_async_cam_setup_nrst = 1'b1; assign o_trig_async_cam_setup_nrst = r_trig_async_cam_setup_nrst;
reg i3c_bus_rst=0;


//reg [15:0] buff_port_din_next;
//reg [5:0]  buff_port_index_next;
//======================================================================
I3C_BUS I3C001
(
	.rst		(i3c_bus_rst) ,
	.bus_clk	(bus_clk ),
	.bus_dout	(bus_dout),
	.bus_din	(bus_din ),
	//---------------------
	.parallel_din(parallel_din),
	.parallel_dout(w_parallel_dout),
	//---------------------
	.data_ready(w_data_ready), 					//asyc-output WARNING!
	//---------------------
	.dbg_state(dbg_I3C_CTRLR_state)
);

//======================================================================
reg buff_port_wr_synced=0;
sync sync_wr
(
	.clk_fast_dest(clk_fast)					,
	.clk_slow_src() 							,
	.flag_in_active_high(buff_port_wr_synced)	,
	.flag_out_active_high(buff_port_wr)		
);
//======================================================================
reg buff_port_rd_synced=0;
sync sync_rd
(
	.clk_fast_dest(clk_fast)					,
	.clk_slow_src() 							,
	.flag_in_active_high(buff_port_rd_synced)	,
	.flag_out_active_high(buff_port_rd )		
);

//======================================================================
reg instruction_done = 0;

//======================================================================
always@(posedge clk_slow or posedge rst)
begin
	if(rst)
	begin
		state = 0;
		instruction_done = 0;
		
		r_trig_async_g_nrst 		= 1'b1; //active low
		o_trig_pclk_semi_rst		= 1'b0; //active high
		r_trig_pclk_reset_release 	= 1'b1; //active low	
		r_trig_async_cam_setup_nrst	= 1'b1; //active low	
		
		i3c_bus_rst = 1'b1;
		
		buff_port_rd_synced = 1'b0;
		buff_port_wr_synced = 1'b0;
		
		buff_port_din	=0;
		buff_port_indx	=0;
		parallel_din	=0;
	end
	else
	begin
		i3c_bus_rst = 1'b0;
		if(w_data_ready==0)
		begin
			instruction_done = 0;
		end




		///////////////////////////////////////
		r_trig_async_g_nrst 		= 1'b1; //active low
		o_trig_pclk_semi_rst		= 1'b0; //active high
		r_trig_pclk_reset_release 	= 1'b1; //active low
		r_trig_async_cam_setup_nrst	= 1'b1; //active low
		
		//-------------------------------------
		buff_port_rd_synced = 1'b0;	        //active low
		buff_port_wr_synced = 1'b0;	        //active low
		
//		buff_port_din_next	=	buff_port_din;
//		buff_port_index_next=	buff_port_indx;	
//		parallel_din_next	=	parallel_din;
		///////////////////////////////////////
		(* parallel_case *) case(state)
			S0: //idle
			begin
				
				state=S1;
			end
			///////////////////////////////////
			S1:
			begin
				state=S1;
				if(w_data_ready && (instruction_done==0) )
				begin
					state = S2; 	// just wait one more cycle to make sure
									// data is ready to sample
				end
			end
			///////////////////////////////////
			S2: 		//decoding groups
			begin
				instruction_done = 1;
				(* parallel_case *) case(w_parallel_dout[7:4]) 
					//####################################################################################
					group_reset_control 	:
					begin
						state = SS3;
					end
					//####################################################################################
					group_aquire_control	:
					begin
						state = SS4;
					end
					//####################################################################################
					group_sccb_mono			:
					begin
						state = SS5;
					end
					//####################################################################################
					group_sccb_burst_w 		:
					begin
						state = SS6;
					end									
					//####################################################################################
					group_sccb_burst_r		:
					begin
						state = SS7;		
					end										
					//####################################################################################
					default:
					begin
						state = S1;
					end
				endcase
			end
			///////////////////////////////////
			SS3: 		//group_reset_control
			begin
				state = S14;
				(* parallel_case *) case(w_parallel_dout[3:0]) 
					//####################################################################################
					subcode_reset_semi 	:
					begin
						o_trig_pclk_semi_rst = 1'b1;		//pclk domain - posedge//active high
					end
					//####################################################################################
					subcode_reset_deep	:
					begin
						r_trig_async_g_nrst = 1'b0;			//async//active low
					end								
					//####################################################################################
					default:
					begin
						state = S1;
					end
				endcase
			end
			///////////////////////////////////
			SS4: 		//group_aquire_control
			begin
				state = S14;
				(* parallel_case *) case(w_parallel_dout[3:0]) 
					//####################################################################################
					subcode_aquire_send 	:
					begin
						r_trig_pclk_reset_release = 0;		//pclk domain - posedge//active low
					end								
					//####################################################################################
					subcode_sccb_commit 	:  	
					begin
						r_trig_async_cam_setup_nrst = 1'b0;	//async//active low
						parallel_din[15:0] 			= 16'hABCD; //DEBUGING PURPOSES
					end								
					//####################################################################################
					default:
					begin
						state = S1;
					end
				endcase
			end
			///////////////////////////////////
			SS5: 		//group_sccb_mono
			begin
				state = S14;
				(* parallel_case *) case(w_parallel_dout[3:0]) 
					//####################################################################################
					//group_reset_control 	:
					//begin
					
					//end							
					//####################################################################################
					default:
					begin
						state = S1;
					end
				endcase
			end
			///////////////////////////////////
			SS6: 		//group_sccb_burst_w
			begin
				state = S14;
				(* parallel_case *) case(w_parallel_dout[3:0]) 
					//####################################################################################
					//	PC PROGRAM SHOULD ISSUE:
					//		1) subcode_burst_w_start
					//		2) 
					//		3) 
					//		4) 
					//		5) subcode_burst_r_stop
					//
					//
					//
					//####################################################################################
					subcode_burst_w_start: // just prepare -- no data packet on payload
					begin
						buff_port_indx				= 6'h3F; 
						parallel_din[15:0] 			= 16'h000c; //DEBUGING PURPOSES
						buff_port_wr_synced 		= 1'b0;
					end							
					//####################################################################################
					subcode_burst_w_loop0:	//recieving LSB data-packet -- nothing will be written to reg_buff here!
					begin
						buff_port_din[7:0] 			= w_parallel_dout[15:8];
						buff_port_indx				= buff_port_indx + 1; // on the first cycle value of buff_port_indx will be 0!(overflowed)
						parallel_din[15:0] 			= 16'hAA; //DEBUGING PURPOSES
						buff_port_wr_synced 		= 1'b0;
					end
					//####################################################################################
					subcode_burst_w_loop1: //recieving MSB data-packet -- and write whole WORD to reg_buff here!!
					begin
						buff_port_din[15:8] 		= w_parallel_dout[15:8];
						buff_port_indx				= buff_port_indx ;
						parallel_din[15:0] 			= 16'hBB; //DEBUGING PURPOSES
						buff_port_wr_synced 		= 1'b1;
					end
					//####################################################################################
					subcode_burst_w_stop: // no data packet on payload
					begin
						buff_port_indx				= 0;
						buff_port_din[15:0] 		= 0;
						parallel_din[15:0] 			= 16'h000d; //DEBUGING PURPOSES
						buff_port_wr_synced 		= 1'b0;
					end
					//####################################################################################
					default:
					begin
						state = S1;
					end
				endcase
			end
			///////////////////////////////////
			SS7: 		//group_sccb_burst_r
			begin
				state = S14;
				(* parallel_case *) case(w_parallel_dout[3:0]) 
					
					//####################################################################################
					//	PC PROGRAM SHOULD ISSUE:
					//		1) subcode_burst_r_start
					//		2) subcode_burst_r_loop0 AND RETURNED DATA SHOULD BE PRETENDED AS DUMMY
					//		3) subcode_burst_r_loop1 AND RETURNED DATA WOULD BE INDEX0 OF BUFFER.
					//		4) LOOP TILL INDEX IS 55 (?)
					//		5) subcode_burst_r_stop
					//
					//
					//
					//####################################################################################
					subcode_burst_r_start: //getting buff_port_dout[15:0] ready for first subcode_burst_r_loop0
					begin
						buff_port_indx		= 6'd0; 
						buff_port_rd_synced 		= 1'b1;
						
					end							
					//####################################################################################
					subcode_burst_r_loop0:	//read comments above about the returned payload of this cycle to PC program.
					begin
						
						parallel_din[15:0] 	= buff_port_dout[15:0];
						buff_port_indx		= buff_port_indx + 1;
						buff_port_rd_synced 		= 1'b1;
					end
					//####################################################################################
					subcode_burst_r_loop1:
					begin
						
						parallel_din[15:0] 	= buff_port_dout[15:0];
						buff_port_indx		= buff_port_indx + 1;
						buff_port_rd_synced 		= 1'b1;
					end
					//####################################################################################
					subcode_burst_r_stop:
					begin
						buff_port_indx		= 0;
						parallel_din[15:0] 	= 0;
						buff_port_rd_synced 		= 1'b0;
						
					end
					//####################################################################################
					default:
					begin
						state = S1;
					end
				endcase
			end
			
			///////////////////////////////////
			S14:
			begin
				state = S15;
				i3c_bus_rst = 1'b1;
			end
			///////////////////////////////////
			S15:
			begin
				state = S1;
				i3c_bus_rst = 1'b0;
			end
			///////////////////////////////////
			default:
			begin
				state=S14;
			end
			///////////////////////////////////
		endcase	
	end
end

endmodule