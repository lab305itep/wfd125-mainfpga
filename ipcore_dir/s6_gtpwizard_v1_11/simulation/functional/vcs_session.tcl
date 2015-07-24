################################################################################
##   ____  ____ 
##  /   /\/   / 
## /___/  \  /    Vendor: Xilinx 
## \   \   \/     Version : 1.11
##  \   \         Application : Spartan-6 FPGA GTP Transceiver Wizard
##  /   /         Filename : vcs_session.tcl
## /___/   /\      
## \   \  /  \ 
##  \___\/\___\ 
##
##
##
## Script VCS_SESSION.TCL
## Generated by Xilinx Spartan-6 FPGA GTP Transceiver Wizard
##
## 
## (c) Copyright 2009 - 2011 Xilinx, Inc. All rights reserved.
## 
## This file contains confidential and proprietary information
## of Xilinx, Inc. and is protected under U.S. and
## international copyright and other intellectual property
## laws.
## 
## DISCLAIMER
## This disclaimer is not a license and does not grant any
## rights to the materials distributed herewith. Except as
## otherwise provided in a valid license issued to you by
## Xilinx, and to the maximum extent permitted by applicable
## law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
## WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
## AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
## BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
## INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
## (2) Xilinx shall not be liable (whether in contract or tort,
## including negligence, or under any other theory of
## liability) for any loss or damage of any kind or nature
## related to, arising under or in connection with these
## materials, including for any direct, or any indirect,
## special, incidental, or consequential loss or damage
## (including loss of data, profits, goodwill, or any type of
## loss or damage suffered as a result of any action brought
## by a third party) even if such damage or loss was
## reasonably foreseeable or Xilinx had been advised of the
## possibility of the same.
##
## CRITICAL APPLICATIONS
## Xilinx products are not designed or intended to be fail-
## safe, or for use in any application requiring fail-safe
## performance, such as life-support or safety devices or
## systems, Class III medical devices, nuclear facilities,
## applications related to the deployment of airbags, or any
## other applications that could lead to death, personal
## injury, or severe property or environmental damage
## (individually and collectively, "Critical
## Applications"). Customer assumes the sole risk and
## liability of any use of Xilinx products in Critical
## Applications, subject only to applicable laws and
## regulations governing limitations on product liability.
## 
## THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
## PART OF THIS FILE AT ALL TIMES.


  gui_open_window Wave
  gui_sg_create s6_gtpwizard_v1_11_Group
  gui_list_add_group -id Wave.1 {s6_gtpwizard_v1_11_Group}

gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{FRAME_CHECK_MODULE}} -divider

gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile0_frame_check.begin_r}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile0_frame_check.track_data_r}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile0_frame_check.data_error_detected_r}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile0_frame_check.start_of_packet_detected_r}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile0_frame_check.RX_DATA}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile0_frame_check.ERROR_COUNT}
gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{FRAME_CHECK_MODULE}} -divider

gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile0_frame_check.begin_r}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile0_frame_check.track_data_r}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile0_frame_check.data_error_detected_r}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile0_frame_check.start_of_packet_detected_r}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile0_frame_check.RX_DATA}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile0_frame_check.ERROR_COUNT}
gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{FRAME_CHECK_MODULE}} -divider

gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile1_frame_check.begin_r}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile1_frame_check.track_data_r}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile1_frame_check.data_error_detected_r}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile1_frame_check.start_of_packet_detected_r}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile1_frame_check.RX_DATA}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile1_frame_check.ERROR_COUNT}
gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{FRAME_CHECK_MODULE}} -divider

gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile1_frame_check.begin_r}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile1_frame_check.track_data_r}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile1_frame_check.data_error_detected_r}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile1_frame_check.start_of_packet_detected_r}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile1_frame_check.RX_DATA}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.tile1_frame_check.ERROR_COUNT}
gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{TILE0_s6_gtpwizard_v1_11}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{Loopback and Powerdown Ports}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.LOOPBACK0_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.LOOPBACK1_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{PLL Ports}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.CLK00_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.CLK01_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.GTPRESET0_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.GTPRESET1_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.PLLLKDET0_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.PLLLKDET1_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RESETDONE0_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RESETDONE1_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{Receive Ports - 8b10b Decoder}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXCHARISCOMMA0_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXCHARISCOMMA1_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXCHARISK0_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXCHARISK1_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXDISPERR0_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXDISPERR1_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXNOTINTABLE0_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXNOTINTABLE1_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{Receive Ports - Comma Detection and Alignment}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXENMCOMMAALIGN0_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXENMCOMMAALIGN1_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXENPCOMMAALIGN0_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXENPCOMMAALIGN1_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{Receive Ports - RX Data Path interface}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXDATA0_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXDATA1_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXUSRCLK0_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXUSRCLK1_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXUSRCLK20_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXUSRCLK21_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXEQMIX0_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXEQMIX1_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXN0_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXN1_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXP0_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXP1_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{Receive Ports - RX Loss-of-sync State Machine}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXLOSSOFSYNC0_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.RXLOSSOFSYNC1_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{TX/RX Datapath Ports}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.GTPCLKOUT0_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.GTPCLKOUT1_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{Transmit Ports - 8b10b Encoder Control}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.TXCHARISK0_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.TXCHARISK1_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{Transmit Ports - TX Data Path interface}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.TXDATA0_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.TXDATA1_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.TXUSRCLK0_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.TXUSRCLK1_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.TXUSRCLK20_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.TXUSRCLK21_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{Transmit Ports - TX Driver and OOB signalling}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.TXN0_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.TXN1_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.TXP0_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile0_s6_gtpwizard_v1_11_i.TXP1_OUT}

gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{TILE1_s6_gtpwizard_v1_11}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{Loopback and Powerdown Ports}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.LOOPBACK0_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.LOOPBACK1_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{PLL Ports}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.CLK00_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.CLK01_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.GTPRESET0_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.GTPRESET1_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.PLLLKDET0_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.PLLLKDET1_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RESETDONE0_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RESETDONE1_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{Receive Ports - 8b10b Decoder}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXCHARISCOMMA0_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXCHARISCOMMA1_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXCHARISK0_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXCHARISK1_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXDISPERR0_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXDISPERR1_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXNOTINTABLE0_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXNOTINTABLE1_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{Receive Ports - Comma Detection and Alignment}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXENMCOMMAALIGN0_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXENMCOMMAALIGN1_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXENPCOMMAALIGN0_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXENPCOMMAALIGN1_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{Receive Ports - RX Data Path interface}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXDATA0_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXDATA1_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXUSRCLK0_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXUSRCLK1_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXUSRCLK20_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXUSRCLK21_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXEQMIX0_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXEQMIX1_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXN0_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXN1_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXP0_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXP1_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{Receive Ports - RX Loss-of-sync State Machine}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXLOSSOFSYNC0_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.RXLOSSOFSYNC1_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{TX/RX Datapath Ports}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.GTPCLKOUT0_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.GTPCLKOUT1_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{Transmit Ports - 8b10b Encoder Control}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.TXCHARISK0_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.TXCHARISK1_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{Transmit Ports - TX Data Path interface}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.TXDATA0_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.TXDATA1_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.TXUSRCLK0_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.TXUSRCLK1_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.TXUSRCLK20_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.TXUSRCLK21_IN}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {{Transmit Ports - TX Driver and OOB signalling}} -divider
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.TXN0_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.TXN1_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.TXP0_OUT}
  gui_sg_addsignal -group s6_gtpwizard_v1_11_Group {DEMO_TB.s6_gtpwizard_v1_11_top_i.s6_gtpwizard_v1_11_i.tile1_s6_gtpwizard_v1_11_i.TXP1_OUT}


  gui_zoom -window Wave.1 -full

