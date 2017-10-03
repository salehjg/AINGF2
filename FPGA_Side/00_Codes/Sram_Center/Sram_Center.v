module sram_center 
(
input clk_fast						,
//input button_capture				,
input button_g_reset				, 	//active low - async
output reset_out					,
output cam_reset_out				,
output out_nrst_usbfx				,
output reset_n_cam_setup_out 		, 	//cemra setup module's active low reset signal(NOT reg_buff's reset)  w_nreset_cam_setup
output reset_reg_buff_out			,
input cam_setup_done_input			,
input reset_release		 			,
input rst_semi						,
//------------------^^^^^	
inout  [15:0]   fdata				,	//FIFO data lines.
output [1:0]    faddr				,	//FIFO select lines
output          slrd				,	//Read control line
output          slwr				,	//Write control line
input           flagd				,	//EP6 Full Flag
input           flaga				,	//EP2 Empty Flag
output          sloe				,	//Slave Output Enable Control    
output 			pktend				,
//------------------^^^^^SRAM1
output [19:0]ad1	 				,	//chip interface - address
output we_n1		 				,	//chip interface - write en
output oe_n1		 				,	//chip interface - output en
inout [15:0]dio_a1	 				,	//chip interface - data bus 
output ce_a_n1		 				,	//chip interface - chip en
output ub_a_n1		 				,	//chip interface - upper byte
output lb_a_n1		 				,	//chip interface - lower byte
//------------------^^^^^SRAM2
output [19:0]ad2					,	//chip interface - address
output we_n2						,	//chip interface - write en
output oe_n2						,	//chip interface - output en
inout [15:0]dio_a2					,	//chip interface - data bus
output ce_a_n2						,	//chip interface - chip en
output ub_a_n2						,	//chip interface - upper byte
output lb_a_n2						,	//chip interface - lower byte

 
//------------------^^^^^	
input pclk							,
input href		 					,
input vsync							,
input [7:0]data						,	
//------------------^^^^^
output reg sccb_buff_n_rst			,
output reg [15:0]sccb_buff_din		,
output reg [5:0] sccb_buff_index	,
output reg sccb_buff_wr_en			,
//------------------^^^^^
output led_over_run					,
output reg led_green				,
output reg led_red					,
output finished						,

//------------------^^^^^
output dbg_fifo_wr_en 				,	
output dbg_fifo_wr_ack				,	
output dbg_fifo_full				,		
output dbg_fifo_overflow			,			
output dbg_rst_logic				,
output dbg_rst_fifo					,
			
output reg [15:0] dbg_fifo_dout		,
output dbg_fifo_rd_en      			,
output dbg_fifo_empty      			,
output dbg_fifo_valid      			,
output dbg_fifo_underflow  			,
 
output dbg_vsync_oneshot			,
output [19:0]dbg_data_cnt			,
input [15:0]dbg_instruction_input

);







/////////////////////////////USB-FX2 SIGNALS////////////////////////////////////////////////////////////////////////////////////////
reg [1:0] 	faddr_i											;
reg [15:0] 	fdata_i					= 16'b00000000			;
reg [15:0] 	temp											;
reg      	slrd_i											;
reg      	slwr_i											;
reg      	sloe_i											;
reg 	 	pktend_i										;
reg [2:0] 	gstate_i										;

assign 		slrd 					= slrd_i				;
assign 		slwr 					= slwr_i				;
assign 		faddr 					= faddr_i				;
assign 		sloe 					= sloe_i				;
assign 		fdata 					= fdata_i				;
assign 		pktend 					= pktend_i				;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
wire 		rst_logic				 						; 
assign 		reset_out 				= rst_logic				;
wire 		rst_camera				 						; 
assign 		cam_reset_out 			= rst_camera			;

wire 		w_nreset_cam_setup 								;  
assign 		reset_n_cam_setup_out	=  w_nreset_cam_setup	;
wire 		w_reset_reg_buff_out							;
assign 		reset_reg_buff_out 	 	= w_reset_reg_buff_out	;

wire 		fifo_rd_en	     								;
wire[15:0]	fifo_dout 										;
wire 		fifo_empty	     								;
wire 		fifo_valid	     								;
wire 		fifo_underflow  								;
reg [15:0]	compare_data									;
reg [15:0]	compare_data_next								;
reg 		rd_en											;
assign 		fifo_rd_en 				= rd_en					;
	
