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
add wave -noupdate -expand -group task /apb_slave_tb/apbBus/PADDR
add wave -noupdate -expand -group task /apb_slave_tb/apbBus/PWDATA
add wave -noupdate -expand -group task /apb_slave_tb/apbBus/PRDATA
add wave -noupdate -expand -group task /apb_slave_tb/apbBus/PSEL
add wave -noupdate -expand -group task /apb_slave_tb/apbBus/PENABLE
add wave -noupdate -expand -group task /apb_slave_tb/apbBus/PWRITE
add wave -noupdate -expand -group task /apb_slave_tb/apbBus/PREADY
add wave -noupdate -expand -group bus /apb_slave_tb/DUT/clk
add wave -noupdate -expand -group bus /apb_slave_tb/DUT/rst_n
add wave -noupdate -expand -group bus /apb_slave_tb/DUT/mem
add wave -noupdate -expand -group bus /apb_slave_tb/DUT/apb_st
add wave -noupdate /apb_slave_tb/apbBus/apbClk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {1075290 ps} 0}
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
WaveRestoreZoom {1031310 ps} {1121550 ps}
