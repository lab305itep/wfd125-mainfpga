###############################################################################
## wave_mti.do
###############################################################################
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {FRAME CHECK MODULE tile0_frame_check0 }
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/tile0_frame_check0/begin_r
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/tile0_frame_check0/track_data_r
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/tile0_frame_check0/data_error_detected_r
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/tile0_frame_check0/start_of_packet_detected_r
add wave -noupdate -format Logic -radix hexadecimal /DEMO_TB/gtp_top_i/tile0_frame_check0/RX_DATA
add wave -noupdate -format Logic -radix hexadecimal /DEMO_TB/gtp_top_i/tile0_frame_check0/ERROR_COUNT
add wave -noupdate -divider {FRAME CHECK MODULE tile0_frame_check1 }
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/tile0_frame_check1/begin_r
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/tile0_frame_check1/track_data_r
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/tile0_frame_check1/data_error_detected_r
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/tile0_frame_check1/start_of_packet_detected_r
add wave -noupdate -format Logic -radix hexadecimal /DEMO_TB/gtp_top_i/tile0_frame_check1/RX_DATA
add wave -noupdate -format Logic -radix hexadecimal /DEMO_TB/gtp_top_i/tile0_frame_check1/ERROR_COUNT
add wave -noupdate -divider {FRAME CHECK MODULE tile1_frame_check0 }
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/tile1_frame_check0/begin_r
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/tile1_frame_check0/track_data_r
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/tile1_frame_check0/data_error_detected_r
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/tile1_frame_check0/start_of_packet_detected_r
add wave -noupdate -format Logic -radix hexadecimal /DEMO_TB/gtp_top_i/tile1_frame_check0/RX_DATA
add wave -noupdate -format Logic -radix hexadecimal /DEMO_TB/gtp_top_i/tile1_frame_check0/ERROR_COUNT
add wave -noupdate -divider {FRAME CHECK MODULE tile1_frame_check1 }
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/tile1_frame_check1/begin_r
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/tile1_frame_check1/track_data_r
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/tile1_frame_check1/data_error_detected_r
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/tile1_frame_check1/start_of_packet_detected_r
add wave -noupdate -format Logic -radix hexadecimal /DEMO_TB/gtp_top_i/tile1_frame_check1/RX_DATA
add wave -noupdate -format Logic -radix hexadecimal /DEMO_TB/gtp_top_i/tile1_frame_check1/ERROR_COUNT
add wave -noupdate -divider {TILE0_gtp }
add wave -noupdate -divider {Loopback and Powerdown Ports }
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/LOOPBACK0_IN
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/LOOPBACK1_IN
add wave -noupdate -divider {PLL Ports }
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/CLK00_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/CLK01_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/GTPRESET0_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/GTPRESET1_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/PLLLKDET0_OUT
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/PLLLKDET1_OUT
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RESETDONE0_OUT
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RESETDONE1_OUT
add wave -noupdate -divider {Receive Ports - 8b10b Decoder }
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXDISPERR0_OUT
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXDISPERR1_OUT
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXNOTINTABLE0_OUT
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXNOTINTABLE1_OUT
add wave -noupdate -divider {Receive Ports - Comma Detection and Alignment }
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXENMCOMMAALIGN0_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXENMCOMMAALIGN1_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXENPCOMMAALIGN0_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXENPCOMMAALIGN1_IN
add wave -noupdate -divider {Receive Ports - RX Data Path interface }
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXDATA0_OUT
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXDATA1_OUT
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXUSRCLK0_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXUSRCLK1_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXUSRCLK20_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXUSRCLK21_IN
add wave -noupdate -divider {Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR }
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXEQMIX0_IN
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXEQMIX1_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXN0_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXN1_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXP0_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXP1_IN
add wave -noupdate -divider {Receive Ports - RX Elastic Buffer and Phase Alignment }
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXSTATUS0_OUT
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXSTATUS1_OUT
add wave -noupdate -divider {Receive Ports - RX Loss-of-sync State Machine }
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXLOSSOFSYNC0_OUT
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXLOSSOFSYNC1_OUT
add wave -noupdate -divider {Receive Ports - RX Pipe Control for PCI Express }
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/PHYSTATUS0_OUT
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/PHYSTATUS1_OUT
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXVALID0_OUT
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/RXVALID1_OUT
add wave -noupdate -divider {TX/RX Datapath Ports }
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/GTPCLKOUT0_OUT
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/GTPCLKOUT1_OUT
add wave -noupdate -divider {Transmit Ports - 8b10b Encoder Control }
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/TXCHARISK0_IN
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/TXCHARISK1_IN
add wave -noupdate -divider {Transmit Ports - TX Data Path interface }
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/TXDATA0_IN
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/TXDATA1_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/TXUSRCLK0_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/TXUSRCLK1_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/TXUSRCLK20_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/TXUSRCLK21_IN
add wave -noupdate -divider {Transmit Ports - TX Driver and OOB signalling }
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/TXDIFFCTRL0_IN
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/TXDIFFCTRL1_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/TXN0_OUT
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/TXN1_OUT
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/TXP0_OUT
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/TXP1_OUT
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/TXPREEMPHASIS0_IN
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile0_gtp_i/TXPREEMPHASIS1_IN

