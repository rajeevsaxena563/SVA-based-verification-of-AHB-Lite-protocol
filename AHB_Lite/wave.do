onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/AHBBUS/HCLK
add wave -noupdate /top/AHBBUS/HRESETn
add wave -noupdate /top/AHBBUS/HADDR
add wave -noupdate /top/AHBBUS/HWRITE
add wave -noupdate /top/AHBBUS/HBURST
add wave -noupdate /top/AHBBUS/HTRANS
add wave -noupdate /top/AHBBUS/HWDATA
add wave -noupdate /top/AHBBUS/HRDATA
add wave -noupdate /top/AHBBUS/HREADY
add wave -noupdate /top/AHBBUS/HRESP
add wave -noupdate /top/SlaveTop/HRDATA_BUS
add wave -noupdate /top/SlaveTop/HRESP_BUS
add wave -noupdate /top/SlaveTop/HREADY_BUS
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {1 us}
