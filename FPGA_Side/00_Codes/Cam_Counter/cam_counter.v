module cam_counter
(
	input reset				,
	
	input pclk				,
	input href		 		,
	input vsync				,

	output [19:0] byte_count,
	output reg read_trig
);


//single row counter - V2
wire sync_sig,finished;
vsync_ctrlr href01
(
.clk(pclk),
.reset(reset),
.vsync(~href),
.sync_sig(sync_sig),
.finished(finished)
);
reg [1:0] state_ended;
reg [19:0]byte_count_r;
reg [19:0]byte_count_rr;
assign byte_count = byte_count_rr;


always@(posedge pclk)
begin
	if(reset==1'b1)
	begin
		byte_count_r 	<= 0;
		read_trig 		<= 0;
		state_ended		<= 2'b00;
		byte_count_rr	= 20'b11111111111111111111;
	end
	else
	begin
		if(finished==0)
		begin
		
			if(sync_sig==1'b1 && href == 1'b1)
			begin
				byte_count_r <= byte_count_r + 1;
			end
		
		end
		else
		begin
			byte_count_rr=byte_count_r;
			read_trig <= 1'b1;
		end
	end
end



/*
//total frame counter - V2
wire sync_sig,finished;
vsync_ctrlr vsync01
(
.clk(pclk),
.reset(reset),
.vsync(vsync),
.sync_sig(sync_sig),
.finished(finished)
);
reg [1:0] state_ended;
reg [19:0]byte_count_r;
reg [19:0]byte_count_rr;
assign byte_count = byte_count_rr;


always@(posedge pclk)
begin
	if(reset==1'b1)
	begin
		byte_count_r 	<= 0;
		read_trig 		<= 0;
		state_ended		<= 2'b00;
		byte_count_rr	= 20'b11111111111111111111;
	end
	else
	begin
		if(finished==0)
		begin
		
			if(sync_sig==1 && href==1)
			begin
				byte_count_r <= byte_count_r + 1;
			end
		
		end
		else
		begin
			byte_count_rr=byte_count_r;
			read_trig <= 1'b1;
		end
	end
end
*/

/*

//one row counter
reg [1:0] state_ended;
reg [19:0]byte_count_r;
reg [19:0]byte_count_rr;
assign byte_count = byte_count_rr;

wire vsync_p; assign vsync_p = ~ vsync;
wire valid  ; assign valid = vsync_p & href;

always@(posedge pclk)
begin
	if(reset==1'b1)
	begin
		byte_count_r 	<= 0;
		read_trig 		<= 0;
		state_ended		<= 2'b00;
		byte_count_rr	<= 20'b11111111111111111111;
	end
	else
	begin
		if(valid==1'b1 && (state_ended == 2'b01 || state_ended == 2'b00))
		begin
			byte_count_r <= byte_count_r+1;
			state_ended <= 2'b01;
		end
		else
		begin
			if(state_ended == 2'b00)
			begin
				state_ended <= 2'b00;
				read_trig <= 0;
			end
			else
			begin
				if(state_ended == 2'b01)
				begin
					state_ended <= 2'b10;
					read_trig <= 0;
				end
				else
				begin
					if(state_ended == 2'b10)
					begin
						state_ended <= 2'b10;
						read_trig <= 1'b1;
						byte_count_rr <= byte_count_r;
					end				
				end
			end
			
		end
	end
end
*/



/*
//total frame counter
reg [1:0] state_ended;
reg [19:0]byte_count_r;
reg [19:0]byte_count_rr;
assign byte_count = byte_count_rr;

wire vsync_p; 
assign vsync_p = ~ vsync;
wire valid  ; 
assign valid = vsync_p & href;

always@(posedge pclk)
begin
	if(reset==1'b1)
	begin
		byte_count_r 	<= 0;
		read_trig 		<= 0;
		state_ended		<= 0;
		byte_count_rr	<= 20'b11111111111111111111;
	end
	else
	begin
		if(valid==1'b1 && ( state_ended == 2'b01 || state_ended == 2'b00))
		begin
			byte_count_r <= byte_count_r + 1;
			state_ended <= 2'b01;
		end
		else
		begin
			if(vsync ==1'b1 && state_ended == 2'b01)
			begin
				byte_count_rr <= byte_count_r;
				read_trig <= 1'b1;
				state_ended <= 2'b10;
			end
		end
	end
end
*/


endmodule