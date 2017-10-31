onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /apb_slave_tb/pclk
add wave -noupdate /apb_slave_tb/addr
add wave -noupdate /apb_slave_tb/data
add wave -noupdate /apb_slave_tb/rData
add wave -noupdate /apb_slave_tb/idleCycles
add wave -noupdate /apb_slave_tb/rstN
add wave -noupdate /apb_slave_tb/apbBus/apbClk
add wave -noupdate /apb_slave_tb/apbBus/rst
add wave -noupdate -group task /apb_slave_tb/apbBus/PADDR
add wave -noupdate -group task /apb_slave_tb/apbBus/PWDATA
add wave -noupdate -group task /apb_slave_tb/apbBus/PRDATA
add wave -noupdate -group task /apb_slave_tb/apbBus/PSEL
add wave -noupdate -group task /apb_slave_tb/apbBus/PENABLE
add wave -noupdate -group task /apb_slave_tb/apbBus/PWRITE
add wave -noupdate -group task /apb_slave_tb/apbBus/PREADY
add wave -noupdate -expand -group bus /apb_slave_tb/DUT/clk
add wave -noupdate -expand -group bus /apb_slave_tb/DUT/rst_n
add wave -noupdate -expand -group bus /apb_slave_tb/DUT/mem
add wave -noupdate -expand -group bus /apb_slave_tb/DUT/apb_st
add wave -noupdate /apb_slave_tb/apbBus/apbClk
add wave -noupdate /apb_slave_tb/apbBus/readData/data
add wave -noupdate -expand -group apbtrans /apb_slave_tb/apbBus/apbtrans/PRDATA
add wave -noupdate -expand -group apbtrans /apb_slave_tb/apbBus/apbtrans/PENABLE
add wave -noupdate -expand -group apbtrans /apb_slave_tb/apbBus/apbtrans/PWRITE
add wave -noupdate -expand -group apbtrans /apb_slave_tb/apbBus/apbtrans/PSEL
add wave -noupdate -expand -group apbtrans /apb_slave_tb/apbBus/apbtrans/PADDR
add wave -noupdate -expand -group apbtrans /apb_slave_tb/apbBus/apbtrans/PWDATA
add wave -noupdate -expand -group apbslave /apb_slave_tb/apbBus/apbSlave/PRDATA
add wave -noupdate -expand -group apbslave /apb_slave_tb/apbBus/apbSlave/PENABLE
add wave -noupdate -expand -group apbslave /apb_slave_tb/apbBus/apbSlave/PWRITE
add wave -noupdate -expand -group apbslave /apb_slave_tb/apbBus/apbSlave/PSEL
add wave -noupdate -expand -group apbslave /apb_slave_tb/apbBus/apbSlave/PADDR
add wave -noupdate -expand -group apbslave /apb_slave_tb/apbBus/apbSlave/PWDATA
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1068310 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {1044200 ps} {1129840 ps}