wire 		w_finished										;
assign 		finished 				= w_finished			;
wire 		w_vsync_oneshot									;
assign 		dbg_vsync_oneshot 		= w_vsync_oneshot		;
reg [19:0]	dbg_data_cnt_r									;
assign 		dbg_data_cnt 			= dbg_data_cnt_r		;
reg [15:0] 	dbg_fifo_dout_next								;

reg FSM_B_flag_addr_sampled;		//add to always(posedge)
reg FSM_B_flag_addr_sampled_next; 	//add to always(posedge)

//reg 		rst_semi_r										;
//wire 		rst_semi		 								;
//assign 	rst_semi 			= rst_semi_r				;
//assign 	finished 			= !rst_logic				;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

wire 		Wmem1											;
wire 		Wrw1											;
reg 		rw1   											;
reg 		mem1  											;
assign  	Wrw1  			= rw1							;
assign 	 	Wmem1 			= mem1							;

wire 		Wmem2											;
wire 		Wrw2											;
reg 		rw2   											;
reg 		mem2  											;
assign  	Wrw2  			= rw2							;
assign 	 	Wmem2 			= mem2							;

wire[19:0]	addr1 											;
reg [19:0]	r_addr1 		= 20'hFFFFF						;
reg [19:0]	r_addr_next1 	= 20'hFFFFF						;
assign 		addr1 			= r_addr1						;

wire[19:0]	addr2 											;
reg [19:0]	r_addr2 		= 20'hFFFFF						;
reg [19:0]	r_addr_next2 	= 20'hFFFFF						;
assign 		addr2 			= r_addr2						;

reg [19:0] r_pixel_cnt		= 20'd0							;
reg [19:0] r_pixel_cnt_next	= 20'd0							;

wire[15:0] 	data_f2s1										;
reg [15:0] 	data_f2s_r1										;
assign 		data_f2s1 		= data_f2s_r1					;

wire[15:0] 	data_f2s2										;
reg [15:0] 	data_f2s_r2										;
assign 		data_f2s2 		= data_f2s_r2					;

wire 		w_ready1										;
wire[15:0]	w_data_s2f_r1									;

wire 		w_ready2										;
wire[15:0]	w_data_s2f_r2									;

