


//--------------------------------------
//.............FSM A(CAM)...............
//--------------------------------------
always@(*)
begin : FSM_A
Cstate_next		= Cstate;	
rw1 	= 1'b0;
mem1	= 1'b0;	
r_addr_next1		= r_addr1;				//CHECKED	
dbg_fifo_dout_next = dbg_fifo_dout;		//CHECKED

	case (Cstate)

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
				Cstate_next = C2;
				dbg_data_cnt_r = r_addr1;
			end
			
			
			rw1 	= 1'b0;
			mem1 	= 1'b0;				
		end
		
	C2:		
		begin
			if(FSM_B_flag_addr_sampled==1'b1)
			begin
				r_addr_next1 = 20'd0;
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
			data_f2s1 = fifo_dout;
			dbg_fifo_dout_next = fifo_dout;
		end
	C4:	///// sram write cycle 02
		begin
			rd_en = 1'b0;
			rw1 	= 1'b0;
			mem1 = 1'b0;	
			if(w_ready==1'b0)
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
	
end














	
//--------------------------------------
//.............FSM B(USB)...............
//--------------------------------------
always@(*)
begin : FSM_B
Ustate_next		= Ustate;	
arbiter_sel_next = arbiter_sel;
sloe_i = 1'b1;
faddr_i= 2'b10;   //	IDLE STATE
slrd_i = 1'b1;
slwr_i = 1'b1;
pktend_i = 1'b1;
rw2 	= 1'b1;
mem2 	= 1'b0;	
r_addr_next2		= r_addr2;				//CHECKED	
FSM_B_flag_addr_sampled_next = FSM_B_flag_addr_sampled;

	case (Ustate)
	U0://IDLE STATE!
		begin
			if(vsync==1'b1)
			begin
				arbiter_sel_next = ~arbiter_sel;
				r_addr_next2 = r_addr1; //sample current address of FSM_A before having it zero'ed!
				Ustate_next = U5;
			end
			else
			begin
				Ustate_next = U0;
			end
		
		end
	U5:
		begin
			FSM_B_flag_addr_sampled_next = 1'b1;
			Ustate_next = U1;
		end
	
	
	U1:	///// sram Read cycle 00 
		begin

			sloe_i = 1'b1;
			faddr_i= 2'b10;   //	IDLE STATE
			slrd_i = 1'b1;
			slwr_i = 1'b1;
			
			if(r_addr==20'hFFFFF) //CHANGABLE R_ADDR!!!! DONT FOGET! 
			begin
				FSM_B_flag_addr_sampled_next = 1'b0;
				Ustate_next = U0;//READING HAS FINISHED!(  ___SUCCEED____!)
				pktend_i = 1'b0;
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
				
			if(w_ready==1'b0)
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
				led_red = 1'b1;
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