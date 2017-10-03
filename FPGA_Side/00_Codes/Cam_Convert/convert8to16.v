
//##################################################################################################
//
// Module for receiving 16 bit from 8 bit bus.
//
//##################################################################################################

module convert8to16 (d_i, vsync_i, href_i, pclk_i, rst_i, pixelReady_o, pixel_o);
                     
   input       [7:0] d_i;        // D0 - D7
   input       vsync_i;          // VSYNC
   input       href_i;           // HREF
   input       pclk_i;           // PCLK
   input       rst_i;            // 0 - Reset.
   output reg  pixelReady_o;     // Indicates that a pixel has been received.
   output reg  [15:0] pixel_o;   // RGB565 pixel.
   
   
	reg         odd = 0;
	reg         frameValid = 0;
	reg   [7:0]tmp;
always @(posedge pclk_i)
begin
  pixelReady_o <= 0;
  
  
  if (rst_i == 1) 
  begin
	 odd <= 0;
	 frameValid <= 0;
  end 
  else 
  begin
	 if (frameValid == 1 && vsync_i == 0 && href_i == 1) 
	 begin
		if (odd == 0) begin    
		   tmp[7:0] = d_i;
		end 
		else 
		begin
		   pixel_o[15:0] = {d_i,tmp};
		   pixelReady_o <= 1;   
		end
		odd <= ~odd;
	 // skip inital frame in case we started receiving in the middle of it
	 end 
	 else 
	 if(frameValid == 0 && vsync_i == 1) 
	 begin
		frameValid <= 1;            
	 end
  end
end

endmodule