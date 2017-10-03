module I3C_BUS
(
	input		rst			,
	input 		bus_clk		,
	output reg 	bus_dout	,
	input 		bus_din		,
	//------------
	input [15:0] 		parallel_din,
	output reg [15:0]	parallel_dout,
	output reg 			data_ready,
	
	output dbg_state

);

//-------------------------------------------

localparam S0 = 1'D0;
localparam S1 = 1'D1;

/*
localparam S0 = 3'D0;
localparam S1 = 3'D1;
localparam S2 = 3'D2;
localparam S3 = 3'D3;
localparam S4 = 3'D4;
localparam S5 = 3'D5;
localparam S6 = 3'D6;
localparam S7 = 3'D7;
*/
// - - - - - - - - - -
reg	state=0;

assign dbg_state = state;
// - - - - - - - - - -
reg [4:0] bit_counter=0;
reg [15:0] r_parallel_din;
reg [15:0] r_parallel_dout=0;

//-------------------------------------------
always@(posedge bus_clk or posedge rst)
begin
	if(rst)
	begin
		state=0;
		bit_counter = 0;
		parallel_dout = 0;
		data_ready = 0;
	end
	else
	begin
		data_ready = 0;
		////////////////////////////////
		case(state)
			S0://idle
			begin
				
				r_parallel_dout = 0;
				
				bit_counter=0;
				r_parallel_din[0] = parallel_din[15];
				r_parallel_din[1] = parallel_din[14];
				r_parallel_din[2] = parallel_din[13];
				r_parallel_din[3] = parallel_din[12];
				r_parallel_din[4] = parallel_din[11];
				r_parallel_din[5] = parallel_din[10];
				r_parallel_din[6] = parallel_din[9];
				r_parallel_din[7] = parallel_din[8];
				r_parallel_din[8] = parallel_din[7];
				r_parallel_din[9] = parallel_din[6];
				r_parallel_din[10] = parallel_din[5];
				r_parallel_din[11] = parallel_din[4];
				r_parallel_din[12] = parallel_din[3];
				r_parallel_din[13] = parallel_din[2];
				r_parallel_din[14] = parallel_din[1];
				r_parallel_din[15] = parallel_din[0];
				state=S1;
			end
			///////////////////////////////////
			S1://get data from bus & put data on bus
			begin
				if(bit_counter < 5'D16)
				begin
					bus_dout 		= r_parallel_din[0];
					r_parallel_din 	= r_parallel_din >> 1;
					r_parallel_dout	= {r_parallel_dout[14:0],bus_din};
					bit_counter 	= bit_counter + 1;
				end
				else
				begin
					parallel_dout = r_parallel_dout;
					data_ready = 1'd1;
					state=S0;			
				end
				
			end
			/*
			///////////////////////////////////
			S2:
			begin
			
			end
			///////////////////////////////////
			S3:
			begin
			
			end
			///////////////////////////////////
			S4:
			begin
			
			end
			///////////////////////////////////
			S5:
			begin
			
			end
			///////////////////////////////////
			S6:
			begin
			
			end
			///////////////////////////////////
			S7:
			begin
			
			end
			*/
			///////////////////////////////////
			/*
			default:
			begin
				state_next=S0;
			end
			*/
			///////////////////////////////////
		endcase	
	end	
end

	

endmodule