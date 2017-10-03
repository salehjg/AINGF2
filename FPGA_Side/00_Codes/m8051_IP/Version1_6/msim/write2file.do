set filenr [open regs.log w]
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/s_r0_b0]
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/s_r1_b0]
for {set x 2} {$x<8} {incr x} {
  puts $filenr [examine /i_mc8051_top/i_mc8051_ram/gpram($x)]}
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/s_r0_b1]
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/s_r1_b1]
for {set x 10} {$x<16} {incr x} {
  puts $filenr [examine /i_mc8051_top/i_mc8051_ram/gpram($x)]}
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/s_r0_b2]
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/s_r1_b2]
for {set x 18} {$x<24} {incr x} {
  puts $filenr [examine /i_mc8051_top/i_mc8051_ram/gpram($x)]}
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/s_r0_b3]
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/s_r1_b3]
for {set x 26} {$x<32} {incr x} {
  puts $filenr [examine /i_mc8051_top/i_mc8051_ram/gpram($x)]}
for {set x 0} {$x<16} {incr x} {
  puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/gprbit($x)]}
for {set x 48} {$x<128} {incr x} {
  puts $filenr [examine /i_mc8051_top/i_mc8051_ram/gpram($x)]}
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/p0]
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/sp]
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/dpl]
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/dph]
for {set x 0} {$x<3} {incr x} {
  puts $filenr 00000000}
puts $filenr 0000[examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/pcon]
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/tcon(0)]
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/tmod(0)]
set murli ""
for {set x 0} {$x<8} {incr x} {
  set murli [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/all_tl0_i($x)]$murli}
puts $filenr $murli
set murli ""
for {set x 0} {$x<8} {incr x} {
  set murli [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/all_tl1_i($x)]$murli}
puts $filenr $murli
set murli ""
for {set x 0} {$x<8} {incr x} {
  set murli [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/all_th0_i($x)]$murli}
puts $filenr $murli
set murli ""
for {set x 0} {$x<8} {incr x} {
  set murli [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/all_th1_i($x)]$murli}
puts $filenr $murli
for {set x 0} {$x<2} {incr x} {
  puts $filenr 00000000}
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/p1]
for {set x 0} {$x<7} {incr x} {
  puts $filenr 00000000}
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/scon(0)]
set murli ""
for {set x 0} {$x<8} {incr x} {
  set murli [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/all_sbuf_i($x)]$murli}
puts $filenr $murli
for {set x 0} {$x<6} {incr x} {
  puts $filenr 00000000}
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/p2]
for {set x 0} {$x<7} {incr x} {
  puts $filenr 00000000}
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/ie]
for {set x 0} {$x<7} {incr x} {
  puts $filenr 00000000}
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/p3]
for {set x 0} {$x<7} {incr x} {
  puts $filenr 00000000}
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/ip]
for {set x 0} {$x<23} {incr x} {
  puts $filenr 00000000}
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/psw]
for {set x 0} {$x<15} {incr x} {
  puts $filenr 00000000}
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/acc]
for {set x 0} {$x<15} {incr x} {
  puts $filenr 00000000}
puts $filenr [examine /i_mc8051_top/i_mc8051_core/i_mc8051_control/i_control_mem/b]
for {set x 0} {$x<15} {incr x} {
  puts $filenr 00000000}
close $filenr
