/*******************************************************************
**** SRAM CONTROLLER
**** 3 CYCLES BACK TO BACK.
**** SAFE & REFRENCE DESIGN.
****
****	REFRENCE:
****		FPGA Prototyping By Verilog Examples-page 278~281.
****
****
****
********************************************************************/



module sram_controller
(
	input clk, reset ,
	// to/from main system
	input mem, rw,
	input [19:0] addr ,
	input [15:0] data_f2s,
	output reg ready ,
	output [15:0] data_s2f_r , data_s2f_ur ,
	// to/from sram chip
	output [19:0] ad ,
	output we_n, oe_n,
	// sram chip a
	inout [15:0] dio_a,
	output ce_a_n, ub_a_n, lb_a_n
);

	localparam [2:0]
		idle 	= 3'b000,
		rd1 	= 3'b001,
		rd2		= 3'b010,
		wr1		= 3'b011,
		wr2		= 3'b100;
		
		
	reg	[2:0] state_reg=idle;
	reg	[2:0] state_next=idle;
	reg	[15:0] data_f2s_reg=0, data_f2s_next;
	reg [15:0] data_s2f_reg=0, data_s2f_next;
	reg	[19:0] addr_reg=0, addr_next;
	reg we_buf, oe_buf,tri_buf;
	reg we_reg=0, oe_reg=0, tri_reg=0;

	//FSMD STATE & DATA REGs
	always@(posedge clk, posedge reset)
	begin
		if(reset)
		begin
			state_reg <= idle;
			addr_reg <= 0;
			data_f2s_reg<=0;
			data_s2f_reg <=0;
			tri_reg <=1'b1;
			we_reg<= 1'b1;
			oe_reg<=1'b1;
		end
		else
		begin
			state_reg <= state_next;
			addr_reg <= addr_next;
			data_f2s_reg <= data_f2s_next;
			data_s2f_reg <= data_s2f_next;
			tri_reg <= tri_buf;
			we_reg <= we_buf;
			oe_reg <= oe_buf;
		end
		
	end



	//FSMD NEXT-STATE LOGIC
	always@(*)
	begin
		addr_next = addr_reg;
		data_f2s_next = data_f2s_reg;
		data_s2f_next = data_s2f_reg;
		ready = 1'b0;
		//---------
		case(state_reg)
			idle:
			begin
				if(~mem)
				begin
					state_next = idle;
				end
				else
				begin
					addr_next = addr;
					if(~rw) //write
					begin
						state_next = wr1;
						data_f2s_next = data_f2s;
					end
					else
					begin	//read
						state_next = rd1;
					end
				end
				ready = 1'b1;
			end
			//=====================================
			wr1:
				state_next = wr2;
			wr2:
			begin
				//state_next = idle;
				if(~mem)
				begin
					state_next = idle;
				end
				else
				begin
					addr_next = addr;
					if(~rw) //write
					begin
						state_next = wr1;
						data_f2s_next = data_f2s;
					end
					else
					begin	//read
						state_next = rd1;
					end
				end
				///ready = 1'b1;				
			end
			rd1:
				state_next = rd2;
			rd2:
			begin
				data_s2f_next = dio_a;
				//state_next = idle;
				if(~mem)
				begin
					state_next = idle;
				end
				else
				begin
					addr_next = addr;
					if(~rw) //write
					begin
						state_next = wr1;
						data_f2s_next = data_f2s;
					end
					else
					begin	//read
						state_next = rd1;
					end
				end
				///ready = 1'b1;								
			end
			default:
				state_next = idle;
		endcase	
	end





	//LOOK-AHEAD OUTPUT LOGIC
	always@(*)
	begin
		tri_buf = 1'b1;
		we_buf = 1'b1;
		oe_buf = 1'b1;
		case(state_next)
			idle:
				oe_buf = 1'b1;
			wr1:
			begin
				tri_buf = 1'b0;
				we_buf	= 1'b0;
			end
			wr2:
				tri_buf = 1'b0;
			rd1:
				oe_buf = 1'b0;
			rd2:
				oe_buf = 1'b0;
		endcase
	end

	//to main system
	assign data_s2f_r = data_s2f_reg;
	assign data_s2f_ur= dio_a;
	//to sram
	assign we_n = we_reg;
	assign oe_n = oe_reg;
	assign ad = addr_reg;
	// IO for sram chip (A)
	assign ce_a_n = 1'b0;
	assign ub_a_n = 1'b0;
	assign lb_a_n = 1'b0;

	assign dio_a = (~tri_reg) ? data_f2s_reg : 16'bz;

endmodule



