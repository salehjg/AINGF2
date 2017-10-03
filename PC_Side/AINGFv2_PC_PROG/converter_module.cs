private void convert_yuv422_rgb888(byte []rawStreamingFrame )
{
	
    int height = 480;
    int width = 640;
	    
	// Create a QByteArray to store the RGB Data
    int []redContainer 		= new int[height*width];
    int []greenContainer	= new int[height*width];
    int []blueContainer		= new int[height*width];
	
	
    int cnt = -1;

    for ( int i = 0 ; i <= rawStreamingFrame.length-4 ; i += 4 ) {

       // Extract yuv components

       int u  = (int)rawStreamingFrame[i];

       int y1 = (int)rawStreamingFrame[i+1];

       int v  = (int)rawStreamingFrame[i+2];

       int y2 = (int)rawStreamingFrame[i+3];

       // Define the RGB

       int r1 = 0 , g1 = 0 , b1 = 0;

       int r2 = 0 , g2 = 0 , b2 = 0;

       // u and v are +-0.5

       u -= 128;

       v -= 128;

       // Conversion

       r1 = y1 + 1.403*v;

       g1 = y1 - 0.344*u - 0.714*v;

       b1 = y1 + 1.770*u;

       r2 = y2 + 1.403*v;

       g2 = y2 - 0.344*u - 0.714*v;

       b2 = y2 + 1.770*u;

       // Increment by one so we can insert

       cnt+=1;

       // Append to the array holding our RGB Values

       redContainer[cnt] = r1;

       greenContainer[cnt] = g1;

       blueContainer[cnt] = b1;

       // Increment again since we have 2 pixels per uv value

       cnt+=1;

       // Store the second pixel

       redContainer[cnt] = r2;

       greenContainer[cnt] = g2;

       blueContainer[cnt] = b2;

    }
	
	
}