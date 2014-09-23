
###############################################################################
## wave_ncsim.sv
###############################################################################

  window new WaveWindow  -name  "Waves for Spartan-6 GTP Wizard Example Design"
  waveform  using  "Waves for Spartan-6 GTP Wizard Example Design"
  
  waveform  add  -label FRAME_CHECK_MODULE -comment tile0_frame_check0
  waveform  add  -signals  DEMO_TB.gtp_top_i+delimiter+tile0_frame_check0.begin_r
  waveform  add  -signals  DEMO_TB.gtp_top_i+delimiter+tile0_frame_check0.track_data_r
  waveform  add  -siganls  DEMO_TB.gtp_top_i+delimiter+tile0_frame_check0.data_error_detected_r
  wavefrom  add  -siganls  DEMO_TB.gtp_top_i+delimiter+tile0_frame_check0.start_of_packet_detected_r
  waveform  add  -signals  DEMO_TB.gtp_top_i+delimiter+tile0_frame_check0.RX_DATA
  waveform  add  -signals  DEMO_TB.gtp_top_i+delimiter+tile0_frame_check0.ERROR_COUNT
  waveform  add  -label FRAME_CHECK_MODULE -comment tile0_frame_check1
  waveform  add  -signals  DEMO_TB.gtp_top_i+delimiter+tile0_frame_check1.begin_r
  waveform  add  -signals  DEMO_TB.gtp_top_i+delimiter+tile0_frame_check1.track_data_r
  waveform  add  -siganls  DEMO_TB.gtp_top_i+delimiter+tile0_frame_check1.data_error_detected_r
  wavefrom  add  -siganls  DEMO_TB.gtp_top_i+delimiter+tile0_frame_check1.start_of_packet_detected_r
  waveform  add  -signals  DEMO_TB.gtp_top_i+delimiter+tile0_frame_check1.RX_DATA
  waveform  add  -signals  DEMO_TB.gtp_top_i+delimiter+tile0_frame_check1.ERROR_COUNT
  waveform  add  -label FRAME_CHECK_MODULE -comment tile1_frame_check0
  waveform  add  -signals  DEMO_TB.gtp_top_i+delimiter+tile1_frame_check0.begin_r
  waveform  add  -signals  DEMO_TB.gtp_top_i+delimiter+tile1_frame_check0.track_data_r
  waveform  add  -siganls  DEMO_TB.gtp_top_i+delimiter+tile1_frame_check0.data_error_detected_r
  wavefrom  add  -siganls  DEMO_TB.gtp_top_i+delimiter+tile1_frame_check0.start_of_packet_detected_r
  waveform  add  -signals  DEMO_TB.gtp_top_i+delimiter+tile1_frame_check0.RX_DATA
  waveform  add  -signals  DEMO_TB.gtp_top_i+delimiter+tile1_frame_check0.ERROR_COUNT
  waveform  add  -label FRAME_CHECK_MODULE -comment tile1_frame_check1
  waveform  add  -signals  DEMO_TB.gtp_top_i+delimiter+tile1_frame_check1.begin_r
  waveform  add  -signals  DEMO_TB.gtp_top_i+delimiter+tile1_frame_check1.track_data_r
  waveform  add  -siganls  DEMO_TB.gtp_top_i+delimiter+tile1_frame_check1.data_error_detected_r
  wavefrom  add  -siganls  DEMO_TB.gtp_top_i+delimiter+tile1_frame_check1.start_of_packet_detected_r
  waveform  add  -signals  DEMO_TB.gtp_top_i+delimiter+tile1_frame_check1.RX_DATA
  waveform  add  -signals  DEMO_TB.gtp_top_i+delimiter+tile1_frame_check1.ERROR_COUNT

  waveform  add  -label TILE0_gtp -comment TILE0_gtp
  waveform  add  -label Loopback_and_Powerdown_Ports  -comment  Loopback_and_Powerdown_Ports
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.LOOPBACK0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.LOOPBACK1_IN
  waveform  add  -label PLL_Ports  -comment  PLL_Ports
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.CLK00_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.CLK01_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.GTPRESET0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.GTPRESET1_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.PLLLKDET0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.PLLLKDET1_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RESETDONE0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RESETDONE1_OUT
  waveform  add  -label Receive_Ports_-_8b10b_Decoder  -comment  Receive_Ports_-_8b10b_Decoder
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXDISPERR0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXDISPERR1_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXNOTINTABLE0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXNOTINTABLE1_OUT
  waveform  add  -label Receive_Ports_-_Comma_Detection_and_Alignment  -comment  Receive_Ports_-_Comma_Detection_and_Alignment
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXENMCOMMAALIGN0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXENMCOMMAALIGN1_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXENPCOMMAALIGN0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXENPCOMMAALIGN1_IN
  waveform  add  -label Receive_Ports_-_RX_Data_Path_interface  -comment  Receive_Ports_-_RX_Data_Path_interface
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXDATA0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXDATA1_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXUSRCLK0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXUSRCLK1_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXUSRCLK20_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXUSRCLK21_IN
  waveform  add  -label Receive_Ports_-_RX_Driver,OOB_signalling,Coupling_and_Eq.,CDR  -comment  Receive_Ports_-_RX_Driver,OOB_signalling,Coupling_and_Eq.,CDR
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXEQMIX0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXEQMIX1_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXN0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXN1_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXP0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXP1_IN
  waveform  add  -label Receive_Ports_-_RX_Elastic_Buffer_and_Phase_Alignment  -comment  Receive_Ports_-_RX_Elastic_Buffer_and_Phase_Alignment
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXSTATUS0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXSTATUS1_OUT
  waveform  add  -label Receive_Ports_-_RX_Loss-of-sync_State_Machine  -comment  Receive_Ports_-_RX_Loss-of-sync_State_Machine
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXLOSSOFSYNC0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXLOSSOFSYNC1_OUT
  waveform  add  -label Receive_Ports_-_RX_Pipe_Control_for_PCI_Express  -comment  Receive_Ports_-_RX_Pipe_Control_for_PCI_Express
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.PHYSTATUS0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.PHYSTATUS1_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXVALID0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.RXVALID1_OUT
  waveform  add  -label TX/RX_Datapath_Ports  -comment  TX/RX_Datapath_Ports
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.GTPCLKOUT0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.GTPCLKOUT1_OUT
  waveform  add  -label Transmit_Ports_-_8b10b_Encoder_Control  -comment  Transmit_Ports_-_8b10b_Encoder_Control
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.TXCHARISK0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.TXCHARISK1_IN
  waveform  add  -label Transmit_Ports_-_TX_Data_Path_interface  -comment  Transmit_Ports_-_TX_Data_Path_interface
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.TXDATA0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.TXDATA1_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.TXUSRCLK0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.TXUSRCLK1_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.TXUSRCLK20_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.TXUSRCLK21_IN
  waveform  add  -label Transmit_Ports_-_TX_Driver_and_OOB_signalling  -comment  Transmit_Ports_-_TX_Driver_and_OOB_signalling
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.TXDIFFCTRL0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.TXDIFFCTRL1_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.TXN0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.TXN1_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.TXP0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.TXP1_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.TXPREEMPHASIS0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile0_gtp_i.TXPREEMPHASIS1_IN

  waveform  add  -label TILE1_gtp -comment TILE1_gtp
  waveform  add  -label Loopback_and_Powerdown_Ports  -comment  Loopback_and_Powerdown_Ports
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.LOOPBACK0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.LOOPBACK1_IN
  waveform  add  -label PLL_Ports  -comment  PLL_Ports
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.CLK00_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.CLK01_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.GTPRESET0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.GTPRESET1_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.PLLLKDET0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.PLLLKDET1_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RESETDONE0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RESETDONE1_OUT
  waveform  add  -label Receive_Ports_-_8b10b_Decoder  -comment  Receive_Ports_-_8b10b_Decoder
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXDISPERR0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXDISPERR1_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXNOTINTABLE0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXNOTINTABLE1_OUT
  waveform  add  -label Receive_Ports_-_Comma_Detection_and_Alignment  -comment  Receive_Ports_-_Comma_Detection_and_Alignment
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXENMCOMMAALIGN0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXENMCOMMAALIGN1_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXENPCOMMAALIGN0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXENPCOMMAALIGN1_IN
  waveform  add  -label Receive_Ports_-_RX_Data_Path_interface  -comment  Receive_Ports_-_RX_Data_Path_interface
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXDATA0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXDATA1_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXUSRCLK0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXUSRCLK1_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXUSRCLK20_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXUSRCLK21_IN
  waveform  add  -label Receive_Ports_-_RX_Driver,OOB_signalling,Coupling_and_Eq.,CDR  -comment  Receive_Ports_-_RX_Driver,OOB_signalling,Coupling_and_Eq.,CDR
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXEQMIX0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXEQMIX1_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXN0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXN1_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXP0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXP1_IN
  waveform  add  -label Receive_Ports_-_RX_Elastic_Buffer_and_Phase_Alignment  -comment  Receive_Ports_-_RX_Elastic_Buffer_and_Phase_Alignment
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXSTATUS0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXSTATUS1_OUT
  waveform  add  -label Receive_Ports_-_RX_Loss-of-sync_State_Machine  -comment  Receive_Ports_-_RX_Loss-of-sync_State_Machine
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXLOSSOFSYNC0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXLOSSOFSYNC1_OUT
  waveform  add  -label Receive_Ports_-_RX_Pipe_Control_for_PCI_Express  -comment  Receive_Ports_-_RX_Pipe_Control_for_PCI_Express
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.PHYSTATUS0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.PHYSTATUS1_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXVALID0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.RXVALID1_OUT
  waveform  add  -label TX/RX_Datapath_Ports  -comment  TX/RX_Datapath_Ports
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.GTPCLKOUT0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.GTPCLKOUT1_OUT
  waveform  add  -label Transmit_Ports_-_8b10b_Encoder_Control  -comment  Transmit_Ports_-_8b10b_Encoder_Control
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.TXCHARISK0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.TXCHARISK1_IN
  waveform  add  -label Transmit_Ports_-_TX_Data_Path_interface  -comment  Transmit_Ports_-_TX_Data_Path_interface
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.TXDATA0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.TXDATA1_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.TXUSRCLK0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.TXUSRCLK1_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.TXUSRCLK20_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.TXUSRCLK21_IN
  waveform  add  -label Transmit_Ports_-_TX_Driver_and_OOB_signalling  -comment  Transmit_Ports_-_TX_Driver_and_OOB_signalling
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.TXDIFFCTRL0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.TXDIFFCTRL1_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.TXN0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.TXN1_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.TXP0_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.TXP1_OUT
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.TXPREEMPHASIS0_IN
  waveform  add  -signals  DEMO_TB.gtp_top_i.gtp_i.tile1_gtp_i.TXPREEMPHASIS1_IN

  console submit -using simulator -wait no "run 50 us"

