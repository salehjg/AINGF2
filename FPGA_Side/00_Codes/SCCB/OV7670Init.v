
//##################################################################################################
//
// Register configuration for OV7670 camera module.
// Initializes RGB565 VGA, with distorted colors... I yet to find the register settings to fix this. 
//
//
// Calculating required clock frequency. 30fps RGB565 VGA:
//
//  HREF  = tLINE = 640*tP + 144*tP = 784*tP
//  VSYNC = 510 * tLINE = 510 * 784*tP
//  PCLK  = VSYNC * FPS * BYTES_PER_PIXEL = 784 * 510 * 30 * 2 = 23990400 ~= 24MHz
//	
////////////////////////////////////////////////////////////////////////
//	clk: clock - only for changing script values.
//  din: data input for selected index of script.
//	index: index of desired row in script.
//  wr_en: wr_en should be high in posedge of clk.
//	reset: active low reset - required on power-up to init reg_buff
//
//##################################################################################################

`timescale 1ns / 1ps

module OV7670Init ( index_i, data_o, reset,
					clk, din, index, wr_en, rd_en, dout
					);
input       [5:0] index_i;    // Register index.
output reg  [16:0] data_o;    // {Register_address, register_value, rw_flag} :
							 //  Where register_value is the value to write if rw_flag = 1
							 //  otherwise it's not used when rw_flag = 0 (read).
							 // {16'hffff, 1'b1} - denotes end of the register set.
							 // {16'hf0f0, 1'b1} - denotes that a delay is needed at this point.
							 
							 
parameter script_lengh = 56;							 
parameter script_lengh_bit_count = 6;							 
input clk;
input [15:0] din;
input [script_lengh_bit_count-1:0]	 index; // register count is 56 -- 6 bits
input wr_en;
input reset;
input rd_en;
output reg [15:0]dout;

////////////////////////////////////////////////////////////////////								 
reg [15:0] reg_buff[0:script_lengh-1]; //56 registers -- each 16 bits

always@(posedge clk or negedge reset)
begin
	if(reset==0)
	begin
		
		reg_buff[0]  = 16'h1280  ;// COM7     Reset.
		reg_buff[1]  = 16'hf0f0  ;// Denotes delay.
		reg_buff[2]  = 16'h1204  ;// COM7     Set RGB (06 enables color bar overlay).
		reg_buff[3]  = 16'h1140  ;// CLKRC    Use external clock directly.												-- was 0x1100
		reg_buff[4]  = 16'h0C00  ;// COM3     Disable DCW & scalling. + RSVD bits.
		reg_buff[5]  = 16'h3E00  ;// COM14    Normal PCLK.
		reg_buff[6]  = 16'h8C00  ;// RGB444   Disable RGB444
		reg_buff[7]  = 16'h0400  ;// COM1     Disable CCIR656. AEC low 2 LSB.
		reg_buff[8]  = 16'h40d0  ;// COM15    Set RGB565 full value range
		reg_buff[9]  = 16'h3a04  ;// TSLB     Don't set window automatically. + RSVD bits.
		reg_buff[10] = 16'h1418  ;// COM9     Maximum AGC value x4. Freeze AGC/AEC. + RSVD bits.
		reg_buff[11] = 16'h4fb3  ;// MTX1     Matrix Coefficient 1
		reg_buff[12] = 16'h50b3  ;// MTX2     Matrix Coefficient 2
		reg_buff[13] = 16'h5100  ;// MTX3     Matrix Coefficient 3
		reg_buff[14] = 16'h523d  ;// MTX4     Matrix Coefficient 4
		reg_buff[15] = 16'h53a7  ;// MTX5     Matrix Coefficient 5
		reg_buff[16] = 16'h54e4  ;// MTX6     Matrix Coefficient 6
		reg_buff[17] = 16'h589e  ;// MTXS     Enable auto contrast center. Matrix coefficient sign. + RSVD bits.
		reg_buff[18] = 16'h3dc0  ;// COM13    Gamma enable. + RSVD bits.
		reg_buff[19] = 16'h1140  ;// CLKRC    Use external clock directly.												 -- was 0x1100
		reg_buff[20] = 16'h1714  ;// HSTART   HREF start high 8 bits.
		reg_buff[21] = 16'h1802  ;// HSTOP    HREF stop high 8 bits.
		reg_buff[22] = 16'h3280  ;// HREF     HREF edge offset. HSTART/HSTOP low 3 bits.
		reg_buff[23] = 16'h1903  ;// VSTART   VSYNC start high 8 bits.
		reg_buff[24] = 16'h1A7b  ;// VSTOP    VSYNC stop high 8 bits.
		reg_buff[25] = 16'h030a  ;// VREF     VSYNC edge offset. VSTART/VSTOP low 3 bits.
		reg_buff[26] = 16'h0f41  ;// COM6     Disable HREF at optical black. Reset timings. + RSVD bits.
		reg_buff[27] = 16'h1e03  ;// MVFP     No mirror/vflip. Black sun disable. + RSVD bits.
		reg_buff[28] = 16'h330b  ;// CHLF     Array Current Control - Reserved  
		reg_buff[29] = 16'h373f  ;// ADC 
		reg_buff[30] = 16'h3871  ;// ACOM     ADC and Analog Common Mode Control - Reserved
		reg_buff[31] = 16'h392a  ;// OFON     ADC Offset Control - Reserved               
		reg_buff[32] = 16'h3c78  ;// COM12    No HREF when VSYNC is low. + RSVD bits.
		reg_buff[33] = 16'h6900  ;// GFIX     Fix Gain Control? No.    
		reg_buff[34] = 16'h6b1a  ;// DBLV     Bypass PLL. Enable internal regulator. + RSVD bits.
		reg_buff[35] = 16'h7400  ;// REG74    Digital gain controlled by VREF[7:6]. + RSVD bits.
		reg_buff[36] = 16'hb084  ;// RSVD     ?          
		reg_buff[37] = 16'hb10c  ;// ABLC1    Enable ABLC function. + RSVD bits.
		reg_buff[38] = 16'hb20e  ;// RSVD     ?
		reg_buff[39] = 16'hb380  ;// THL_ST   ABLC Target.
		reg_buff[40] = 16'h7a20  ;// SLOP     Gamma Curve Highest Segment Slope
		reg_buff[41] = 16'h7b10  ;// GAM1
		reg_buff[42] = 16'h7c1e  ;// GAM2
		reg_buff[43] = 16'h7d35  ;// GAM3
		reg_buff[44] = 16'h7e5a  ;// GAM4
		reg_buff[45] = 16'h7f69  ;// GAM5
		reg_buff[46] = 16'h8076  ;// GAM6
		reg_buff[47] = 16'h8180  ;// GAM7
		reg_buff[48] = 16'h8288  ;// GAM8
		reg_buff[49] = 16'h838f  ;// GAM9
		reg_buff[50] = 16'h8496  ;// GAM10
		reg_buff[51] = 16'h85a3  ;// GAM11
		reg_buff[52] = 16'h86af  ;// GAM12
		reg_buff[53] = 16'h87c4  ;// GAM13
		reg_buff[54] = 16'h88d7  ;// GAM14
		reg_buff[55] = 16'h89e8  ;// GAM15*/
		
		
	end
	else
	begin
		if(wr_en)
		begin
			(* parallel_case *) case(index)
			
				6'd0:  reg_buff[0] 	= din[15:0];
				6'd1:  reg_buff[1] 	= din[15:0];
				6'd2:  reg_buff[2] 	= din[15:0];
				6'd3:  reg_buff[3] 	= din[15:0];
				6'd4:  reg_buff[4] 	= din[15:0];
				6'd5:  reg_buff[5] 	= din[15:0];
				6'd6:  reg_buff[6] 	= din[15:0];
				6'd7:  reg_buff[7] 	= din[15:0];
				6'd8:  reg_buff[8] 	= din[15:0];
				6'd9:  reg_buff[9] 	= din[15:0];
				6'd10: reg_buff[10] = din[15:0];
				6'd11: reg_buff[11] = din[15:0];
				6'd12: reg_buff[12] = din[15:0];
				6'd13: reg_buff[13] = din[15:0];
				6'd14: reg_buff[14] = din[15:0];
				6'd15: reg_buff[15] = din[15:0];
				6'd16: reg_buff[16] = din[15:0];
				6'd17: reg_buff[17] = din[15:0];
				6'd18: reg_buff[18] = din[15:0];
				6'd19: reg_buff[19] = din[15:0];
				6'd20: reg_buff[20] = din[15:0];
				6'd21: reg_buff[21] = din[15:0];
				6'd22: reg_buff[22] = din[15:0];
				6'd23: reg_buff[23] = din[15:0];
				6'd24: reg_buff[24] = din[15:0];
				6'd25: reg_buff[25] = din[15:0];
				6'd26: reg_buff[26] = din[15:0];
				6'd27: reg_buff[27] = din[15:0];
				6'd28: reg_buff[28] = din[15:0];
				6'd29: reg_buff[29] = din[15:0];
				6'd30: reg_buff[30] = din[15:0];
				6'd31: reg_buff[31] = din[15:0];
				6'd32: reg_buff[32] = din[15:0];
				6'd33: reg_buff[33] = din[15:0];
				6'd34: reg_buff[34] = din[15:0];
				6'd35: reg_buff[35] = din[15:0];
				6'd36: reg_buff[36] = din[15:0];
				6'd37: reg_buff[37] = din[15:0];
				6'd38: reg_buff[38] = din[15:0];
				6'd39: reg_buff[39] = din[15:0];
				6'd40: reg_buff[40] = din[15:0];
				6'd41: reg_buff[41] = din[15:0];
				6'd42: reg_buff[42] = din[15:0];
				6'd43: reg_buff[43] = din[15:0];
				6'd44: reg_buff[44] = din[15:0];
				6'd45: reg_buff[45] = din[15:0];
				6'd46: reg_buff[46] = din[15:0];
				6'd47: reg_buff[47] = din[15:0];
				6'd48: reg_buff[48] = din[15:0];
				6'd49: reg_buff[49] = din[15:0];
				6'd50: reg_buff[50] = din[15:0];
				6'd51: reg_buff[51] = din[15:0];
				6'd52: reg_buff[52] = din[15:0];
				6'd53: reg_buff[53] = din[15:0];
				6'd54: reg_buff[54] = din[15:0];
				6'd55: reg_buff[55] = din[15:0];
				default: reg_buff[55] = reg_buff[55];				
			endcase
		end
		else
		begin
			if(rd_en)
			begin
				(* parallel_case *) case(index)
					6'd0:  dout[15:0] = reg_buff[0] ;
					6'd1:  dout[15:0] = reg_buff[1] ;
					6'd2:  dout[15:0] = reg_buff[2] ;
					6'd3:  dout[15:0] = reg_buff[3] ;
					6'd4:  dout[15:0] = reg_buff[4] ;
					6'd5:  dout[15:0] = reg_buff[5] ;
					6'd6:  dout[15:0] = reg_buff[6] ;
					6'd7:  dout[15:0] = reg_buff[7] ;
					6'd8:  dout[15:0] = reg_buff[8] ;
					6'd9:  dout[15:0] = reg_buff[9] ;
					6'd10: dout[15:0] = reg_buff[10];
					6'd11: dout[15:0] = reg_buff[11];
					6'd12: dout[15:0] = reg_buff[12];
					6'd13: dout[15:0] = reg_buff[13];
					6'd14: dout[15:0] = reg_buff[14];
					6'd15: dout[15:0] = reg_buff[15];
					6'd16: dout[15:0] = reg_buff[16];
					6'd17: dout[15:0] = reg_buff[17];
					6'd18: dout[15:0] = reg_buff[18];
					6'd19: dout[15:0] = reg_buff[19];
					6'd20: dout[15:0] = reg_buff[20];
					6'd21: dout[15:0] = reg_buff[21];
					6'd22: dout[15:0] = reg_buff[22];
					6'd23: dout[15:0] = reg_buff[23];
					6'd24: dout[15:0] = reg_buff[24];
					6'd25: dout[15:0] = reg_buff[25];
					6'd26: dout[15:0] = reg_buff[26];
					6'd27: dout[15:0] = reg_buff[27];
					6'd28: dout[15:0] = reg_buff[28];
					6'd29: dout[15:0] = reg_buff[29];
					6'd30: dout[15:0] = reg_buff[30];
					6'd31: dout[15:0] = reg_buff[31];
					6'd32: dout[15:0] = reg_buff[32];
					6'd33: dout[15:0] = reg_buff[33];
					6'd34: dout[15:0] = reg_buff[34];
					6'd35: dout[15:0] = reg_buff[35];
					6'd36: dout[15:0] = reg_buff[36];
					6'd37: dout[15:0] = reg_buff[37];
					6'd38: dout[15:0] = reg_buff[38];
					6'd39: dout[15:0] = reg_buff[39];
					6'd40: dout[15:0] = reg_buff[40];
					6'd41: dout[15:0] = reg_buff[41];
					6'd42: dout[15:0] = reg_buff[42];
					6'd43: dout[15:0] = reg_buff[43];
					6'd44: dout[15:0] = reg_buff[44];
					6'd45: dout[15:0] = reg_buff[45];
					6'd46: dout[15:0] = reg_buff[46];
					6'd47: dout[15:0] = reg_buff[47];
					6'd48: dout[15:0] = reg_buff[48];
					6'd49: dout[15:0] = reg_buff[49];
					6'd50: dout[15:0] = reg_buff[50];
					6'd51: dout[15:0] = reg_buff[51];
					6'd52: dout[15:0] = reg_buff[52];
					6'd53: dout[15:0] = reg_buff[53];
					6'd54: dout[15:0] = reg_buff[54];
					6'd55: dout[15:0] = reg_buff[55];
					default: dout[15:0] = 16'hFFFF;			
				endcase			
			end
			
		end
		
			
	end
end   
////////////////////////////////////////////////////////////////////  
   always @(index_i,
			
			reg_buff[0] , reg_buff[1] , reg_buff[2] , reg_buff[3] , 
			reg_buff[4] , reg_buff[5] , reg_buff[6] , reg_buff[7] , 
			reg_buff[8] , reg_buff[9] , reg_buff[10], reg_buff[11], 
			reg_buff[12], reg_buff[13], reg_buff[14], reg_buff[15], 
			reg_buff[16], reg_buff[17], reg_buff[18], reg_buff[19], 
			reg_buff[20], reg_buff[21], reg_buff[22], reg_buff[23], 
			reg_buff[24], reg_buff[25], reg_buff[26], reg_buff[27], 
			reg_buff[28], reg_buff[29], reg_buff[30], reg_buff[31], 
			reg_buff[32], reg_buff[33], reg_buff[34], reg_buff[35], 
			reg_buff[36], reg_buff[37], reg_buff[38], reg_buff[39], 
			reg_buff[40], reg_buff[41], reg_buff[42], reg_buff[43], 
			reg_buff[44], reg_buff[45], reg_buff[46], reg_buff[47], 
			reg_buff[48], reg_buff[49], reg_buff[50], reg_buff[51], 
			reg_buff[52], reg_buff[53], reg_buff[54], reg_buff[55]
			
			) 
   
   
   
   begin
      (* parallel_case *) (* parallel_case *) case(index_i)
         //6'd0 : data_o = {16'h0A76, 1'b0}; 
         6'd0 : data_o = {reg_buff[0], 1'b1};   
         6'd1 : data_o = {reg_buff[1], 1'b1};   
         6'd2 : data_o = {reg_buff[2], 1'b1};   
         6'd3 : data_o = {reg_buff[3], 1'b1};   
         6'd4 : data_o = {reg_buff[4], 1'b1};   
         6'd5 : data_o = {reg_buff[5], 1'b1};   
         6'd6 : data_o = {reg_buff[6], 1'b1};   
         6'd7 : data_o = {reg_buff[7], 1'b1};   
         6'd8 : data_o = {reg_buff[8], 1'b1};   
		                  
         6'd9 : data_o = {reg_buff[9], 1'b1};    
         6'd10: data_o = {reg_buff[10], 1'b1};   
         6'd11: data_o = {reg_buff[11], 1'b1};   
         6'd12: data_o = {reg_buff[12], 1'b1};   
         6'd13: data_o = {reg_buff[13], 1'b1};   
         6'd14: data_o = {reg_buff[14], 1'b1};   
         6'd15: data_o = {reg_buff[15], 1'b1};   
         6'd16: data_o = {reg_buff[16], 1'b1};   
         6'd17: data_o = {reg_buff[17], 1'b1};   
         6'd18: data_o = {reg_buff[18], 1'b1};   
         6'd19: data_o = {reg_buff[19], 1'b1};   
         6'd20: data_o = {reg_buff[20], 1'b1};   
         6'd21: data_o = {reg_buff[21], 1'b1};   
         6'd22: data_o = {reg_buff[22], 1'b1};   
         6'd23: data_o = {reg_buff[23], 1'b1};   
         6'd24: data_o = {reg_buff[24], 1'b1};   
         6'd25: data_o = {reg_buff[25], 1'b1};   
         6'd26: data_o = {reg_buff[26], 1'b1};   
         6'd27: data_o = {reg_buff[27], 1'b1};   
         6'd28: data_o = {reg_buff[28], 1'b1};   
		 //6'd29: data_o = {reg_buff[29], 1'b1};
         //6'd30: data_o = {reg_buff[30], 1'b1};
         //6'd31: data_o = {reg_buff[31], 1'b1};
         6'd29: data_o = {reg_buff[32], 1'b1};  
         6'd30: data_o = {reg_buff[33], 1'b1};  
         6'd31: data_o = {reg_buff[34], 1'b1};  
         6'd32: data_o = {reg_buff[35], 1'b1};  
         6'd33: data_o = {reg_buff[36], 1'b1};  
         6'd34: data_o = {reg_buff[37], 1'b1};  
         6'd35: data_o = {reg_buff[38], 1'b1};  
         6'd36: data_o = {reg_buff[39], 1'b1};  
		 
		 
       /*6'd37: data_o = {reg_buff[40], 1'b1};    
         6'd38: data_o = {reg_buff[41], 1'b1};   
         6'd39: data_o = {reg_buff[42], 1'b1};   
         6'd40: data_o = {reg_buff[43], 1'b1};   
         6'd41: data_o = {reg_buff[44], 1'b1};   
         6'd42: data_o = {reg_buff[45], 1'b1};   
         6'd43: data_o = {reg_buff[46], 1'b1};   
         6'd44: data_o = {reg_buff[47], 1'b1};   
         6'd45: data_o = {reg_buff[48], 1'b1};   
         6'd46: data_o = {reg_buff[49], 1'b1};   
         6'd47: data_o = {reg_buff[50], 1'b1};   
         6'd48: data_o = {reg_buff[51], 1'b1};   
         6'd49: data_o = {reg_buff[52], 1'b1};   
         6'd50: data_o = {reg_buff[53], 1'b1};   
         6'd51: data_o = {reg_buff[54], 1'b1};   
         6'd52: data_o = {reg_buff[55], 1'b1};   */
         default: data_o = {16'hffff, 1'b1};
      endcase
   end

endmodule