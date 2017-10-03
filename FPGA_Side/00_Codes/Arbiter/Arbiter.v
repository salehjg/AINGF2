module arbiter_SRAM_CTRLR
(
	input clk	,
	input sel	,
	//*******************************************************FOR SRAM1
	output reg o_mem1,			//from arbiter 	to 	ctrlr1
	output reg o_rw1,			//from arbiter 	to 	ctrlr1
	output reg [15:0]o_din1, 	//from arbiter 	to 	ctrlr1
	output reg [19:0]o_adr1,	//from arbiter 	to 	ctrlr1
	input  i_ready1,		//from ctrlr1  	to 	arbiter
	input  [15:0]i_dout1,	//from ctrlr1  	to 	arbiter
	//*******************************************************FOR SRAM2
	output reg o_mem2,			//from arbiter 	to 	ctrlr2
	output reg o_rw2,			//from arbiter 	to 	ctrlr2
	output reg [15:0]o_din2, 	//from arbiter 	to 	ctrlr2
	output reg [19:0]o_adr2,	//from arbiter 	to 	ctrlr2
	input  i_ready2,		//from ctrlr2  	to 	arbiter
	input  [15:0]i_dout2,	//from ctrlr2  	to 	arbiter
	//*******************************************************FOR FSM_A
	input 	i_mem_A,		//from FSM_A 	to 	arbiter
	input 	i_rw_A,			//from FSM_A 	to 	arbiter
	input 	[15:0]i_din_A, 	//from FSM_A 	to 	arbiter
	input 	[19:0]i_adr_A,	//from FSM_A 	to 	arbiter
	output reg  o_ready_A,		//from arbiter 	to 	FSM_A
	output reg  [15:0]o_dout_A,	//from arbiter  to 	FSM_A
	//*******************************************************FOR FSM_B
	input 	i_mem_B,		//from FSM_A 	to 	arbiter
	input 	i_rw_B,			//from FSM_A 	to 	arbiter
	input 	[15:0]i_din_B, 	//from FSM_A 	to 	arbiter
	input 	[19:0]i_adr_B,	//from FSM_A 	to 	arbiter
	output reg  o_ready_B,		//from arbiter 	to 	FSM_A
	output reg  [15:0]o_dout_B	//from arbiter  to 	FSM_A
);

always@(posedge clk)
begin


	if(sel==1'b0)
	begin
		o_mem1		<=	i_mem_A	;
		o_rw1		<=	i_rw_A	;
		o_din1		<=	i_din_A	;
		o_adr1		<=  i_adr_A ;
		
		o_mem2		<=	i_mem_B	;
		o_rw2		<=	i_rw_B	;
		o_din2		<=	i_din_B	;
		o_adr2		<=  i_adr_B ;
		
		o_dout_A	<=	i_dout1	;
		o_ready_A	<= 	i_ready1;
		
		o_dout_B	<=	i_dout2	;
		o_ready_B	<= 	i_ready2;
	end
	else
	begin
		o_mem1		<=	i_mem_B	;
		o_rw1		<=	i_rw_B	;
		o_din1		<=	i_din_B	;
		o_adr1		<=  i_adr_B ;
		
		o_mem2		<=	i_mem_A	;
		o_rw2		<=	i_rw_A	;
		o_din2		<=	i_din_A	;
		o_adr2		<=  i_adr_A ;
		
		o_dout_B	<=	i_dout1	;
		o_ready_B	<= 	i_ready1;
		
		o_dout_A	<=	i_dout2	;
		o_ready_A	<= 	i_ready2;	
	end
	
end



endmodule