/*****************************************************************************/
/* Program : hex2dual                                                        */
/*                                                                           */
/* Author :  Roland Höller                                                   */
/* Date :    23.08.2001                                                      */
/* Purpose:  Convert Intel HEX files to binary notation text files.          */
/*****************************************************************************/

#include <sys/stat.h>    
#include <stdlib.h>    
#include <limits.h>    
#include <time.h>    
#include <sys/types.h> 
#include <stdio.h> 
#include <string.h> 
#include <unistd.h> 
#include <errno.h> 
 
#define LINE_LENGTH 128
#define FILE_EXT ".dua"

static char *cmnd;

FILE *fpr;
FILE *fpw; 

/*---------------------------------------------------------------------------*/
/*  Function : error_exit                                                    */
/*                                                                           */
/*  Purpose :  Print error message, close files, and exit                    */
/*             program with exit code EXIT_FAILURE.                          */
/*  Input :    Message text                                                  */
/*---------------------------------------------------------------------------*/
void error_exit (char *msg) 
{ 
  (void) fprintf (stderr, "%s: %s: %s\n", cmnd, msg, strerror(errno)); 
/*   (void) fclose(fpr); */
/*   (void) fclose(fpw); */
  (void) fflush(stdout);
  exit (EXIT_FAILURE); 
}

/*---------------------------------------------------------------------------*/
/*  Function : hex2bin                                                       */
/*                                                                           */
/*  Purpose :  Convert a hexadecimal character in its binary representation  */
/*  Input :    Hexadecimal character                                         */
/*---------------------------------------------------------------------------*/
char *hex2bin (char hexval)
{
  /* Default is new line */
  static char bnibble[5] = "----\0";
  /* Convert hexadecimal character */
  if (hexval == '0') (void)strcpy(bnibble,"0000");
  if (hexval == '1') (void)strcpy(bnibble,"0001");
  if (hexval == '2') (void)strcpy(bnibble,"0010");
  if (hexval == '3') (void)strcpy(bnibble,"0011");
  if (hexval == '4') (void)strcpy(bnibble,"0100");
  if (hexval == '5') (void)strcpy(bnibble,"0101");
  if (hexval == '6') (void)strcpy(bnibble,"0110");
  if (hexval == '7') (void)strcpy(bnibble,"0111");
  if (hexval == '8') (void)strcpy(bnibble,"1000");
  if (hexval == '9') (void)strcpy(bnibble,"1001");
  if ((hexval == 'A') || (hexval == 'a')) (void)strcpy(bnibble,"1010");
  if ((hexval == 'B') || (hexval == 'b')) (void)strcpy(bnibble,"1011");
  if ((hexval == 'C') || (hexval == 'c')) (void)strcpy(bnibble,"1100");
  if ((hexval == 'D') || (hexval == 'd')) (void)strcpy(bnibble,"1101");
  if ((hexval == 'E') || (hexval == 'e')) (void)strcpy(bnibble,"1110");
  if ((hexval == 'F') || (hexval == 'f')) (void)strcpy(bnibble,"1111");
  return (bnibble);
} 
 
/*---------------------------------------------------------------------------*/
/*  Function : hex2int                                                       */
/*                                                                           */
/*  Purpose :  Convert a hexadecimal character in its integer representation */
/*  Input :    Hexadecimal character                                         */
/*---------------------------------------------------------------------------*/
int hex2int (char hexval)
{
  /* Default */
  int inibble = 17;
  /* Convert hexadecimal character */
  if (hexval == '0') inibble = 0;
  if (hexval == '1') inibble = 1;
  if (hexval == '2') inibble = 2;
  if (hexval == '3') inibble = 3;
  if (hexval == '4') inibble = 4;
  if (hexval == '5') inibble = 5;
  if (hexval == '6') inibble = 6;
  if (hexval == '7') inibble = 7;
  if (hexval == '8') inibble = 8;
  if (hexval == '9') inibble = 9;
  if ((hexval == 'A') || (hexval == 'a')) inibble = 10;
  if ((hexval == 'B') || (hexval == 'b')) inibble = 11;
  if ((hexval == 'C') || (hexval == 'c')) inibble = 12;
  if ((hexval == 'D') || (hexval == 'd')) inibble = 13;
  if ((hexval == 'E') || (hexval == 'e')) inibble = 14;
  if ((hexval == 'F') || (hexval == 'f')) inibble = 15;
  return (inibble);
}  

/*****************************************************************************/
/*                                                                           */
/*                               MAIN PROGRAM                                */
/*                                                                           */
/*****************************************************************************/
int main (int argc, char **argv) 
{ 
  char line[LINE_LENGTH];
  char nline[LINE_LENGTH*4];
  char *fwname;
  int nmbr = 0;
  int n = 0;
 
  nline[0] = '\0';
  cmnd = argv[0];

  /* Check options and count them */
  if (argc != 2)
    error_exit ("Usage: hex2bin <filename>");

  /* Build file name for new file */ 
  fwname = (char*)malloc(sizeof(argv[2]) + 1);
  if (fwname == NULL)
    error_exit ("Not enough memory");
  fwname[0] = 0;
  (void)strcpy(fwname,argv[1]);
  (void)strcpy(fwname + strlen(fwname) - 4,FILE_EXT);
  fprintf(stderr,"fwname = %s\n",fwname);

  /* Open file */
  if ((fpr = fopen (argv[1],"r")) == NULL)
    error_exit ("Cannot open input file!");
  /* Create file */
  if ((fpw = fopen (fwname,"w")) == NULL)
    error_exit ("Cannot create output file!");

  /* Write converted file */
  while (fgets (line, sizeof(line), fpr) != NULL && strncmp(line,":00000001FF",11) != 0)
    {
      n = 1;
      nmbr = hex2int(line[n]);
      n++;
      nmbr = nmbr*16 + hex2int(line[n]);
      n++;
      n++;
      n++;
      for ( n = 5; n < nmbr+5; n++)
      {
        (void)strcpy(nline,hex2bin(line[2*n-1]));
        (void)strcpy(nline + 4,hex2bin(line[2*n]));
        (void)strcpy(nline + 8 ,"\n");
        fputs (nline,fpw);
        nline[0] = '\0';
      }
    }

  (void) fclose(fpr);
  (void) fclose(fpw);
  
  if (fflush(stdout) == EOF)
    error_exit ("Standard output flush error!");

  return (0);
} 
     
