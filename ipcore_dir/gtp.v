///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version : 1.11
//  \   \         Application : Spartan-6 FPGA GTP Transceiver Wizard
//  /   /         Filename : gtp.v
// /___/   /\      
// \   \  /  \ 
//  \___\/\___\
//
//
// Module gtp (a GTP Wrapper)
// Generated by Xilinx Spartan-6 FPGA GTP Transceiver Wizard
// 
// 
// (c) Copyright 2009 - 2011 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES. 



`timescale 1ns / 1ps


//***************************** Entity Declaration ****************************
(* CORE_GENERATION_INFO = "gtp,s6_gtpwizard_v1_11,{gtp0_protocol_file=Start_from_scratch,gtp1_protocol_file=Use_GTP0_settings}" *)
module gtp #
(
    // Simulation attributes
    parameter   WRAPPER_SIM_GTPRESET_SPEEDUP    = 0,    // Set to 1 to speed up sim reset
    parameter   WRAPPER_CLK25_DIVIDER_0         = 5,
    parameter   WRAPPER_CLK25_DIVIDER_1         = 5,
    parameter   WRAPPER_PLL_DIVSEL_FB_0         = 2,
    parameter   WRAPPER_PLL_DIVSEL_FB_1         = 2,
    parameter   WRAPPER_PLL_DIVSEL_REF_0        = 1,
    parameter   WRAPPER_PLL_DIVSEL_REF_1        = 1,
    
 
    parameter   WRAPPER_SIMULATION              = 0     // Set to 1 for simulation
)
(
    
    //_________________________________________________________________________
    //_________________________________________________________________________
    //TILE0  (X0_Y0)

 
    //---------------------- Loopback and Powerdown Ports ----------------------
    input   [2:0]   TILE0_LOOPBACK0_IN,
    input   [2:0]   TILE0_LOOPBACK1_IN,
    //------------------------------- PLL Ports --------------------------------
    input           TILE0_CLK00_IN,
    input           TILE0_CLK01_IN,
    input           TILE0_GTPRESET0_IN,
    input           TILE0_GTPRESET1_IN,
    output          TILE0_PLLLKDET0_OUT,
    output          TILE0_PLLLKDET1_OUT,
    output          TILE0_RESETDONE0_OUT,
    output          TILE0_RESETDONE1_OUT,
    //--------------------- Receive Ports - 8b10b Decoder ----------------------
    output  [3:0]   TILE0_RXDISPERR0_OUT,
    output  [3:0]   TILE0_RXDISPERR1_OUT,
    output  [3:0]   TILE0_RXNOTINTABLE0_OUT,
    output  [3:0]   TILE0_RXNOTINTABLE1_OUT,
    //------------- Receive Ports - Comma Detection and Alignment --------------
    input           TILE0_RXENMCOMMAALIGN0_IN,
    input           TILE0_RXENMCOMMAALIGN1_IN,
    input           TILE0_RXENPCOMMAALIGN0_IN,
    input           TILE0_RXENPCOMMAALIGN1_IN,
    //----------------- Receive Ports - RX Data Path interface -----------------
    output  [31:0]  TILE0_RXDATA0_OUT,
    output  [31:0]  TILE0_RXDATA1_OUT,
    input           TILE0_RXUSRCLK0_IN,
    input           TILE0_RXUSRCLK1_IN,
    input           TILE0_RXUSRCLK20_IN,
    input           TILE0_RXUSRCLK21_IN,
    //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    input   [1:0]   TILE0_RXEQMIX0_IN,
    input   [1:0]   TILE0_RXEQMIX1_IN,
    input           TILE0_RXN0_IN,
    input           TILE0_RXN1_IN,
    input           TILE0_RXP0_IN,
    input           TILE0_RXP1_IN,
    //--------- Receive Ports - RX Elastic Buffer and Phase Alignment ----------
    output  [2:0]   TILE0_RXSTATUS0_OUT,
    output  [2:0]   TILE0_RXSTATUS1_OUT,
    //------------- Receive Ports - RX Loss-of-sync State Machine --------------
    output  [1:0]   TILE0_RXLOSSOFSYNC0_OUT,
    output  [1:0]   TILE0_RXLOSSOFSYNC1_OUT,
    //------------ Receive Ports - RX Pipe Control for PCI Express -------------
    output          TILE0_PHYSTATUS0_OUT,
    output          TILE0_PHYSTATUS1_OUT,
    output          TILE0_RXVALID0_OUT,
    output          TILE0_RXVALID1_OUT,
    //-------------------------- TX/RX Datapath Ports --------------------------
    output  [1:0]   TILE0_GTPCLKOUT0_OUT,
    output  [1:0]   TILE0_GTPCLKOUT1_OUT,
    //----------------- Transmit Ports - 8b10b Encoder Control -----------------
    input   [3:0]   TILE0_TXCHARISK0_IN,
    input   [3:0]   TILE0_TXCHARISK1_IN,
    //---------------- Transmit Ports - TX Data Path interface -----------------
    input   [31:0]  TILE0_TXDATA0_IN,
    input   [31:0]  TILE0_TXDATA1_IN,
    input           TILE0_TXUSRCLK0_IN,
    input           TILE0_TXUSRCLK1_IN,
    input           TILE0_TXUSRCLK20_IN,
    input           TILE0_TXUSRCLK21_IN,
    //------------- Transmit Ports - TX Driver and OOB signalling --------------
    input   [3:0]   TILE0_TXDIFFCTRL0_IN,
    input   [3:0]   TILE0_TXDIFFCTRL1_IN,
    output          TILE0_TXN0_OUT,
    output          TILE0_TXN1_OUT,
    output          TILE0_TXP0_OUT,
    output          TILE0_TXP1_OUT,
    input   [2:0]   TILE0_TXPREEMPHASIS0_IN,
    input   [2:0]   TILE0_TXPREEMPHASIS1_IN,


    
    //_________________________________________________________________________
    //_________________________________________________________________________
    //TILE1  (X1_Y0)

 
    //---------------------- Loopback and Powerdown Ports ----------------------
    input   [2:0]   TILE1_LOOPBACK0_IN,
    input   [2:0]   TILE1_LOOPBACK1_IN,
    //------------------------------- PLL Ports --------------------------------
    input           TILE1_CLK00_IN,
    input           TILE1_CLK01_IN,
    input           TILE1_GTPRESET0_IN,
    input           TILE1_GTPRESET1_IN,
    output          TILE1_PLLLKDET0_OUT,
    output          TILE1_PLLLKDET1_OUT,
    output          TILE1_RESETDONE0_OUT,
    output          TILE1_RESETDONE1_OUT,
    //--------------------- Receive Ports - 8b10b Decoder ----------------------
    output  [3:0]   TILE1_RXDISPERR0_OUT,
    output  [3:0]   TILE1_RXDISPERR1_OUT,
    output  [3:0]   TILE1_RXNOTINTABLE0_OUT,
    output  [3:0]   TILE1_RXNOTINTABLE1_OUT,
    //------------- Receive Ports - Comma Detection and Alignment --------------
    input           TILE1_RXENMCOMMAALIGN0_IN,
    input           TILE1_RXENMCOMMAALIGN1_IN,
    input           TILE1_RXENPCOMMAALIGN0_IN,
    input           TILE1_RXENPCOMMAALIGN1_IN,
    //----------------- Receive Ports - RX Data Path interface -----------------
    output  [31:0]  TILE1_RXDATA0_OUT,
    output  [31:0]  TILE1_RXDATA1_OUT,
    input           TILE1_RXUSRCLK0_IN,
    input           TILE1_RXUSRCLK1_IN,
    input           TILE1_RXUSRCLK20_IN,
    input           TILE1_RXUSRCLK21_IN,
    //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    input   [1:0]   TILE1_RXEQMIX0_IN,
    input   [1:0]   TILE1_RXEQMIX1_IN,
    input           TILE1_RXN0_IN,
    input           TILE1_RXN1_IN,
    input           TILE1_RXP0_IN,
    input           TILE1_RXP1_IN,
    //--------- Receive Ports - RX Elastic Buffer and Phase Alignment ----------
    output  [2:0]   TILE1_RXSTATUS0_OUT,
    output  [2:0]   TILE1_RXSTATUS1_OUT,
    //------------- Receive Ports - RX Loss-of-sync State Machine --------------
    output  [1:0]   TILE1_RXLOSSOFSYNC0_OUT,
    output  [1:0]   TILE1_RXLOSSOFSYNC1_OUT,
    //------------ Receive Ports - RX Pipe Control for PCI Express -------------
    output          TILE1_PHYSTATUS0_OUT,
    output          TILE1_PHYSTATUS1_OUT,
    output          TILE1_RXVALID0_OUT,
    output          TILE1_RXVALID1_OUT,
    //-------------------------- TX/RX Datapath Ports --------------------------
    output  [1:0]   TILE1_GTPCLKOUT0_OUT,
    output  [1:0]   TILE1_GTPCLKOUT1_OUT,
    //----------------- Transmit Ports - 8b10b Encoder Control -----------------
    input   [3:0]   TILE1_TXCHARISK0_IN,
    input   [3:0]   TILE1_TXCHARISK1_IN,
    //---------------- Transmit Ports - TX Data Path interface -----------------
    input   [31:0]  TILE1_TXDATA0_IN,
    input   [31:0]  TILE1_TXDATA1_IN,
    input           TILE1_TXUSRCLK0_IN,
    input           TILE1_TXUSRCLK1_IN,
    input           TILE1_TXUSRCLK20_IN,
    input           TILE1_TXUSRCLK21_IN,
    //------------- Transmit Ports - TX Driver and OOB signalling --------------
    input   [3:0]   TILE1_TXDIFFCTRL0_IN,
    input   [3:0]   TILE1_TXDIFFCTRL1_IN,
    output          TILE1_TXN0_OUT,
    output          TILE1_TXN1_OUT,
    output          TILE1_TXP0_OUT,
    output          TILE1_TXP1_OUT,
    input   [2:0]   TILE1_TXPREEMPHASIS0_IN,
    input   [2:0]   TILE1_TXPREEMPHASIS1_IN


);


//***************************** Wire Declarations *****************************

    // ground and vcc signals
    wire            tied_to_ground_i;
    wire    [63:0]  tied_to_ground_vec_i;
    wire            tied_to_vcc_i;
    wire    [63:0]  tied_to_vcc_vec_i;
    wire            tile0_plllkdet0_i;
    wire            tile0_plllkdet1_i;
    wire            tile1_plllkdet0_i;
    wire            tile1_plllkdet1_i;

    reg            tile0_plllkdet0_i2;
    reg    [4:0]   count00;
    reg            start00;
    reg            tile0_plllkdet1_i2;
    reg    [4:0]   count10;
    reg            start10;
    reg            tile1_plllkdet0_i2;
    reg    [4:0]   count01;
    reg            start01;
    reg            tile1_plllkdet1_i2;
    reg    [4:0]   count11;
    reg            start11;
 
    
//********************************* Main Body of Code**************************

    assign tied_to_ground_i             = 1'b0;
    assign tied_to_ground_vec_i         = 64'h0000000000000000;
    assign tied_to_vcc_i                = 1'b1;
    assign tied_to_vcc_vec_i            = 64'hffffffffffffffff;

generate
if (WRAPPER_SIMULATION==1) 
begin : simulation

    assign TILE0_PLLLKDET0_OUT = tile0_plllkdet0_i2;

    always@(posedge TILE0_CLK00_IN or posedge TILE0_GTPRESET0_IN)   
    begin    
      if (TILE0_GTPRESET0_IN == 1'b1) begin
        count00 <= 5'b00000;
      end
      else begin
        if ((count00 == 5'b10100) | (tile0_plllkdet0_i == 1'b0)) begin
          count00 <= 5'b00000;
        end
        else begin
          count00 <= count00 + 5'b00001;
        end
      end
    end

    always@(posedge TILE0_CLK00_IN or negedge tile0_plllkdet0_i)
    begin
      if(tile0_plllkdet0_i == 1'b0) begin
        tile0_plllkdet0_i2 <= 1'b0;
      end
      else begin
        if((count00 == 5'b10100) & (tile0_plllkdet0_i == 1'b1)) begin 
          tile0_plllkdet0_i2 <= 1'b1;
        end
      end
    end
    assign TILE0_PLLLKDET1_OUT = tile0_plllkdet1_i2;

    always@(posedge TILE0_CLK01_IN or posedge TILE0_GTPRESET1_IN)   
    begin    
      if (TILE0_GTPRESET1_IN == 1'b1) begin
        count10 <= 5'b00000;
      end
      else begin
        if ((count10 == 5'b10100) | (tile0_plllkdet1_i == 1'b0)) begin
          count10 <= 5'b00000;
        end
        else begin
          count10 <= count10 + 5'b00001;
        end
      end
    end

    always@(posedge TILE0_CLK01_IN or negedge tile0_plllkdet1_i)
    begin
      if(tile0_plllkdet1_i == 1'b0) begin
        tile0_plllkdet1_i2 <= 1'b0;
      end
      else begin 
        if((count10 == 5'b10100) && (tile0_plllkdet1_i == 1'b1)) begin 
          tile0_plllkdet1_i2 <= 1'b1;
        end
      end
    end
    assign TILE1_PLLLKDET0_OUT = tile1_plllkdet0_i2;

    always@(posedge TILE1_CLK00_IN or posedge TILE1_GTPRESET0_IN)   
    begin    
      if (TILE1_GTPRESET0_IN == 1'b1) begin
        count01 <= 5'b00000;
      end
      else begin
        if ((count01 == 5'b10100) | (tile1_plllkdet0_i == 1'b0)) begin
          count01 <= 5'b00000;
        end
        else begin
          count01 <= count01 + 5'b00001;
        end
      end
    end

    always@(posedge TILE1_CLK00_IN or negedge tile1_plllkdet0_i)
    begin
      if(tile1_plllkdet0_i == 1'b0) begin
        tile1_plllkdet0_i2 <= 1'b0;
      end
      else begin
        if((count01 == 5'b10100) & (tile1_plllkdet0_i == 1'b1)) begin 
          tile1_plllkdet0_i2 <= 1'b1;
        end
      end
    end
    assign TILE1_PLLLKDET1_OUT = tile1_plllkdet1_i2;

    always@(posedge TILE1_CLK01_IN or posedge TILE1_GTPRESET1_IN)   
    begin    
      if (TILE1_GTPRESET1_IN == 1'b1) begin
        count11 <= 5'b00000;
      end
      else begin
        if ((count11 == 5'b10100) | (tile1_plllkdet1_i == 1'b0)) begin
          count11 <= 5'b00000;
        end
        else begin
          count11 <= count11 + 5'b00001;
        end
      end
    end

    always@(posedge TILE1_CLK01_IN or negedge tile1_plllkdet1_i)
    begin
      if(tile1_plllkdet1_i == 1'b0) begin
        tile1_plllkdet1_i2 <= 1'b0;
      end
      else begin 
        if((count11 == 5'b10100) && (tile1_plllkdet1_i == 1'b1)) begin 
          tile1_plllkdet1_i2 <= 1'b1;
        end
      end
    end
    


end //end WRAPPER_SIMULATION =1 generate section
else
begin: implementation

    assign TILE0_PLLLKDET0_OUT = tile0_plllkdet0_i;
    assign TILE0_PLLLKDET1_OUT = tile0_plllkdet1_i;
    assign TILE1_PLLLKDET0_OUT = tile1_plllkdet0_i;
    assign TILE1_PLLLKDET1_OUT = tile1_plllkdet1_i;
    

end
endgenerate //End generate for WRAPPER_SIMULATION

    //------------------------- Tile Instances  -------------------------------   



    //_________________________________________________________________________
    //_________________________________________________________________________
    //TILE0  (X0_Y0)

    gtp_tile #
    (
        // Simulation attributes
        .TILE_SIM_GTPRESET_SPEEDUP   (WRAPPER_SIM_GTPRESET_SPEEDUP),
        .TILE_CLK25_DIVIDER_0        (WRAPPER_CLK25_DIVIDER_0),
        .TILE_CLK25_DIVIDER_1        (WRAPPER_CLK25_DIVIDER_1),
        .TILE_PLL_DIVSEL_FB_0        (WRAPPER_PLL_DIVSEL_FB_0),
        .TILE_PLL_DIVSEL_FB_1        (WRAPPER_PLL_DIVSEL_FB_1),
        .TILE_PLL_DIVSEL_REF_0       (WRAPPER_PLL_DIVSEL_REF_0),
        .TILE_PLL_DIVSEL_REF_1       (WRAPPER_PLL_DIVSEL_REF_1),
  
        
        //
        .TILE_PLL_SOURCE_0               ("PLL0"),
        .TILE_PLL_SOURCE_1               ("PLL1")
    )
    tile0_gtp_i
    (
        //---------------------- Loopback and Powerdown Ports ----------------------
        .LOOPBACK0_IN                   (TILE0_LOOPBACK0_IN),
        .LOOPBACK1_IN                   (TILE0_LOOPBACK1_IN),
        //------------------------------- PLL Ports --------------------------------
        .CLK00_IN                       (TILE0_CLK00_IN),
        .CLK01_IN                       (TILE0_CLK01_IN),
        .GTPRESET0_IN                   (TILE0_GTPRESET0_IN),
        .GTPRESET1_IN                   (TILE0_GTPRESET1_IN),
        .PLLLKDET0_OUT                  (tile0_plllkdet0_i),
        .PLLLKDET1_OUT                  (tile0_plllkdet1_i),
        .RESETDONE0_OUT                 (TILE0_RESETDONE0_OUT),
        .RESETDONE1_OUT                 (TILE0_RESETDONE1_OUT),
        //--------------------- Receive Ports - 8b10b Decoder ----------------------
        .RXDISPERR0_OUT                 (TILE0_RXDISPERR0_OUT),
        .RXDISPERR1_OUT                 (TILE0_RXDISPERR1_OUT),
        .RXNOTINTABLE0_OUT              (TILE0_RXNOTINTABLE0_OUT),
        .RXNOTINTABLE1_OUT              (TILE0_RXNOTINTABLE1_OUT),
        //------------- Receive Ports - Comma Detection and Alignment --------------
        .RXENMCOMMAALIGN0_IN            (TILE0_RXENMCOMMAALIGN0_IN),
        .RXENMCOMMAALIGN1_IN            (TILE0_RXENMCOMMAALIGN1_IN),
        .RXENPCOMMAALIGN0_IN            (TILE0_RXENPCOMMAALIGN0_IN),
        .RXENPCOMMAALIGN1_IN            (TILE0_RXENPCOMMAALIGN1_IN),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .RXDATA0_OUT                    (TILE0_RXDATA0_OUT),
        .RXDATA1_OUT                    (TILE0_RXDATA1_OUT),
        .RXUSRCLK0_IN                   (TILE0_RXUSRCLK0_IN),
        .RXUSRCLK1_IN                   (TILE0_RXUSRCLK1_IN),
        .RXUSRCLK20_IN                  (TILE0_RXUSRCLK20_IN),
        .RXUSRCLK21_IN                  (TILE0_RXUSRCLK21_IN),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .RXEQMIX0_IN                    (TILE0_RXEQMIX0_IN),
        .RXEQMIX1_IN                    (TILE0_RXEQMIX1_IN),
        .RXN0_IN                        (TILE0_RXN0_IN),
        .RXN1_IN                        (TILE0_RXN1_IN),
        .RXP0_IN                        (TILE0_RXP0_IN),
        .RXP1_IN                        (TILE0_RXP1_IN),
        //--------- Receive Ports - RX Elastic Buffer and Phase Alignment ----------
        .RXSTATUS0_OUT                  (TILE0_RXSTATUS0_OUT),
        .RXSTATUS1_OUT                  (TILE0_RXSTATUS1_OUT),
        //------------- Receive Ports - RX Loss-of-sync State Machine --------------
        .RXLOSSOFSYNC0_OUT              (TILE0_RXLOSSOFSYNC0_OUT),
        .RXLOSSOFSYNC1_OUT              (TILE0_RXLOSSOFSYNC1_OUT),
        //------------ Receive Ports - RX Pipe Control for PCI Express -------------
        .PHYSTATUS0_OUT                 (TILE0_PHYSTATUS0_OUT),
        .PHYSTATUS1_OUT                 (TILE0_PHYSTATUS1_OUT),
        .RXVALID0_OUT                   (TILE0_RXVALID0_OUT),
        .RXVALID1_OUT                   (TILE0_RXVALID1_OUT),
        //-------------------------- TX/RX Datapath Ports --------------------------
        .GTPCLKOUT0_OUT                 (TILE0_GTPCLKOUT0_OUT),
        .GTPCLKOUT1_OUT                 (TILE0_GTPCLKOUT1_OUT),
        //----------------- Transmit Ports - 8b10b Encoder Control -----------------
        .TXCHARISK0_IN                  (TILE0_TXCHARISK0_IN),
        .TXCHARISK1_IN                  (TILE0_TXCHARISK1_IN),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .TXDATA0_IN                     (TILE0_TXDATA0_IN),
        .TXDATA1_IN                     (TILE0_TXDATA1_IN),
        .TXUSRCLK0_IN                   (TILE0_TXUSRCLK0_IN),
        .TXUSRCLK1_IN                   (TILE0_TXUSRCLK1_IN),
        .TXUSRCLK20_IN                  (TILE0_TXUSRCLK20_IN),
        .TXUSRCLK21_IN                  (TILE0_TXUSRCLK21_IN),
        //------------- Transmit Ports - TX Driver and OOB signalling --------------
        .TXDIFFCTRL0_IN                 (TILE0_TXDIFFCTRL0_IN),
        .TXDIFFCTRL1_IN                 (TILE0_TXDIFFCTRL1_IN),
        .TXN0_OUT                       (TILE0_TXN0_OUT),
        .TXN1_OUT                       (TILE0_TXN1_OUT),
        .TXP0_OUT                       (TILE0_TXP0_OUT),
        .TXP1_OUT                       (TILE0_TXP1_OUT),
        .TXPREEMPHASIS0_IN              (TILE0_TXPREEMPHASIS0_IN),
        .TXPREEMPHASIS1_IN              (TILE0_TXPREEMPHASIS1_IN)

    );



    //_________________________________________________________________________
    //_________________________________________________________________________
    //TILE1  (X1_Y0)

    gtp_tile #
    (
        // Simulation attributes
        .TILE_SIM_GTPRESET_SPEEDUP   (WRAPPER_SIM_GTPRESET_SPEEDUP),
        .TILE_CLK25_DIVIDER_0        (WRAPPER_CLK25_DIVIDER_0),
        .TILE_CLK25_DIVIDER_1        (WRAPPER_CLK25_DIVIDER_1),
        .TILE_PLL_DIVSEL_FB_0        (WRAPPER_PLL_DIVSEL_FB_0),
        .TILE_PLL_DIVSEL_FB_1        (WRAPPER_PLL_DIVSEL_FB_1),
        .TILE_PLL_DIVSEL_REF_0       (WRAPPER_PLL_DIVSEL_REF_0),
        .TILE_PLL_DIVSEL_REF_1       (WRAPPER_PLL_DIVSEL_REF_1),
  
        
        //
        .TILE_PLL_SOURCE_0               ("PLL0"),
        .TILE_PLL_SOURCE_1               ("PLL1")
    )
    tile1_gtp_i
    (
        //---------------------- Loopback and Powerdown Ports ----------------------
        .LOOPBACK0_IN                   (TILE1_LOOPBACK0_IN),
        .LOOPBACK1_IN                   (TILE1_LOOPBACK1_IN),
        //------------------------------- PLL Ports --------------------------------
        .CLK00_IN                       (TILE1_CLK00_IN),
        .CLK01_IN                       (TILE1_CLK01_IN),
        .GTPRESET0_IN                   (TILE1_GTPRESET0_IN),
        .GTPRESET1_IN                   (TILE1_GTPRESET1_IN),
        .PLLLKDET0_OUT                  (tile1_plllkdet0_i),
        .PLLLKDET1_OUT                  (tile1_plllkdet1_i),
        .RESETDONE0_OUT                 (TILE1_RESETDONE0_OUT),
        .RESETDONE1_OUT                 (TILE1_RESETDONE1_OUT),
        //--------------------- Receive Ports - 8b10b Decoder ----------------------
        .RXDISPERR0_OUT                 (TILE1_RXDISPERR0_OUT),
        .RXDISPERR1_OUT                 (TILE1_RXDISPERR1_OUT),
        .RXNOTINTABLE0_OUT              (TILE1_RXNOTINTABLE0_OUT),
        .RXNOTINTABLE1_OUT              (TILE1_RXNOTINTABLE1_OUT),
        //------------- Receive Ports - Comma Detection and Alignment --------------
        .RXENMCOMMAALIGN0_IN            (TILE1_RXENMCOMMAALIGN0_IN),
        .RXENMCOMMAALIGN1_IN            (TILE1_RXENMCOMMAALIGN1_IN),
        .RXENPCOMMAALIGN0_IN            (TILE1_RXENPCOMMAALIGN0_IN),
        .RXENPCOMMAALIGN1_IN            (TILE1_RXENPCOMMAALIGN1_IN),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .RXDATA0_OUT                    (TILE1_RXDATA0_OUT),
        .RXDATA1_OUT                    (TILE1_RXDATA1_OUT),
        .RXUSRCLK0_IN                   (TILE1_RXUSRCLK0_IN),
        .RXUSRCLK1_IN                   (TILE1_RXUSRCLK1_IN),
        .RXUSRCLK20_IN                  (TILE1_RXUSRCLK20_IN),
        .RXUSRCLK21_IN                  (TILE1_RXUSRCLK21_IN),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .RXEQMIX0_IN                    (TILE1_RXEQMIX0_IN),
        .RXEQMIX1_IN                    (TILE1_RXEQMIX1_IN),
        .RXN0_IN                        (TILE1_RXN0_IN),
        .RXN1_IN                        (TILE1_RXN1_IN),
        .RXP0_IN                        (TILE1_RXP0_IN),
        .RXP1_IN                        (TILE1_RXP1_IN),
        //--------- Receive Ports - RX Elastic Buffer and Phase Alignment ----------
        .RXSTATUS0_OUT                  (TILE1_RXSTATUS0_OUT),
        .RXSTATUS1_OUT                  (TILE1_RXSTATUS1_OUT),
        //------------- Receive Ports - RX Loss-of-sync State Machine --------------
        .RXLOSSOFSYNC0_OUT              (TILE1_RXLOSSOFSYNC0_OUT),
        .RXLOSSOFSYNC1_OUT              (TILE1_RXLOSSOFSYNC1_OUT),
        //------------ Receive Ports - RX Pipe Control for PCI Express -------------
        .PHYSTATUS0_OUT                 (TILE1_PHYSTATUS0_OUT),
        .PHYSTATUS1_OUT                 (TILE1_PHYSTATUS1_OUT),
        .RXVALID0_OUT                   (TILE1_RXVALID0_OUT),
        .RXVALID1_OUT                   (TILE1_RXVALID1_OUT),
        //-------------------------- TX/RX Datapath Ports --------------------------
        .GTPCLKOUT0_OUT                 (TILE1_GTPCLKOUT0_OUT),
        .GTPCLKOUT1_OUT                 (TILE1_GTPCLKOUT1_OUT),
        //----------------- Transmit Ports - 8b10b Encoder Control -----------------
        .TXCHARISK0_IN                  (TILE1_TXCHARISK0_IN),
        .TXCHARISK1_IN                  (TILE1_TXCHARISK1_IN),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .TXDATA0_IN                     (TILE1_TXDATA0_IN),
        .TXDATA1_IN                     (TILE1_TXDATA1_IN),
        .TXUSRCLK0_IN                   (TILE1_TXUSRCLK0_IN),
        .TXUSRCLK1_IN                   (TILE1_TXUSRCLK1_IN),
        .TXUSRCLK20_IN                  (TILE1_TXUSRCLK20_IN),
        .TXUSRCLK21_IN                  (TILE1_TXUSRCLK21_IN),
        //------------- Transmit Ports - TX Driver and OOB signalling --------------
        .TXDIFFCTRL0_IN                 (TILE1_TXDIFFCTRL0_IN),
        .TXDIFFCTRL1_IN                 (TILE1_TXDIFFCTRL1_IN),
        .TXN0_OUT                       (TILE1_TXN0_OUT),
        .TXN1_OUT                       (TILE1_TXN1_OUT),
        .TXP0_OUT                       (TILE1_TXP0_OUT),
        .TXP1_OUT                       (TILE1_TXP1_OUT),
        .TXPREEMPHASIS0_IN              (TILE1_TXPREEMPHASIS0_IN),
        .TXPREEMPHASIS1_IN              (TILE1_TXPREEMPHASIS1_IN)

    );

    
     
endmodule

