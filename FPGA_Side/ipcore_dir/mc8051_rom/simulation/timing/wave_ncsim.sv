
 
 
 




window new WaveWindow  -name  "Waves for BMG Example Design"
waveform  using  "Waves for BMG Example Design"


      waveform add -signals /mc8051_rom_tb/status
      waveform add -signals /mc8051_rom_tb/mc8051_rom_synth_inst/bmg_port/CLKA
      waveform add -signals /mc8051_rom_tb/mc8051_rom_synth_inst/bmg_port/ADDRA
      waveform add -signals /mc8051_rom_tb/mc8051_rom_synth_inst/bmg_port/DOUTA
console submit -using simulator -wait no "run"