wire 		read_data_valid = (w_data_s2f_r2 == 16'h00AA)	;

reg [9:0] 	semi_counter									;
//---------------------------------------------------------------
//CODES FOR NEW 2 SRAM CTRLRs
reg arbiter_sel=0;
reg arbiter_sel_next=0;

wire s1Wmem		    ;
wire s1Wrw		    ;
wire [19:0]s1addr		    ;
wire [15:0]s1data_f2s	    ;
wire s1w_ready      ;
wire [15:0]s1w_data_s2f_r	;

wire s2Wmem		    ;
wire s2Wrw		    ;
wire [19:0]s2addr		    ;
wire [15:0]s2data_f2s	    ;
wire s2w_ready      ;
wire [15:0]s2w_data_s2f_r	;


wire [19:0]w_ad1				;
wire w_we_n1					;
wire w_woe_n1					;
wire [15:0]w_dio_a1				;
wire w_ce_a_n1   				;
wire w_ub_a_n1   				;
wire w_lb_a_n1   				;

assign ad1		=	w_ad1		;
assign we_n1	=	w_we_n1		;
assign oe_n1	=	w_woe_n1	;
assign dio_a1	=	w_dio_a1	;
assign ce_a_n1	=	w_ce_a_n1   ;
assign ub_a_n1	=	w_ub_a_n1   ;
assign lb_a_n1	=	w_lb_a_n1   ;


wire [19:0]w_ad2				;
wire w_we_n2					;
wire w_woe_n2					;
wire [15:0]w_dio_a2				;
wire w_ce_a_n2   				;
wire w_ub_a_n2   				;
wire w_lb_a_n2   				;

assign ad2		=	w_ad2		;
assign we_n2	=	w_we_n2		;
assign oe_n2	=	w_woe_n2	;
assign dio_a2	=	w_dio_a2	;
assign ce_a_n2	=	w_ce_a_n2   ;
assign ub_a_n2	=	w_ub_a_n2   ;
assign lb_a_n2	=	w_lb_a_n2   ;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
parameter C0=3'd0,C1=3'd1,C2=3'd2,C3=3'd3,C4=3'd4;
reg [2:0] 	Cstate		, Cstate_next;	

parameter U0=3'd0,U1=3'd1,U2=3'd2,U3=3'd3,U4=3'd4,U5=3'd5,U6=3'd6;
reg [2:0] 	Ustate		, Ustate_next;	


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
reg [5:0]	r_pattern_index			;
reg [5:0]	r_pattern_index_next	;
wire[15:0]	w_pattern_data			;

PATTERN_ROM frame_pattern001
(
	.i_index(r_pattern_index),
	.data_o(w_pattern_data)
);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
sram_controller sram1
(
	.clk			(	clk_fast	), 
	.reset			(	rst_logic	), 
	
	.mem			(	s1Wmem		), 
	.rw				(	s1Wrw		), 
	.addr			(	s1addr		), 
	.data_f2s		(	s1data_f2s	), 
	.ready			(	s1w_ready	), 
	.data_s2f_r		(	s1w_data_s2f_r), 
	.data_s2f_ur	(				), 
	
	.ad				(	w_ad1		), 
	.we_n			(	w_we_n1		), 
	.oe_n			(	w_woe_n1	), 
	.dio_a			(	w_dio_a1	), 
	.ce_a_n			(	w_ce_a_n1	), 
	.ub_a_n			(	w_ub_a_n1	), 
	.lb_a_n			(	w_lb_a_n1	)
);


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
sram_controller sram2
(
	.clk			(	clk_fast	), 
	.reset			(	rst_logic	), 
	
	.mem			(	s2Wmem		), 
	.rw				(	s2Wrw		), 
	.addr			(	s2addr		), 
	.data_f2s		(	s2data_f2s	), 
	.ready			(	s2w_ready	), 
	.data_s2f_r		(	s2w_data_s2f_r), 
	.data_s2f_ur	(				), 
	
	.ad				(	w_ad2		), 
	.we_n			(	w_we_n2		), 
	.oe_n			(	w_woe_n2	), 
	.dio_a			(	w_dio_a2	), 
	.ce_a_n			(	w_ce_a_n2	), 
	.ub_a_n			(	w_ub_a_n2	), 
	.lb_a_n			(	w_lb_a_n2	)
);


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
arbiter_SRAM_CTRLR_V2 arbiter_SRAM_CTRLR0
(
	. clk(clk_fast)	,
	. sel(arbiter_sel)	,
	//*******************************************************FOR SRAM1
	. o_mem1		(s1Wmem)		,	//from arbiter 	to 	ctrlr1
	. o_rw1			(s1Wrw)			,	//from arbiter 	to 	ctrlr1
	. o_din1		(s1data_f2s)	, 	//from arbiter 	to 	ctrlr1
	. o_adr1		(s1addr)		,	//from arbiter 	to 	ctrlr1
	. i_ready1		(s1w_ready)		,	//from ctrlr1  	to 	arbiter
	. i_dout1		(s1w_data_s2f_r),	//from ctrlr1  	to 	arbiter
	//***************************************************FOR SRAM2
	. o_mem2		(s2Wmem)		,	//from arbiter 	to 	ctrlr2
	. o_rw2			(s2Wrw)			,	//from arbiter 	to 	ctrlr2
	. o_din2		(s2data_f2s)	, 	//from arbiter 	to 	ctrlr2
	. o_adr2		(s2addr)		,	//from arbiter 	to 	ctrlr2
	. i_ready2		(s2w_ready)		,	//from ctrlr2  	to 	arbiter
	. i_dout2		(s2w_data_s2f_r),	//from ctrlr2  	to 	arbiter
	//***************************************************FOR FSM_A
	. i_mem_A		(Wmem1)			,	//from FSM_A 	to 	arbiter	*
	. i_rw_A		(Wrw1)			,	//from FSM_A 	to 	arbiter	*
	. i_din_A		(data_f2s1)		, 	//from FSM_A 	to 	arbiter	*
	. i_adr_A		(addr1)			,   //from FSM_A 	to 	arbiter	*
	. o_ready_A		(w_ready1)		,	//from arbiter 	to 	FSM_A	*
	. o_dout_A		(w_data_s2f_r1)	,	//from arbiter  to 	FSM_A	*
	//***************************************************FOR FSM_B
	. i_mem_B		(Wmem2)			,	//from FSM_A 	to 	arbiter
	. i_rw_B		(Wrw2)			,	//from FSM_A 	to 	arbiter
	. i_din_B		(data_f2s2)		, 	//from FSM_A 	to 	arbiter
	. i_adr_B		(addr2)			,	//from FSM_A 	to 	arbiter
	. o_ready_B		(w_ready2)		,	//from arbiter 	to 	FSM_A
	. o_dout_B		(w_data_s2f_r2)		//from arbiter  to 	FSM_A
);


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
cam_ctrlr inst_cam_ctrlr01
(
	.out_reset				(	rst_logic				),//was rst_logic							
	.out_reset_camera  		(	rst_camera				),
	.out_nrst_usbfx			(	out_nrst_usbfx			),
	.reset_release  		(	reset_release 			),
	.rst_semi				(	rst_semi				),
	.out_reset_reg_buff		(	w_reset_reg_buff_out 	),
	.out_nreset_cam_setup	(	w_nreset_cam_setup 		),
	.in_cam_setup_done  	(	cam_setup_done_input	),
	.global_reset_input  	(	button_g_reset			),

	//---------------------------------------------======= Camera Interface Input
	.pclk					(	pclk					),
	.href					(	href					),
	.vsync					(	vsync					),
	.data					(	data					),

	//---------------------------------------------======= FIFO Read Port Output
	. fifo_rdclk	 		(	clk_fast				),
	. fifo_rd_en	 		(	fifo_rd_en				),
	. fifo_dout		 		(	fifo_dout				),
	. fifo_empty	 		(	fifo_empty				),
	. fifo_valid	 		(	fifo_valid				),
	. fifo_underflow 		(	fifo_underflow			),

	//---------------------------------------------======= Flag Outputs
	.LED_ERR				(	led_over_run			),
	.finished				(	w_finished				),
	.vsync_oneshot			(	w_vsync_oneshot			),

	//---------------------------------------------======= DEBUG WIRING Output
	.dbg_fifo_wr_en 		(	dbg_fifo_wr_en 			),	        
	.dbg_fifo_wr_ack		(	dbg_fifo_wr_ack			),	        
	.dbg_fifo_full			(	dbg_fifo_full			),		
	.dbg_fifo_overflow		(	dbg_fifo_overflow		),		
	.dbg_rst_logic			(	dbg_rst_logic			),      
	.dbg_rst_fifo       	(	dbg_rst_fifo     		)

);


//#############################################################################################

always@(posedge clk_fast or posedge rst_logic)
begin
	if(rst_logic)
		begin
			Cstate 					<= 	C0					;
			Ustate 					<= 	U0					;
			r_addr1 				<= 	20'hFFFFF			;
			r_addr2					<= 	20'hFFFFF			;
			r_pixel_cnt				<=  20'd0				;
			arbiter_sel				<=  1'b1				;
			FSM_B_flag_addr_sampled <= 	1'b1				;
			r_pattern_index			<=  6'd0				;
		end
	else
		begin
			Cstate 					<=	Cstate_next			;
			Ustate 					<=	Ustate_next			;
			compare_data 			<=	compare_data_next	;
			dbg_fifo_dout 			<=	dbg_fifo_dout_next	;
			r_addr1 				<=	r_addr_next1		;
			r_addr2 				<=	r_addr_next2		;
			r_pixel_cnt				<=  r_pixel_cnt_next	;
			arbiter_sel 			<= 	arbiter_sel_next	;
			FSM_B_flag_addr_sampled <=  FSM_B_flag_addr_sampled_next;
			r_pattern_index			<=  r_pattern_index_next;
		end
end

//=================================READING PROCEDURE===========================================
/*
always @(*)//(state, w_ready, addr_reached,read_data_valid,BUTTON_LEFT,BUTTON_RIGHT)
begin: State_tableR
rw 	= 1'b0;
mem = 1'b0;	
r_addr_next		= r_addr;				//CHECKED	
Tstate_next		= Tstate;	
dbg_fifo_dout_next = dbg_fifo_dout;		//CHECKED

sloe_i = 1'b1;
faddr_i= 2'b10;   //	IDLE STATE
slrd_i = 1'b1;
slwr_i = 1'b1;
pktend_i = 1'b1;
//rst_semi_r = 1'b0;
sccb_buff_wr_en = 1'b0;
sccb_buff_n_rst = 1'b1;

	(* parallel_case *) case (Tstate)
	
	T0: //idle 1 
		begin
			Tstate_next = T1;//I0;
			//##################
			rd_en = 1'b0;
			rw 	= 1'b0;
			mem = 1'b0;	
			led_green = 1'b0;
			led_red = 0;	
			dbg_data_cnt_r = 0;
			sccb_buff_n_rst = 0; //isue a reg_buff reset (active low)
			r_addr_next = 20'hFFFFF;
			faddr_i  	= 2'b00;
		end
	
	T1: //fifo read cycle 01
		begin
			if(w_finished==0)
			begin
				//##################
				if(fifo_empty==1)
				begin //its empty - waiting
					rd_en = 1'b0;
				end
				else
				begin //it is NOT empty yet
					Tstate_next = T2;	
					rd_en = 1'b1;
					r_addr_next = r_addr + 1;
				end
			end
			else
			begin
				Tstate_next = T4;
				dbg_data_cnt_r = r_addr;
			end
			rw 	= 1'b0;
			mem = 1'b0;				
		end
	T2: ////fifo read cycle 02 - sram write cycle 01
		begin
			Tstate_next = T3;
			//##################
			rd_en = 1'b0;
			rw 	= 1'b0;
			mem = 1'b1;	
			data_f2s_r = fifo_dout;
			dbg_fifo_dout_next = fifo_dout;
		end
	T3:	///// sram write cycle 02
		begin
			rd_en = 1'b0;
			rw 	= 1'b0;
			mem = 1'b0;	
			if(w_ready==1'b0)
			begin
				Tstate_next = T3;
			end
			else
			begin
				Tstate_next = T1;
			end			
		end
		
		
	//...........................................................................
	//									READING data
	//...........................................................................			
		
	T4:	///// sram Read cycle 00 
		begin
			rd_en = 1'b0;

			sloe_i = 1'b1;
			faddr_i= 2'b10;   //	IDLE STATE
			slrd_i = 1'b1;
			slwr_i = 1'b1;
			
			if(r_addr==20'hFFFFF) 
			begin
				Tstate_next = T7;//READING HAS FINISHED!(  ___SUCCEED____!)
				rw 	= 1'b1;
				mem = 1'b0;
				pktend_i = 1'b0;
			end
			else
			begin
				Tstate_next = T5;
				r_addr_next = r_addr - 1;
				rw 	= 1'b1;
				mem = 1'b1;	
			end			
		end
		
	T5:	///// sram Read cycle 01 
		begin
			rd_en = 1'b0;
			rw 	= 1'b1;
			mem = 1'b0;
				
			if(w_ready==1'b0)
			begin
				Tstate_next = T5;
			end
			else
			begin
				//fdata_i = w_data_s2f_r[7:0];//w_data_s2f_r[7:0];
				//fdata_i = fdata_i + 8'b00000001;
				Tstate_next = T6;
			end
		end		
		
	T6:	///// USB_FX CYCLE 00
		begin
			
			rd_en = 1'b0;
			faddr_i = 2'b10;
			slrd_i = 1'b1;
			sloe_i = 1'b1;
			if (flagd == 1'b1)	//if Full flag is in a deasserted state 
			begin				//assert slave write control signal
				slwr_i = 1'b0;
				fdata_i = w_data_s2f_r[15:0];
				Tstate_next = T4;	
			end
			else
			begin
				faddr_i = 2'b00;
				slwr_i = 1'b1;
				Tstate_next = T6;	//when Full flag gets asserted, move to state T6 
				led_red = 1'b1;
			end
		end	
		
	T7:	///// ___SUCCEED____ STUCK HERE
		begin
			pktend_i = 1'b1;
			rd_en = 1'b0;
			rw 	= 1'b1;
			mem = 1'b0;
			led_red = 0;
			led_green = 1'b1;
			Tstate_next = T7;//Stuck here forever -- until new semi reset issued!
		end	
		
	T8:	///// NOT USED    ___semi reset system to get ready for another frame 
		begin
			Tstate_next = T0;	// T8 is not used!
		end			

	default: 
	begin
		Tstate_next = T0;
		rd_en = 1'b0;
		rw 	= 1'b0;
		mem = 1'b1;	///////??????
	end
	endcase
end

*/








//--------------------------------------
//.............FSM A(CAM)...............
//--------------------------------------
always@(*)
begin : FSM_A
Cstate_next		= Cstate;	
rw1 	= 1'b0;
mem1	= 1'b0;	
r_addr_next1		= r_addr1;				//CHECKED	
dbg_fifo_dout_next 	= dbg_fifo_dout;		//CHECKED
r_pixel_cnt_next	= r_pixel_cnt;

	(* parallel_case *) case (Cstate)

	C0: //idle 1 
		begin
			Cstate_next = C1;//I0;
			//##################
			rd_en = 1'b0;
			rw1 	= 1'b0;
			mem1 = 1'b0;		
			dbg_data_cnt_r = 0;
			sccb_buff_n_rst = 0; //issue a reg_buff reset (active low)
			r_addr_next1 = 20'hFFFFF;
		end
	
	C1: //fifo read cycle 01
		begin
			if(vsync==0)
			begin
				//##################
				if(fifo_empty==1)
				begin //its empty - waiting
					rd_en = 1'b0;
				end
				else
				begin //it is NOT empty yet
					Cstate_next = C3;	
					rd_en = 1'b1;
					r_addr_next1 = r_addr1 + 1;
				end
			end
			else
			begin
				//Cstate_next = C2;
				r_addr_next1 = 20'hFFFFF;
				r_pixel_cnt_next = r_addr1;
				dbg_data_cnt_r = r_addr1;
			end
			
			
			rw1 	= 1'b0;
			mem1 	= 1'b0;				
		end
		
	C2:		
		begin
			if(FSM_B_flag_addr_sampled==1'b1)
			begin
				r_addr_next1 = 20'hFFFFF;
				Cstate_next	 = C1; //loop between c1->c2 till start of new frame(vsync==0)!
			end
			else
			begin
				Cstate_next	 = C2; //loop till FSM_B samples the current r_addr1 of FSM_A!
			end
			rd_en = 1'b0;
		end
		
	C3: ////fifo read cycle 02 - sram write cycle 01
		begin
			Cstate_next = C4;
			//##################
			rd_en = 1'b0;
			rw1 	= 1'b0;
			mem1 = 1'b1;	
			data_f2s_r1 = fifo_dout;
			dbg_fifo_dout_next = fifo_dout;
		end
	C4:	///// sram write cycle 02
		begin
			rd_en = 1'b0;
			rw1 	= 1'b0;
			mem1 = 1'b0;	
			if(w_ready1==1'b0)
			begin
				Cstate_next = C4;
			end
			else
			begin
				Cstate_next = C1;
			end			
		end
	default:
	begin
		Cstate_next = C0;
		rd_en = 1'b0;
		rw1 = 1'b0;
		mem1 = 1'b0;
	end
	endcase
	
end 














	
//--------------------------------------
//.............FSM B(USB)...............
//--------------------------------------
always@(*)
begin : FSM_B
Ustate_next						= Ustate;	
arbiter_sel_next 				= arbiter_sel;
sloe_i 							= 1'b1;
faddr_i							= 2'b10;   //	IDLE STATE
slrd_i 							= 1'b1;
slwr_i 							= 1'b1;
pktend_i 						= 1'b1;
rw2 							= 1'b1;
mem2 							= 1'b0;	
r_addr_next2					= r_addr2;				//CHECKED	
FSM_B_flag_addr_sampled_next 	= FSM_B_flag_addr_sampled;
r_pattern_index_next			= r_pattern_index;


	(* parallel_case *) case (Ustate)
	U0://IDLE STATE!
		begin
			if(vsync==1'b1)
			begin
				if(r_pixel_cnt_next>20'd307150)//d307200
				begin
					arbiter_sel_next = ~arbiter_sel;
					r_addr_next2 = 20'd307199;//r_addr1; //sample current address of FSM_A before having it zero'ed!
					r_pattern_index_next = 6'd0;
					Ustate_next = U5;
				end
				else
				begin
					Ustate_next = U0;
				end
				
			end
			else
			begin
				Ustate_next = U0;
			end
		
		end
		
	U5: /////frame-start pattern transmission-001
		begin
			faddr_i = 2'b10;
			slrd_i = 1'b1;
			sloe_i = 1'b1;
			if (flagd == 1'b1)	//if Full flag is in a deasserted state 
			begin				//assert slave write control signal
				slwr_i = 1'b0;
				fdata_i = w_pattern_data[15:0];
				Ustate_next = U6;	
			end
			else
			begin
				faddr_i = 2'b00;
				slwr_i = 1'b1;
				Ustate_next = U5;	//WAIT
				
			end
		end
		
	U6: /////frame-start pattern transmission-002
		begin
			r_pattern_index_next = r_pattern_index + 1;
			if(r_pattern_index == 6'd63)
			begin
				Ustate_next = U1;//pattern trans. has finished!
			end
			else
			begin
				Ustate_next = U5;
			end
			
			
		end
	
	
	U1:	///// sram Read cycle 00 
		begin

			sloe_i = 1'b1;
			faddr_i= 2'b10;   //	IDLE STATE
			slrd_i = 1'b1;
			slwr_i = 1'b1;
			
			if(r_addr2==20'hFFFFF) //CHANGABLE R_ADDR!!!! DONT FOGET! 
			begin
				//FSM_B_flag_addr_sampled_next = 1'b0;
				Ustate_next = U0;//READING HAS FINISHED!(  ___SUCCEED____!)
				pktend_i = 1'b0;
				led_green = ~led_green;
			end
			else
			begin
				Ustate_next = U2;
				r_addr_next2 = r_addr2 - 1;
				rw2 	= 1'b1;
				mem2 	= 1'b1;	
			end			
		end
		
	U2:	///// sram Read cycle 01 
		begin
				
			if(w_ready2==1'b0)
			begin
				Ustate_next = U2;
			end
			else
			begin
				//fdata_i = w_data_s2f_r[7:0];//w_data_s2f_r[7:0];
				//fdata_i = fdata_i + 8'b00000001;
				Ustate_next = U3;
			end
		end		
		
	U3:	///// USB_FX CYCLE 00
		begin
			
			faddr_i = 2'b10;
			slrd_i = 1'b1;
			sloe_i = 1'b1;
			if (flagd == 1'b1)	//if Full flag is in a deasserted state 
			begin				//assert slave write control signal
				slwr_i = 1'b0;
				fdata_i = w_data_s2f_r2[15:0];
				Ustate_next = U1;	
			end
			else
			begin
				faddr_i = 2'b00;
				slwr_i = 1'b1;
				Ustate_next = U3;	//when Full flag gets asserted, move to state U3 
				
			end
		end	
		
	U4:	///// ___SUCCEED____ STUCK HERE
		begin
			pktend_i = 1'b1;
			Ustate_next = U4;//Stuck here forever -- until new semi reset issued!
		end	
		
	

	default: 
	begin
		Ustate_next = U0;
		rw2 		= 1'b0;
		mem2 		= 1'b1;	
	end
	endcase
end





//////////////////////////////////////////////////////////////////////////////
assign dbg_fifo_rd_en      = fifo_rd_en	;
assign dbg_fifo_empty      = fifo_empty	;
assign dbg_fifo_valid      = fifo_valid	;
assign dbg_fifo_underflow  = fifo_underflow;


//-------------------------------------------------------------------
//-------------------------------------------------------------------
//-------------------------------------------------------------------
wire [35:0] CONTROL0;

icon1 icon_ins1 (
.CONTROL0				(CONTROL0) 			 // INOUT BUS [35:0]
);
//-------------------------------------------------------------------
ila1 ila_ins1 (
.CONTROL				(CONTROL0)			,// INOUT BUS [35:0]
.CLK					(clk_fast)			,// IN
.TRIG0					({Cstate,14'd0,Ustate})		,// IN BUS [19:0]
.TRIG1					(0) 		 // IN BUS [19:0]
);
//-------------------------------------------------------------------
//-------------------------------------------------------------------
//-------------------------------------------------------------------

endmodule