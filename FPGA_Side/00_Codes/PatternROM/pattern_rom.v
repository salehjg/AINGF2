/*
*	Module Name: 	PATTERN_ROM
*	Desc.:	
*		Frame start pattern data.
*
*	----------------------
*	data_o structure:
*		
*		
*		
*       
*	    
*	----------------------
*	Coded by SalehJG, 10.6
*	Version: V1.0
*/


module PATTERN_ROM
(
	input[5:0]i_index,
	output reg[15:0]data_o
);


always@(i_index)
begin
(* parallel_case *) case(i_index)
	6'd00 : data_o = 16'hABCD; 
	6'd01 : data_o = 16'hEF89; 
	6'd02 : data_o = 16'b1011_1101_1110_0111; //BDE7
	6'd03 : data_o = 16'b1111_0000_1010_0101; //F0A5
	6'd04 : data_o = 16'b1011_1101_1110_0111; 
	6'd05 : data_o = 16'b1111_0000_1010_0101; 
	6'd06 : data_o = 16'b1011_1101_1110_0111; 
	6'd07 : data_o = 16'b1111_0000_1010_0101; 
	6'd08 : data_o = 16'b1011_1101_1110_0111; 
	6'd09 : data_o = 16'b1111_0000_1010_0101; 
	6'd10 : data_o = 16'b1011_1101_1110_0111; 
	6'd11 : data_o = 16'b1111_0000_1010_0101; 
	6'd12 : data_o = 16'b1011_1101_1110_0111; 
	6'd13 : data_o = 16'b1111_0000_1010_0101; 
	6'd14 : data_o = 16'b1011_1101_1110_0111; 
	6'd15 : data_o = 16'b1111_0000_1010_0101; 
	6'd16 : data_o = 16'b1011_1101_1110_0111; 
	6'd17 : data_o = 16'b1111_0000_1010_0101; 
	6'd18 : data_o = 16'b1011_1101_1110_0111; 
	6'd19 : data_o = 16'b1111_0000_1010_0101; 
	6'd20 : data_o = 16'b1011_1101_1110_0111; 
	6'd21 : data_o = 16'b1111_0000_1010_0101; 
	6'd22 : data_o = 16'b1011_1101_1110_0111; 
	6'd23 : data_o = 16'b1111_0000_1010_0101; 
	6'd24 : data_o = 16'b1011_1101_1110_0111; 
	6'd25 : data_o = 16'b1111_0000_1010_0101; 
	6'd26 : data_o = 16'b1011_1101_1110_0111; 
	6'd27 : data_o = 16'b1111_0000_1010_0101; 
	6'd28 : data_o = 16'b1011_1101_1110_0111; 
	6'd29 : data_o = 16'b1111_0000_1010_0101; 
	6'd30 : data_o = 16'b1011_1101_1110_0111; 
	6'd31 : data_o = 16'b1111_0000_1010_0101; 
	6'd32 : data_o = 16'b1011_1101_1110_0111; 
	6'd33 : data_o = 16'b1111_0000_1010_0101; 
	6'd34 : data_o = 16'b1011_1101_1110_0111; 
	6'd35 : data_o = 16'b1111_0000_1010_0101; 
	6'd36 : data_o = 16'b1011_1101_1110_0111; 
	6'd37 : data_o = 16'b1111_0000_1010_0101; 
	6'd38 : data_o = 16'b1011_1101_1110_0111; 
	6'd39 : data_o = 16'b1111_0000_1010_0101; 
	6'd40 : data_o = 16'b1011_1101_1110_0111; 
	6'd41 : data_o = 16'b1111_0000_1010_0101; 
	6'd42 : data_o = 16'b1011_1101_1110_0111; 
	6'd43 : data_o = 16'b1111_0000_1010_0101; 
	6'd44 : data_o = 16'b1011_1101_1110_0111; 
	6'd45 : data_o = 16'b1111_0000_1010_0101; 
	6'd46 : data_o = 16'b1011_1101_1110_0111; 
	6'd47 : data_o = 16'b1111_0000_1010_0101; 
	6'd48 : data_o = 16'b1011_1101_1110_0111; 
	6'd49 : data_o = 16'b1111_0000_1010_0101; 
	6'd50 : data_o = 16'b1011_1101_1110_0111; 
	6'd51 : data_o = 16'b1111_0000_1010_0101; 
	6'd52 : data_o = 16'b1011_1101_1110_0111; 
	6'd53 : data_o = 16'b1111_0000_1010_0101; 
	6'd54 : data_o = 16'b1011_1101_1110_0111; 
	6'd55 : data_o = 16'b1111_0000_1010_0101; 
	6'd56 : data_o = 16'b1011_1101_1110_0111; 
	6'd57 : data_o = 16'b1111_0000_1010_0101; 
	6'd58 : data_o = 16'b1011_1101_1110_0111; 
	6'd59 : data_o = 16'b1111_0000_1010_0101; 
	6'd60 : data_o = 16'b1011_1101_1110_0111; 
	6'd61 : data_o = 16'b1111_0000_1010_0101; 
	6'd62 : data_o = 16'h4567; 
	6'd63 : data_o = 16'h3210; 


	default: data_o = 0; // NOP 
  endcase
end





endmodule