hex2dual.c ......... C source code for a program to convert a Intel hex file into a text file
                     containing binary entries, 8 bit per line.
keil.dua ........... Converted output file from KEIL simulator containing binary data, 8 bit 
                     per line.
keil.hex ........... Output file from KEIL simulator after executing the tc1.asm program.
                     (Caution: The KEIL software adds a line at the beginning of this file, which 
                     is not needed - it has to be deleted manually before conversion with hex2dual
                     to have identical files.)
mc8051_compile.do .. Compile script for modelsim.
mc8051_rom.dua ..... Textfile containing the ROM contents for VHDL code simulation.
mc8051_sim.do ...... Simulation script for modelsim.
mc8051_wave.do ..... Wave file for modelsim.
readme.txt ......... This file. Descriptions to ease verification.
regs.log ........... Ouput file after executing the write2gfile.do Tcl script in modelsim.
tc1.asm ............ 8051 assembler program.
tc1.dua ............ Converted 8051 program (can be copied to mc8051_rom.dua).
tc1.hex ............ 8051 program in Intel hex format.
write2file.do ...... Tcl script to write signal values to a text file.