add wave -noupdate -divider {TILE1_gtp }
add wave -noupdate -divider {Loopback and Powerdown Ports }
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/LOOPBACK0_IN
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/LOOPBACK1_IN
add wave -noupdate -divider {PLL Ports }
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/CLK00_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/CLK01_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/GTPRESET0_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/GTPRESET1_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/PLLLKDET0_OUT
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/PLLLKDET1_OUT
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RESETDONE0_OUT
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RESETDONE1_OUT
add wave -noupdate -divider {Receive Ports - 8b10b Decoder }
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXDISPERR0_OUT
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXDISPERR1_OUT
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXNOTINTABLE0_OUT
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXNOTINTABLE1_OUT
add wave -noupdate -divider {Receive Ports - Comma Detection and Alignment }
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXENMCOMMAALIGN0_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXENMCOMMAALIGN1_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXENPCOMMAALIGN0_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXENPCOMMAALIGN1_IN
add wave -noupdate -divider {Receive Ports - RX Data Path interface }
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXDATA0_OUT
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXDATA1_OUT
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXUSRCLK0_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXUSRCLK1_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXUSRCLK20_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXUSRCLK21_IN
add wave -noupdate -divider {Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR }
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXEQMIX0_IN
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXEQMIX1_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXN0_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXN1_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXP0_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXP1_IN
add wave -noupdate -divider {Receive Ports - RX Elastic Buffer and Phase Alignment }
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXSTATUS0_OUT
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXSTATUS1_OUT
add wave -noupdate -divider {Receive Ports - RX Loss-of-sync State Machine }
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXLOSSOFSYNC0_OUT
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXLOSSOFSYNC1_OUT
add wave -noupdate -divider {Receive Ports - RX Pipe Control for PCI Express }
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/PHYSTATUS0_OUT
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/PHYSTATUS1_OUT
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXVALID0_OUT
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/RXVALID1_OUT
add wave -noupdate -divider {TX/RX Datapath Ports }
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/GTPCLKOUT0_OUT
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/GTPCLKOUT1_OUT
add wave -noupdate -divider {Transmit Ports - 8b10b Encoder Control }
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/TXCHARISK0_IN
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/TXCHARISK1_IN
add wave -noupdate -divider {Transmit Ports - TX Data Path interface }
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/TXDATA0_IN
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/TXDATA1_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/TXUSRCLK0_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/TXUSRCLK1_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/TXUSRCLK20_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/TXUSRCLK21_IN
add wave -noupdate -divider {Transmit Ports - TX Driver and OOB signalling }
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/TXDIFFCTRL0_IN
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/TXDIFFCTRL1_IN
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/TXN0_OUT
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/TXN1_OUT
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/TXP0_OUT
add wave -noupdate -format Logic /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/TXP1_OUT
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/TXPREEMPHASIS0_IN
add wave -noupdate -format Literal -radix hexadecimal /DEMO_TB/gtp_top_i/gtp_i/tile1_gtp_i/TXPREEMPHASIS1_IN

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 282
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
update
WaveRestoreZoom {0 ps} {5236 ps}
