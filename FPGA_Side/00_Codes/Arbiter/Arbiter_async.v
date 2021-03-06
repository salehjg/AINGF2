module arbiter_SRAM_CTRLR_V2
(
	input sel	,
	input clk	,				//not used!
	//*******************************************************FOR SRAM1
	output reg o_mem1,			//from arbiter 	to 	ctrlr1
	output reg o_rw1,			//from arbiter 	to 	ctrlr1
	output reg [15:0]o_din1, 	//from arbiter 	to 	ctrlr1
	output reg [19:0]o_adr1,	//from arbiter 	to 	ctrlr1
	input  i_ready1,			//from ctrlr1  	to 	arbiter
	input  [15:0]i_dout1,		//from ctrlr1  	to 	arbiter
	//*******************************************************FOR SRAM2
	output reg o_mem2,			//from arbiter 	to 	ctrlr2
	output reg o_rw2,			//from arbiter 	to 	ctrlr2
	output reg [15:0]o_din2, 	//from arbiter 	to 	ctrlr2
	output reg [19:0]o_adr2,	//from arbiter 	to 	ctrlr2
	input  i_ready2,			//from ctrlr2  	to 	arbiter
	input  [15:0]i_dout2,		//from ctrlr2  	to 	arbiter
	//*******************************************************FOR FSM_A
	input 	i_mem_A,			//from FSM_A 	to 	arbiter
	input 	i_rw_A,				//from FSM_A 	to 	arbiter
	input 	[15:0]i_din_A, 		//from FSM_A 	to 	arbiter
	input 	[19:0]i_adr_A,		//from FSM_A 	to 	arbiter
	output reg  o_ready_A,		//from arbiter 	to 	FSM_A
	output reg  [15:0]o_dout_A,	//from arbiter  to 	FSM_A
	//*******************************************************FOR FSM_B
	input 	i_mem_B,			//from FSM_A 	to 	arbiter
	input 	i_rw_B,				//from FSM_A 	to 	arbiter
	input 	[15:0]i_din_B, 		//from FSM_A 	to 	arbiter
	input 	[19:0]i_adr_B,		//from FSM_A 	to 	arbiter
	output reg  o_ready_B,		//from arbiter 	to 	FSM_A
	output reg  [15:0]o_dout_B	//from arbiter  to 	FSM_A
);

always@(
sel			,
i_ready1	,i_ready2		,
i_mem_A		,i_rw_A			,
i_mem_B		,i_rw_B			,

i_dout1[0]	,i_dout1[1]		,i_dout1[2]		,i_dout1[3]		,i_dout1[4]		,i_dout1[5]		,i_dout1[6]		,i_dout1[7]	,
i_dout1[8]	,i_dout1[9]		,i_dout1[10]	,i_dout1[11]	,i_dout1[12]	,i_dout1[13]	,i_dout1[14]	,i_dout1[15],
	
i_dout2[0]	,i_dout2[1]		,i_dout2[2]		,i_dout2[3]		,i_dout2[4]		,i_dout2[5]		,i_dout2[6]		,i_dout2[7]	,
i_dout2[8]	,i_dout2[9]		,i_dout2[10]	,i_dout2[11]	,i_dout2[12]	,i_dout2[13]	,i_dout2[14]	,i_dout2[15],
	
i_din_A[0]	,i_din_A[1]		,i_din_A[2]		,i_din_A[3]		,i_din_A[4]		,i_din_A[5]		,i_din_A[6]		,i_din_A[7]	,
i_din_A[8]	,i_din_A[9]		,i_din_A[10]	,i_din_A[11]	,i_din_A[12]	,i_din_A[13]	,i_din_A[14]	,i_din_A[15],
	
i_din_B[0]	,i_din_B[1]		,i_din_B[2]		,i_din_B[3]		,i_din_B[4]		,i_din_B[5]		,i_din_B[6]		,i_din_B[7]	,
i_din_B[8]	,i_din_B[9]		,i_din_B[10]	,i_din_B[11]	,i_din_B[12]	,i_din_B[13]	,i_din_B[14]	,i_din_B[15],
	
	
i_adr_A[0]	,i_adr_A[1]		,i_adr_A[2]		,i_adr_A[3]		,i_adr_A[4]		,i_adr_A[5]		,i_adr_A[6]		,i_adr_A[7]	,
i_adr_A[8]	,i_adr_A[9]		,i_adr_A[10]	,i_adr_A[11]	,i_adr_A[12]	,i_adr_A[13]	,i_adr_A[14]	,i_adr_A[15],
i_adr_A[16]	,i_adr_A[17]	,i_adr_A[18]	,i_adr_A[19],	
	
i_adr_B[0]	,i_adr_B[1]		,i_adr_B[2]		,i_adr_B[3]		,i_adr_B[4]		,i_adr_B[5]		,i_adr_B[6]		,i_adr_B[7]	,
i_adr_B[8]	,i_adr_B[9]		,i_adr_B[10]	,i_adr_B[11]	,i_adr_B[12]	,i_adr_B[13]	,i_adr_B[14]	,i_adr_B[15],
i_adr_B[16]	,i_adr_B[17]	,i_adr_B[18]	,i_adr_B[19]	
)
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