`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// 		RED LED:  FIFO OVER-RUN.
// 		GRN LED:  USB READING HAS FINISHED.
// 		WHT LED:  USB FIFO IS FULL AND WRITING TO USB HAS STOPPED.
// 		YLW LED:  VSYNC ONESHOT(Monostable).
// 
// 
// 
// 
// 
//
// 
//
// 
// 
// 
//
//////////////////////////////////////////////////////////////////////////////////
module TOP_WIRING
(		
	input OSC_50M_EX	,
	input OSC_VAR		, 
	input BUTTON_RIGHT	,
	input BUTTON_LEFT	,
	output LED_G		,
	output LED_Y		,
	output LED_W		,
	output LED_R		,
 
	input CAM_PCLK_EX	,
	input CAM_HREF		, 
	input CAM_VSYNC		,
	input [7:0]CAM_D	,
	output CAM_SCL      ,  
	inout CAM_SDA       ,
	output CAM_PWR_DOWN ,
	output CAM_RESET	,
	
	inout  [15:0]FX_D	,//
	output [1:0]FX_FADDR,//
	output FX_SLRD 		,//
	output FX_SLWR 		,//
	input  FX_FLAGD 	,//
	input  FX_FLAGA 	,//
	output FX_SLOE 		,//
	input  FX_IFCLK_EX 	,// /!\ WARNING: USB-FX2'S IFCLK PIN SHOULD BE DEFINED AS INPUT!
	output FX_NRST		,
	output FX_PKTEND	,
	
	input  FX_I2C_C	    ,
	input  FX_I2C_D0	,
	output FX_I2C_D1	, 
	
	
	
	
	output [19:0]SRAM0_A,                    
	inout [15:0]SRAM0_D	,
	output SRAM0_nWE  	,
	output SRAM0_nOE  	,
	output SRAM0_nCE1 	, 
	output SRAM0_CE2	, //was sram1 instead of sram0
	output SRAM0_nBHE 	,
	output SRAM0_nBLE 	,
	
	output [19:0]SRAM1_A,                    
	inout [15:0]SRAM1_D	,
	output SRAM1_nWE  	,
	output SRAM1_nOE  	,
	output SRAM1_nCE1 	, 
	output SRAM1_CE2	, //was sram1 instead of sram0
	output SRAM1_nBHE 	,
	output SRAM1_nBLE 	
);
//-------------------------------------------------------------------
//assign CAM_SCL = 1'b1;
//assign CAM_SDA = 1'b1;
assign CAM_PWR_DOWN	= 0;

wire [19:0] dbg_data_cnt;
wire w_finished;
wire RESET_OUT_W,CAM_RESET_OUT_W,g_n_reset,g_n_reset_from_i3c; 
wire w_m8051_deep_nrst;
assign g_n_reset = w_m8051_deep_nrst;//= BUTTON_LEFT & g_n_reset_from_i3c & w_m8051_deep_nrst;

wire [19:0] byte_count_w;
wire read_trig_w;
wire cam_setup_done,reg_buff_n_rst;
wire led_green; assign LED_G = led_green;

wire sccb_buff_n_rst	  	;
wire [15:0]sccb_buff_din  	;
wire [15:0]sccb_buff_dout  	;
wire [5:0]sccb_buff_index 	;
wire sccb_buff_wr_en      	;
wire sccb_buff_rd_en      	;
wire cam_setup_nrst		  	;
wire cam_setup_nrst_I3C  	;
wire nrst_usbfx				;
wire w_reset_release		; //active low
wire rst_semi				; //active HIGH -- SYNCED WITH PCLK

wire [7:0]w_p0_o;
wire [7:0]w_p1_o;
wire [7:0]w_p2_o;
wire [7:0]w_p3_o;

wire [7:0]w_p0_I;
wire [7:0]w_p1_I;
wire [7:0]w_p2_I;
wire [7:0]w_p3_I;



wire w_LED_Y,w_LED_Y2; assign LED_Y = w_LED_Y | w_LED_Y2;
//-------------------------------------------------------------------
wire ww0,OSC_50M;
IBUFG ibfg0 (.I(OSC_50M_EX)		, .O(ww0)		);
BUFG  bufg0 (.I(ww0)			, .O(OSC_50M)	);
//-------------------------------------------------
wire ww1,FX_IFCLK;
IBUFG ibfg1 (.I(FX_IFCLK_EX)	, .O(ww1)		);
BUFG  bufg1 (.I(ww1)			, .O(FX_IFCLK)	);
//-------------------------------------------------
wire ww2,CAM_PCLK;
IBUFG ibfg2 (.I(CAM_PCLK_EX)	, .O(ww2)		);
BUFG  bufg2 (.I(ww2)			, .O(CAM_PCLK)	);
//-------------------------------------------------


//-------------------------------------------------------------------
sram_center sc0
(
.clk_fast				(FX_IFCLK)			, //Interface Clock FX2 FX_IFCLK
//.button_capture 		(BUTTON_RIGHT)		,
.button_g_reset 		(g_n_reset)		, //active low - async
.reset_out				(RESET_OUT_W)		,
.cam_reset_out			(CAM_RESET_OUT_W)	,
.out_nrst_usbfx			(nrst_usbfx)	,

.reset_n_cam_setup_out(cam_setup_nrst)		, //Comming from rst_ctrlr module
.reset_reg_buff_out(reg_buff_n_rst)			,
.cam_setup_done_input(cam_setup_done)		,
.reset_release(w_reset_release),
.rst_semi(rst_semi),
//------------------^^^^^
.fdata					(FX_D[15:0])		, //FIFO data lines.
.faddr					(FX_FADDR)			, //FIFO select lines
.slrd					(FX_SLRD)			, //Read control line
.slwr					(FX_SLWR)			, //Write control line
.flagd					(FX_FLAGD)			, //EP6 Full Flag
.flaga					(FX_FLAGA)			, //EP2 Empty Flag
.sloe					(FX_SLOE)			, //Slave Output Enable Control 
.pktend					(FX_PKTEND)			, 
//------------------^^^^^
.pclk					(CAM_PCLK)			,
.href					(CAM_HREF)		 	,
.vsync					(CAM_VSYNC)			,
.data					(CAM_D)				, //8'hAA
//------------------^^^^^
.sccb_buff_n_rst		(sccb_buff_n_rst)	,
.sccb_buff_din          ()	,
.sccb_buff_index        ()	,
.sccb_buff_wr_en        ()	,
//------------------^^^^^
. ad1					(SRAM0_A )			, //chip interface - address	
. we_n1					(SRAM0_nWE )		, //chip interface - write en//------------------^^^^^
. oe_n1					(SRAM0_nOE )		, //chip interface - output en.pclk(CAM_PCLK)				,
. dio_a1				(SRAM0_D )			, //chip interface - data bus.href(CAM_HREF)		 		,
. ce_a_n1				(SRAM0_nCE1 )		, //chip interface - chip en.vsync(CAM_VSYNC)			,
. ub_a_n1				(SRAM0_nBHE )		, //chip interface - upper byte.data(8'hAA)				,	
. lb_a_n1				(SRAM0_nBLE )		, //chip interface - lower byte//------------------^^^^^
//------------------^^^^^
. ad2					(SRAM1_A )			, //chip interface - address	
. we_n2					(SRAM1_nWE )		, //chip interface - write en//------------------^^^^^
. oe_n2					(SRAM1_nOE )		, //chip interface - output en.pclk(CAM_PCLK)				,
. dio_a2				(SRAM1_D )			, //chip interface - data bus.href(CAM_HREF)		 		,
. ce_a_n2				(SRAM1_nCE1 )		, //chip interface - chip en.vsync(CAM_VSYNC)			,
. ub_a_n2				(SRAM1_nBHE )		, //chip interface - upper byte.data(8'hAA)				,	
. lb_a_n2				(SRAM1_nBLE )		, //chip interface - lower byte//------------------^^^^^
//------------------^^^^^
.led_over_run			(LED_R)				, //RED LED:  FIFO OVER-RUN.
.led_green				(led_green)				, //GRN LED:  USB READING HAS FINISHED.
.led_red				(LED_W)				, //WHT LED:  USB FIFO IS FULL AND WRITING TO USB HAS STOPPED.
.finished				(w_finished)		,
.dbg_vsync_oneshot		()				, //YLW LED:  VSYNC ONESHOT(Monostable).
//------------------^^^^^
.dbg_fifo_wr_en 		(),	
.dbg_fifo_wr_ack		(),	
.dbg_fifo_full			(),		
.dbg_fifo_overflow		(),			
.dbg_rst_logic			(),
.dbg_rst_fifo			(),

.dbg_fifo_dout			(),
.dbg_fifo_rd_en     	(),
.dbg_fifo_empty     	(),
.dbg_fifo_valid     	(),
.dbg_fifo_underflow     (),
.dbg_data_cnt			(dbg_data_cnt)

);
	
assign CAM_RESET	= CAM_RESET_OUT_W;	
assign SRAM0_CE2 = 1'b1; //always active!(active high)
assign SRAM1_CE2 = 1'b1; //always active!(active high)
assign FX_NRST = nrst_usbfx;// NRST pin has a pull down resistor, and NRST is active low, so we just need to de-assert Reset signal.(make it high)

//-------------------------------------------------------------------
cam_counter cam_cntr01
(
. reset					(RESET_OUT_W)		,
	
. pclk					(CAM_PCLK)			,
. href		 			(CAM_HREF)			,
. vsync					(CAM_VSYNC)			,
	
. byte_count			(byte_count_w)		,
. read_trig				(read_trig_w)
);

/*
//-------------------------------------------------------------------
wire [35:0] CONTROL0;

icon1 icon_ins1 (
.CONTROL0				(CONTROL0) 			 // INOUT BUS [35:0]
);


//-------------------------------------------------------------------
ila1 ila_ins1 (
.CONTROL				(CONTROL0)			,// INOUT BUS [35:0]
.CLK					(CAM_PCLK)			,// IN
.TRIG0					(byte_count_w)		,// IN BUS [19:0]
.TRIG1					(read_trig_w) 		 // IN BUS [19:0]
);
*/


//-------------------------------------------------------------------
wire [3:0]i3c_state;
wire w_dbg_data_ready;
wire w_m8051_i3c_nrst;
//-------------------------------------------------------------------

I3C_CENTER I3C_CENTER_001
(
	.rst	 (~(BUTTON_RIGHT & nrst_usbfx & reg_buff_n_rst & w_m8051_i3c_nrst)),
	.clk_fast(FX_IFCLK),	
	.clk_slow(CAM_PCLK), 

	
	
	.bus_clk (FX_I2C_C) ,
	.bus_dout(FX_I2C_D1),
	.bus_din (FX_I2C_D0),
	
	
	
	.o_trig_async_g_nrst  		(g_n_reset_from_i3c)			, 	//  -global reset 		- activeLOW 	- ASYNC
	.o_trig_pclk_semi_rst 		(rst_semi)						, 	//  -semi reset 		- activeHIGH 	- pclk		/posedge
	.o_trig_pclk_reset_release 	(w_reset_release)				, 	//  -semi reset 		- activeHIGH 	- pclk		/posedge
	.o_trig_async_cam_setup_nrst(cam_setup_nrst_I3C)			, 	//  -cam_setup_nrst		- activeLOW 	- ASYNC	
	
	.buff_port_wr				(sccb_buff_wr_en)		,
	.buff_port_rd				(sccb_buff_rd_en)		,
	.buff_port_dout				(sccb_buff_dout)		,
	.buff_port_din				(sccb_buff_din)			,
	.buff_port_indx				(sccb_buff_index)			,
	
	.dbg_data_ready(w_dbg_data_ready),
	.dbg_I3C_CTRLR_state(w_LED_Y ),
	.dbg_state(i3c_state)

);
//-------------------------------------------------------------------
CameraSetup cam_setup01 
(
.clk_i	( FX_IFCLK ), 				//was OSC_50M  /!\ Warning: clk_i and clk of sramCenter should be synchroneous!
.rst_i	( /*cam_setup_nrst &&*/ cam_setup_nrst_I3C ),  ///TODO :  rst_i SHOULD BE CONTROLLED BY 2 MODULES : (ONE FROM RST_CTRLR) & (ANOTHER FROM I3C_CENTER)
.done	( cam_setup_done ), 
.sioc_o	( CAM_SCL ), 
.siod_io( CAM_SDA ),
.rst_i2	( reg_buff_n_rst ), 
.din    ( sccb_buff_din   ),
.dout   ( sccb_buff_dout  ), 
.index  ( sccb_buff_index ),
.wr_en  ( sccb_buff_wr_en ),
.rd_en  ( sccb_buff_rd_en )

);
//-------------------------------------------------------------------
mc8051_top m8051_ip_inst01
(

.clk(OSC_50M),
.reset(1'b0),
.int0_i(1'b0),
.int1_i(1'b0),

.all_t0_i(1'b0),          
.all_t1_i(1'b0),         
.all_rxd_i(1'b0),
 

.p0_i(w_p0_I),
.p1_i(w_p1_I),
.p2_i(w_p2_I),
.p3_i(w_p3_I),

.p0_o(w_p0_o),//w_m8051_i3c_nrst  w_m8051_deep_nrst
.p1_o(w_p1_o),
.p2_o(w_p2_o),
.p3_o(w_p3_o),

.all_rxd_o   (),
.all_txd_o   (),
.all_rxdwr_o ()
		
);  

//-----------------------------------LEDs OUTs(FROM 8051 TO FPGA)
assign w_LED_Y2 = w_p0_o[1];
//-----------------------------------TRIG OUTs(FROM 8051 TO FPGA)
assign w_m8051_deep_nrst = w_p1_o[0];
assign w_m8051_i3c_nrst  = w_p1_o[1];
//-----------------------------------STATE INs(FROM FPGA TO 8051)
assign w_p2_I[0] = LED_R;//state_overrun
assign w_p2_I[1] = LED_W;//state_usbfx_fifo_full




assign w_p0_I = w_p0_o; //loopback outputs to inputs for C code's readbacks!
assign w_p1_I = w_p1_o; //loopback outputs to inputs for C code's readbacks!
assign w_p3_I = w_p2_o; //loopback outputs to inputs for C code's readbacks!

//-------------------------------------------------------------------
//-------------------------------------------------------------------
//-------------------------------------------------------------------
/*
wire [35:0] CONTROL0;

icon1 icon_ins1 (
.CONTROL0				(CONTROL0) 			 // INOUT BUS [35:0]
);
//-------------------------------------------------------------------
ila1 ila_ins1 (
.CONTROL				(CONTROL0)			,// INOUT BUS [35:0]
.CLK					(CAM_PCLK)			,// IN
.TRIG0					({ i3c_state,2'b111,10'd0,w_dbg_data_ready, g_n_reset_from_i3c, rst_semi, w_reset_release})		,// IN BUS [19:0]
.TRIG1					(0) 		 // IN BUS [19:0]
);
*/
//-------------------------------------------------------------------
//-------------------------------------------------------------------
//-------------------------------------------------------------------



//assign FX_IFCLK = OSC_VAR;
endmodule
