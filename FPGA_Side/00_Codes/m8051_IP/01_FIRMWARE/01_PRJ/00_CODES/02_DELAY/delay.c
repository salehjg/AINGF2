#include<delay.h>
//===============================================================================
//===============================================================================
void delay_ms( unsigned int time )
{
    unsigned int i;
	  unsigned int j;
		char k=0;

		for( i=0; i<time; i++ )
		{
			for( j=0; j<575; j++ )
			{
				k++;
			}
		}
}

//===============================================================================