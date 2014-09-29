###############################################################################
## isim_wave.tcl
###############################################################################
onerror {resume}

wcfg new
divider add "FRAME CHECK MODULE tile0_frame_check0"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE0_frame_check0/begin_r
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE0_frame_check0/track_data_r
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE0_frame_check0/data_error_detected_r
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE0_frame_check0/start_of_packet_detected_r
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE0_frame_check0/RX_DATA
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE0_frame_check0/ERROR_COUNT
divider add "FRAME CHECK MODULE tile0_frame_check1"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE0_frame_check1/begin_r
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE0_frame_check1/track_data_r
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE0_frame_check1/data_error_detected_r
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE0_frame_check1/start_of_packet_detected_r
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE0_frame_check1/RX_DATA
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE0_frame_check1/ERROR_COUNT
divider add "FRAME CHECK MODULE tile0_frame_check0"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE1_frame_check0/begin_r
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE1_frame_check0/track_data_r
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE1_frame_check0/data_error_detected_r
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE1_frame_check0/start_of_packet_detected_r
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE1_frame_check0/RX_DATA
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE1_frame_check0/ERROR_COUNT
divider add "FRAME CHECK MODULE tile0_frame_check1"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE1_frame_check1/begin_r
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE1_frame_check1/track_data_r
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE1_frame_check1/data_error_detected_r
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE1_frame_check1/start_of_packet_detected_r
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE1_frame_check1/RX_DATA
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/TILE1_frame_check1/ERROR_COUNT
divider add "Loopback and Powerdown Ports"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/LOOPBACK0_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/LOOPBACK1_IN
divider add "PLL Ports"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/CLK00_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/CLK01_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/GTPRESET0_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/GTPRESET1_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/PLLLKDET0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/PLLLKDET1_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RESETDONE0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RESETDONE1_OUT
divider add "Receive Ports - 8b10b Decoder"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXCHARISCOMMA0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXCHARISCOMMA1_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXCHARISK0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXCHARISK1_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXDISPERR0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXDISPERR1_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXNOTINTABLE0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXNOTINTABLE1_OUT
divider add "Receive Ports - Comma Detection and Alignment"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXBYTEISALIGNED0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXBYTEISALIGNED1_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXCOMMADET0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXCOMMADET1_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXENMCOMMAALIGN0_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXENMCOMMAALIGN1_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXENPCOMMAALIGN0_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXENPCOMMAALIGN1_IN
divider add "Receive Ports - RX Data Path interface"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXDATA0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXDATA1_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXUSRCLK0_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXUSRCLK1_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXUSRCLK20_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXUSRCLK21_IN
divider add "Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXN0_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXN1_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXP0_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXP1_IN
divider add "Receive Ports - RX Loss-of-sync State Machine"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXLOSSOFSYNC0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/RXLOSSOFSYNC1_OUT
divider add "TX/RX Datapath Ports"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/GTPCLKOUT0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/GTPCLKOUT1_OUT
divider add "Transmit Ports - 8b10b Encoder Control"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/TXCHARISK0_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/TXCHARISK1_IN
divider add "Transmit Ports - TX Data Path interface"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/TXDATA0_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/TXDATA1_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/TXUSRCLK0_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/TXUSRCLK1_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/TXUSRCLK20_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/TXUSRCLK21_IN
divider add "Transmit Ports - TX Driver and OOB signalling"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/TXN0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/TXN1_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/TXP0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile0_s6_gtpwizard_v1_11_i/TXP1_OUT

divider add "Loopback and Powerdown Ports"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/LOOPBACK0_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/LOOPBACK1_IN
divider add "PLL Ports"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/CLK00_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/CLK01_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/GTPRESET0_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/GTPRESET1_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/PLLLKDET0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/PLLLKDET1_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RESETDONE0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RESETDONE1_OUT
divider add "Receive Ports - 8b10b Decoder"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXCHARISCOMMA0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXCHARISCOMMA1_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXCHARISK0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXCHARISK1_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXDISPERR0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXDISPERR1_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXNOTINTABLE0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXNOTINTABLE1_OUT
divider add "Receive Ports - Comma Detection and Alignment"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXBYTEISALIGNED0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXBYTEISALIGNED1_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXCOMMADET0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXCOMMADET1_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXENMCOMMAALIGN0_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXENMCOMMAALIGN1_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXENPCOMMAALIGN0_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXENPCOMMAALIGN1_IN
divider add "Receive Ports - RX Data Path interface"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXDATA0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXDATA1_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXUSRCLK0_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXUSRCLK1_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXUSRCLK20_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXUSRCLK21_IN
divider add "Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXN0_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXN1_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXP0_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXP1_IN
divider add "Receive Ports - RX Loss-of-sync State Machine"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXLOSSOFSYNC0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/RXLOSSOFSYNC1_OUT
divider add "TX/RX Datapath Ports"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/GTPCLKOUT0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/GTPCLKOUT1_OUT
divider add "Transmit Ports - 8b10b Encoder Control"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/TXCHARISK0_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/TXCHARISK1_IN
divider add "Transmit Ports - TX Data Path interface"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/TXDATA0_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/TXDATA1_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/TXUSRCLK0_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/TXUSRCLK1_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/TXUSRCLK20_IN
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/TXUSRCLK21_IN
divider add "Transmit Ports - TX Driver and OOB signalling"
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/TXN0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/TXN1_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/TXP0_OUT
wave add /DEMO_TB/s6_gtpwizard_v1_11_top_i/s6_gtpwizard_v1_11_i/tile1_s6_gtpwizard_v1_11_i/TXP1_OUT


run 50 us
quit




