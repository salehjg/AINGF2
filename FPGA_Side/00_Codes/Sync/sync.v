module sync
(
	input 		clk_fast_dest			,
	input 		clk_slow_src 			,
	input 		flag_in_active_high		,
	output 		flag_out_active_high		
);

reg tmp0;
reg tmp1;

always@(posedge clk_fast_dest)
begin
	tmp0 <= flag_in_active_high;
	tmp1 = tmp0;
end

assign flag_out_active_high = tmp0 && (!tmp1);

endmodule