
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
module cam_ctrlr
	(
	output  out_reset		,
	output  out_reset_camera,
	output  out_nrst_usbfx	,
	
	output 	out_reset_reg_buff,
	output 	out_nreset_cam_setup,
	input	in_cam_setup_done,
	
	input reset_release		,
	input rst_semi			,
	input global_reset_input,
	//------------------======= Camera Interface Input
	input pclk				,
	input href		 		,
	input vsync				,
	input [7:0]data			,	
	//------------------======= FIFO Read Port Output
	input fifo_rdclk		,//
	input fifo_rd_en		,//
	output[15:0]fifo_dout	,//
	output fifo_empty		,//
	output fifo_valid		,//
	output fifo_underflow	,//
	//------------------======= Flag Outputs
	output reg LED_ERR		,
	output finished			,
	output vsync_oneshot	,
	
	//------------------======= DEBUG WIRING Output
	output dbg_fifo_wr_en 	,	
	output dbg_fifo_wr_ack	,	
	output dbg_fifo_full	,		
	output dbg_fifo_overflow,			
	output dbg_rst_logic	,
	output dbg_rst_fifo
	
    );
//////////////////////////////////////////////////////////////////////////////////
wire [15:0]data16;
reg [15:0]data16_test= 0;
reg [7:0]data08_test = 0;

reg [4:0]data_r_test = 5'd31;
reg [5:0]data_g_test = 6'd0;
reg [4:0]data_b_test = 5'd31;

wire bus16bit_valid; //active high
wire not_bus16bit_valid; assign not_bus16bit_valid = ~bus16bit_valid;

//wire sync_sig ; assign vsync_oneshot = sync_sig;
wire rst_logic,rst_fifo,rst_cam; assign out_reset = rst_logic; assign out_reset_camera = rst_cam;
wire rst_reg_buff; assign out_reset_reg_buff =rst_reg_buff;
wire nrst_cam_setup; assign out_nreset_cam_setup =nrst_cam_setup;
wire wr_en,wr_ack,full,overflow;
wire [15:0]fifo_data_in; //assign fifo_data_in = {8'hAA , data};
assign fifo_data_in = data16;//{data_g_test[2:0],data_b_test     ,data_r_test,data_g_test[5:3]};//data16;  data16_test  {data08_test,data08_test}
// second byte -- first byte
//G2~G0,B4~B0  -- R4~R0,G5~G3
//////////////////////////////////////////////////////////////////////////////////
always@(negedge pclk)
begin
	
	if(wr_en & href)
	begin
		data16_test <= data16_test + 1;
		data08_test <= data08_test + 1;
		//data_r_test <= data_r_test + 1;
		data_g_test <= data_g_test + 1;
		//data_b_test <= data_b_test + 1;
	end
	
end

convert8to16 convert_to16bit01 
(
.d_i			(data),//8'hBB
.vsync_i		(vsync),
.href_i			(href),
.pclk_i			(pclk),
.rst_i			(rst_logic),
.pixelReady_o	(bus16bit_valid),
.pixel_o     	(data16)
);
//////////////////////////////////////////////////////////////////////////////////
reset_ctrlr rst01
(
.out_rst_logic(rst_logic),
.out_rst_fifo(rst_fifo),
.out_rst_cam(rst_cam),
.out_nrst_usbfx(out_nrst_usbfx),

.out_rst_reg_buff(rst_reg_buff),
.out_nrst_cam_setup(nrst_cam_setup),
.cam_setup_done(in_cam_setup_done),

.rst_semi(rst_semi),
.rst_release(reset_release),
.in_clk(pclk),
.global_reset_input(global_reset_input)
);
//////////////////////////////////////////////////////////////////////////////////
/*
vsync_ctrlr vsync01
(
.clk(pclk),
.reset(rst_logic),
.vsync(vsync),
.sync_sig(sync_sig),
.finished(finished)
);
*/	
//////////////////////////////////////////////////////////////////////////////////
fifo_ver01 inst_fifo 
(
.rst(rst_fifo), 				// input rst

.wr_clk(pclk), 		// input wr_clk -- was pclk
.wr_en(wr_en), 					// input wr_en
.wr_ack(wr_ack), 				// output wr_ack
.full(full), 					// output full
.overflow(overflow), 			// output overflow
.din(fifo_data_in), 					// input [7 : 0] din 

.rd_clk(fifo_rdclk), 			// input rd_clk
.rd_en(fifo_rd_en), 			// input rd_en
.valid(fifo_valid), 			// output valid
.empty(fifo_empty), 			// output empty
.underflow(fifo_underflow),		// output underflow
.dout(fifo_dout) 				// output [15 : 0] dout	
);
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

assign wr_en = ( /*sync_sig &*/ bus16bit_valid );//(href & sync_sig & bus16bit_valid);


always@(*)
begin

	if(rst_logic==1'b1)
	begin
		LED_ERR = 1'b0;
	end
	else
	begin
		/*
		if((sync_sig==1'b1) && (full==1'b1))
		begin
			LED_ERR = 1'b1;
		end
		*/
		if(overflow==1'b1)
		begin
			LED_ERR = 1'b1;
		end
	end
end


assign dbg_fifo_wr_en 	  =  wr_en;
assign dbg_fifo_wr_ack	  =  wr_ack;
assign dbg_fifo_full	  =  full;
assign dbg_fifo_overflow  =  overflow;
assign dbg_rst_logic = rst_logic;
assign dbg_rst_fifo = rst_fifo;

endmodule
