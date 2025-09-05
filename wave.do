onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group WB_INTF /top/WB/WBCLK
add wave -noupdate -expand -group WB_INTF /top/WB/WB_ADDR
add wave -noupdate -expand -group WB_INTF /top/WB/WB_SEL
add wave -noupdate -expand -group WB_INTF /top/WB/WB_DAT_I
add wave -noupdate -expand -group WB_INTF /top/WB/WB_DAT_O
add wave -noupdate -expand -group WB_INTF /top/WB/WB_WE
add wave -noupdate -expand -group WB_INTF /top/WB/WB_STB
add wave -noupdate -expand -group WB_INTF /top/WB/WB_CYC
add wave -noupdate -expand -group WB_INTF /top/WB/WB_ACK
add wave -noupdate -expand -group WB_INTF /top/WB/WBRST
add wave -noupdate -expand -group Interrupt_intf /top/IRQ/INT_O
add wave -noupdate -expand -group TX_intf /top/TX/BAUD_O
add wave -noupdate -expand -group TX_intf /top/TX/STX_PAD_O
add wave -noupdate -group regs /top/DUT/regs/ier
add wave -noupdate -group regs /top/DUT/regs/iir
add wave -noupdate -group regs /top/DUT/regs/fcr
add wave -noupdate -group regs /top/DUT/regs/lcr
add wave -noupdate -group regs /top/DUT/regs/dl
add wave -noupdate -expand -group {RX Intf} /top/RX/WBCLK
add wave -noupdate -expand -group {RX Intf} /top/RX/SRX_PAD_I
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1396222 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 180
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1386104 ps}
