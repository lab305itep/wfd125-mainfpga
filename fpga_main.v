`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ITEP
// Engineer: SvirLex
// 
// Create Date:    19:11:52 09/15/2014 
// Design Name:    fpga_main
// Module Name:    fpga_main 
// Project Name:   wfd125
// Target Devices: xc6SLX45T-2-FGG484
//
// Revision 0.01 - File Created
// Additional Comments: 
//
//
//
//////////////////////////////////////////////////////////////////////////////////



module fpga_main(

	// VME interface
	// Address
    inout [31:0] XA, 
	// Address modifier
    input [5:0] XAM,
	// Geographical addr (useless as now)
    input [5:0] XGA,
	// Data
    inout [31:0] XD, 
	// Strobes
    input XAS,
    input [1:0] XDS,
    input XWRITE,
    input XDTACK,
    input XDTACKOE,
    output ADIR,
    output DDIR,
	// Errors/resets
    input XRESET,
    input XBERR,
    input XRETRY,
    input XRESP,
	// Interrupt handling
    input XIACK,
    input XIACKIN,
    output IACKPASS,
	// Interrupts
    output [5:0] XIRQ,
	// Interconnection to CPLD
    input [7:0] C2X,
	// Parallel lines to other FPGAs
	// 0-1, 14-15: "good pairs"
	// 10-11, 12-13: "satisfactory pair"
    inout [15:0] ICX,
	// Fast serial connections and CLK
	// Main Clock
    input [1:0] RCLK,
	// Recievers
    input [1:0] RX0,
    input [1:0] RX1,
    input [1:0] RX2,
    input [1:0] RX3,
	// Transmitters
    output [1:0] TX0,
    output [1:0] TX1,
    output [1:0] TX2,
    output [1:0] TX3,
	// Serial interfaces
	// Clock Buffer I2C
    output CBUFSCL,
    inout CBUFSDA,
	// DAC SPI
    output BDACC,
    output BDACD,
    output BDACCS,
	// Clock selection
    output ECLKSEL,
    output OCLKSEL,
    output CLKENFP,
    output CLKENBP,
    output CLKENBFP,
	// Front Panel
	// Indication LEDS (LED0 - Yellow)
    output [3:0] LED,
	// Front panel pairs (even-odd)
    input [5:0] FP,
	// Back panel
	// 0-2, 1-3, 7-9 : "next-by-next" BP pair, X-pair, board pair
	// 6-5 : "real" BP pair, X-pair, but NOT board pair
    input [9:0] USRDEF,
	// FLASH/Config interface
    input INIT,
    input [1:0] M,
    input DOUT,
    input FLASHCS,
    input FLASHCLK,
    input [3:0] FDAT,
	// Ethernet PHY interface
	// Input
    input PHYRXCLK,
    input PHYRXDVLD,
    input [3:0] PHYRXD,
	// Output
    output PHYTXCLK,
    output PHYTXENB,
    output [3:0] PHYTXD,
	// Slow interface
    inout PHYMDIO,
    output PHYMDC,
    output PHYRST,
    input PHYINT,
	// SDRAM interface
	// Address
    output [14:0] MEMA,
	// Bank addr
    output [2:0] MEMBA,
	// Data
    inout [15:0] MEMD,
	// Other single ended
    output MEMRST,
    output MEMCKE,
    output MEMWE,
    output MEMODT,
    output MEMRAS,
    output MEMCAS,
    output MEMUDM,
    output MEMLDM,
	// Pairs
    output [1:0] MEMCK,
    output [1:0] MEMUDQS,
    output [1:0] MEMLDQS,
	// Impedance matching
    input MEMZIO,
    input MEMRZQ,
	// Test points
    output [5:1] TP
    );

// Current number of active registers
    localparam NREGS = 16;

	wire CLK;
	wire tile0_gtp0_refclk_i;
	wire tile0_resetdone0_i;
	wire [1:0] GTPCLKOUT;
	wire CLKBUFIO;
	// module addressed bits
	reg ADS = 0;
	reg [26:0] CNT = 0;
	reg triga = 0;
	reg trigb = 0;
	reg trigc = 0;
	
	assign 		 VME_GA_i = 5'b11110;
	wire         VME_BERR_o;

	wire         VME_DTACK_n_o;
	wire         VME_RETRY_n_o;
	wire         VME_LWORD_n_i;
	wire         VME_LWORD_n_o;
	wire [31:1]  VME_ADDR_i;
	wire [31:1]  VME_ADDR_o;
	wire [31:0]  VME_DATA_i;
	wire [31:0]  VME_DATA_o;

	wire         VME_DTACK_OE_o;
	wire         VME_DATA_DIR_o;
	wire         VME_DATA_OE_N_o;
	wire         VME_ADDR_DIR_o;
	wire         VME_ADDR_OE_N_o;
	wire         VME_RETRY_OE_o;
	wire [7:1]   VME_IRQ_o;

	assign LED[0] = CNT[26];
	assign IACKPASS = 1'bz;
	assign MEMRST = 1'bz;
	assign MEMCKE = 1'bz;
	assign MEMWE  = 1'bz;
	assign MEMODT = 1'bz;
	assign MEMRAS = 1'bz;
	assign MEMCAS = 1'bz;
	assign MEMUDM = 1'bz;
	assign MEMLDM = 1'bz;
	assign MEMCK =  2'bzz;
	assign MEMUDQS =  2'bzz;
	assign MEMLDQS =  2'bzz;
	assign MEMA =  14'hzzzz;
	assign MEMD =  16'hzzzz;
	assign MEMBA =  3'bzzz;
   assign PHYTXCLK = 1'bz;
   assign PHYTXENB = 1'bz;
   assign PHYTXD  = 4'hz;
   assign PHYMDIO = 1'bz;
   assign PHYMDC  = 1'bz;
   assign PHYRST  = 1'bz;
   assign CBUFSCL = 1'bz;
   assign CBUFSDA = 1'bz;
   assign BDACC = 1'bz;
   assign BDACD = 1'bz;
   assign BDACCS = 1'bz;
   assign ECLKSEL = 1'bz;
   assign OCLKSEL = 1'bz;
   assign CLKENFP = 1'bz;
   assign CLKENBP = 1'bz;
   assign CLKENBFP = 1'bz;

	assign TP[5:1] = {ADIR, DDIR, XAS, XDS};

    //--------------------------- The GTP Wrapper -----------------------------


    gtp #
    (
        .WRAPPER_SIM_GTPRESET_SPEEDUP   (0),      // Set this to 1 for simulation
        .WRAPPER_SIMULATION             (0)       // Set this to 1 for simulation
    )
    gtp_i
    (
    
        //_____________________________________________________________________
        //_____________________________________________________________________
        //TILE0  (X0_Y0)
 
        //---------------------- Loopback and Powerdown Ports ----------------------
        .TILE0_LOOPBACK0_IN             (1'b0),
        .TILE0_LOOPBACK1_IN             (1'b0),
        //------------------------------- PLL Ports --------------------------------
        .TILE0_CLK00_IN                 (tile0_gtp0_refclk_i),
        .TILE0_CLK01_IN                 (tile0_gtp0_refclk_i),
        .TILE0_GTPRESET0_IN             (),
        .TILE0_GTPRESET1_IN             (),
        .TILE0_PLLLKDET0_OUT            (),
        .TILE0_PLLLKDET1_OUT            (),
        .TILE0_RESETDONE0_OUT           (tile0_resetdone0_i),
        .TILE0_RESETDONE1_OUT           (),
        //--------------------- Receive Ports - 8b10b Decoder ----------------------
        .TILE0_RXDISPERR0_OUT           (),
        .TILE0_RXDISPERR1_OUT           (),
        .TILE0_RXNOTINTABLE0_OUT        (),
        .TILE0_RXNOTINTABLE1_OUT        (),
        //------------- Receive Ports - Comma Detection and Alignment --------------
        .TILE0_RXENMCOMMAALIGN0_IN      (),
        .TILE0_RXENMCOMMAALIGN1_IN      (),
        .TILE0_RXENPCOMMAALIGN0_IN      (),
        .TILE0_RXENPCOMMAALIGN1_IN      (),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .TILE0_RXDATA0_OUT              (),
        .TILE0_RXDATA1_OUT              (),
        .TILE0_RXUSRCLK0_IN             (),
        .TILE0_RXUSRCLK1_IN             (),
        .TILE0_RXUSRCLK20_IN            (),
        .TILE0_RXUSRCLK21_IN            (),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .TILE0_RXEQMIX0_IN              (),
        .TILE0_RXEQMIX1_IN              (),
        .TILE0_RXN0_IN                  (RX0[1]),
        .TILE0_RXN1_IN                  (RX1[1]),
        .TILE0_RXP0_IN                  (RX0[0]),
        .TILE0_RXP1_IN                  (RX1[0]),
        //--------- Receive Ports - RX Elastic Buffer and Phase Alignment ----------
        .TILE0_RXSTATUS0_OUT            (),
        .TILE0_RXSTATUS1_OUT            (),
        //------------- Receive Ports - RX Loss-of-sync State Machine --------------
        .TILE0_RXLOSSOFSYNC0_OUT        (),
        .TILE0_RXLOSSOFSYNC1_OUT        (),
        //------------ Receive Ports - RX Pipe Control for PCI Express -------------
        .TILE0_PHYSTATUS0_OUT           (),
        .TILE0_PHYSTATUS1_OUT           (),
        .TILE0_RXVALID0_OUT             (),
        .TILE0_RXVALID1_OUT             (),
        //-------------------------- TX/RX Datapath Ports --------------------------
        .TILE0_GTPCLKOUT0_OUT           (GTPCLKOUT),
        .TILE0_GTPCLKOUT1_OUT           (),
        //----------------- Transmit Ports - 8b10b Encoder Control -----------------
        .TILE0_TXCHARISK0_IN            (),
        .TILE0_TXCHARISK1_IN            (),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .TILE0_TXDATA0_IN               (),
        .TILE0_TXDATA1_IN               (),
        .TILE0_TXUSRCLK0_IN             (),
        .TILE0_TXUSRCLK1_IN             (),
        .TILE0_TXUSRCLK20_IN            (),
        .TILE0_TXUSRCLK21_IN            (),
        //------------- Transmit Ports - TX Driver and OOB signalling --------------
        .TILE0_TXDIFFCTRL0_IN           (),
        .TILE0_TXDIFFCTRL1_IN           (),
        .TILE0_TXN0_OUT                 (TX0[1]),
        .TILE0_TXN1_OUT                 (TX1[1]),
        .TILE0_TXP0_OUT                 (TX0[0]),
        .TILE0_TXP1_OUT                 (TX1[0]),
        .TILE0_TXPREEMPHASIS0_IN        (),
        .TILE0_TXPREEMPHASIS1_IN        (),


    
        //_____________________________________________________________________
        //_____________________________________________________________________
        //TILE1  (X1_Y0)
 
        //---------------------- Loopback and Powerdown Ports ----------------------
        .TILE1_LOOPBACK0_IN             (),
        .TILE1_LOOPBACK1_IN             (),
        //------------------------------- PLL Ports --------------------------------
        .TILE1_CLK00_IN                 (tile0_gtp0_refclk_i),
        .TILE1_CLK01_IN                 (tile0_gtp0_refclk_i),
        .TILE1_GTPRESET0_IN             (),
        .TILE1_GTPRESET1_IN             (),
        .TILE1_PLLLKDET0_OUT            (),
        .TILE1_PLLLKDET1_OUT            (),
        .TILE1_RESETDONE0_OUT           (),
        .TILE1_RESETDONE1_OUT           (),
        //--------------------- Receive Ports - 8b10b Decoder ----------------------
        .TILE1_RXDISPERR0_OUT           (),
        .TILE1_RXDISPERR1_OUT           (),
        .TILE1_RXNOTINTABLE0_OUT        (),
        .TILE1_RXNOTINTABLE1_OUT        (),
        //------------- Receive Ports - Comma Detection and Alignment --------------
        .TILE1_RXENMCOMMAALIGN0_IN      (),
        .TILE1_RXENMCOMMAALIGN1_IN      (),
        .TILE1_RXENPCOMMAALIGN0_IN      (),
        .TILE1_RXENPCOMMAALIGN1_IN      (),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .TILE1_RXDATA0_OUT              (),
        .TILE1_RXDATA1_OUT              (),
        .TILE1_RXUSRCLK0_IN             (),
        .TILE1_RXUSRCLK1_IN             (),
        .TILE1_RXUSRCLK20_IN            (),
        .TILE1_RXUSRCLK21_IN            (),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .TILE1_RXEQMIX0_IN              (),
        .TILE1_RXEQMIX1_IN              (),
        .TILE1_RXN0_IN                  (RX2[1]),
        .TILE1_RXN1_IN                  (RX3[1]),
        .TILE1_RXP0_IN                  (RX2[0]),
        .TILE1_RXP1_IN                  (RX3[0]),
        //--------- Receive Ports - RX Elastic Buffer and Phase Alignment ----------
        .TILE1_RXSTATUS0_OUT            (),
        .TILE1_RXSTATUS1_OUT            (),
        //------------- Receive Ports - RX Loss-of-sync State Machine --------------
        .TILE1_RXLOSSOFSYNC0_OUT        (),
        .TILE1_RXLOSSOFSYNC1_OUT        (),
        //------------ Receive Ports - RX Pipe Control for PCI Express -------------
        .TILE1_PHYSTATUS0_OUT           (),
        .TILE1_PHYSTATUS1_OUT           (),
        .TILE1_RXVALID0_OUT             (),
        .TILE1_RXVALID1_OUT             (),
        //-------------------------- TX/RX Datapath Ports --------------------------
        .TILE1_GTPCLKOUT0_OUT           (),
        .TILE1_GTPCLKOUT1_OUT           (),
        //----------------- Transmit Ports - 8b10b Encoder Control -----------------
        .TILE1_TXCHARISK0_IN            (),
        .TILE1_TXCHARISK1_IN            (),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .TILE1_TXDATA0_IN               (),
        .TILE1_TXDATA1_IN               (),
        .TILE1_TXUSRCLK0_IN             (),
        .TILE1_TXUSRCLK1_IN             (),
        .TILE1_TXUSRCLK20_IN            (),
        .TILE1_TXUSRCLK21_IN            (),
        //------------- Transmit Ports - TX Driver and OOB signalling --------------
        .TILE1_TXDIFFCTRL0_IN           (),
        .TILE1_TXDIFFCTRL1_IN           (),
        .TILE1_TXN0_OUT                 (TX2[1]),
        .TILE1_TXN1_OUT                 (TX3[1]),
        .TILE1_TXP0_OUT                 (TX2[0]),
        .TILE1_TXP1_OUT                 (TX3[0]),
        .TILE1_TXPREEMPHASIS0_IN        (),
        .TILE1_TXPREEMPHASIS1_IN        ()


    );

    //---------------------Dedicated GTP Reference Clock Inputs ---------------
    // Each dedicated refclk you are using in your design will need its own IBUFDS instance
    
    IBUFDS tile0_gtp0_refclk_ibufds_i
    (
        .O                              (tile0_gtp0_refclk_i),
        .I                              (RCLK[0]),  // Connect to package pin A10
        .IB                             (RCLK[1])   // Connect to package pin B10
    );
   // BUFIO2: I/O Clock Buffer
   //         Spartan-6
   // Xilinx HDL Language Template, version 14.6

   BUFIO2 #(
      .DIVIDE(1),             // DIVCLK divider (1,3-8)
      .DIVIDE_BYPASS("TRUE"), // Bypass the divider circuitry (TRUE/FALSE)
      .I_INVERT("FALSE"),     // Invert clock (TRUE/FALSE)
      .USE_DOUBLER("FALSE")   // Use doubler circuitry (TRUE/FALSE)
   )
   BUFIO2_inst (
      .DIVCLK(CLKBUFIO),           // 1-bit output: Divided clock output
      .IOCLK(),           		// 1-bit output: I/O output clock
      .SERDESSTROBE(), 			// 1-bit output: Output SERDES strobe (connect to ISERDES2/OSERDES2)
      .I(GTPCLKOUT[0])        // 1-bit input: Clock input (connect to IBUFG)
   );

   BUFG BUFG_inst (
      .O(CLK), // 1-bit output: Clock buffer output
      .I(CLKBUFIO)  // 1-bit input: Clock buffer input
   );

/***************************************************************
								VME
****************************************************************/
	assign XBERR         = VME_BERR_o ? 1'b0 : 1'bz;
	assign XDTACK        = VME_DTACK_OE_o ? VME_DTACK_n_o : 1'bz;
	assign XDTACKOE      = VME_DTACK_OE_o ? 1'b0 : 1'bz;
	assign XRETRY        = VME_RETRY_OE_o ? VME_RETRY_n_o : 1'bz;
	assign XA            = (~VME_ADDR_OE_N_o) ? {VME_ADDR_o, VME_LWORD_n_o} : 32'bZ;
	assign ADIR          = VME_ADDR_DIR_o;
	assign VME_ADDR_i    = XA[31:1];
	assign VME_LWORD_n_i = XA[0];
	assign XD            = (~VME_DATA_OE_N_o) ? VME_DATA_o : 32'bZ;
	assign DDIR          = (~VME_DATA_OE_N_o) ? VME_DATA_DIR_o : 1'bz;
	assign VME_DATA_i    = XD;
	assign XIRQ     		= {VME_IRQ_o[7:5], VME_IRQ_o[3:1]};

VME64xCore_Top vme
(
	.clk_i(CLK),
	.rst_n_i(~tile0_resetdone0_i),

	.VME_AS_n_i       (XAS),
	.VME_RST_n_i      (XRESET),
	.VME_WRITE_n_i    (XWRITE),
	.VME_AM_i         (XAM),
	.VME_DS_n_i       (XDS),
	.VME_GA_i         (VME_GA_i),
	.VME_BERR_o       (VME_BERR_o),

	.VME_DTACK_n_o    (VME_DTACK_n_o),
	.VME_RETRY_n_o    (VME_RETRY_n_o),
	.VME_LWORD_n_i    (VME_LWORD_n_i),
	.VME_LWORD_n_o    (VME_LWORD_n_o),
	.VME_ADDR_i       (VME_ADDR_i),
	.VME_ADDR_o       (VME_ADDR_o),
	.VME_DATA_i       (VME_DATA_i),
	.VME_DATA_o       (VME_DATA_o),
	.VME_IRQ_o        (VME_IRQ_o),
	.VME_IACKIN_n_i   (1'b1),
	.VME_IACK_n_i     (1'b1),
	.VME_IACKOUT_n_o  (),

	.VME_DTACK_OE_o   (VME_DTACK_OE_o),
	.VME_DATA_DIR_o   (VME_DATA_DIR_o),
	.VME_DATA_OE_N_o  (VME_DATA_OE_N_o),
	.VME_ADDR_DIR_o   (VME_ADDR_DIR_o),
	.VME_ADDR_OE_N_o  (VME_ADDR_OE_N_o),
	.VME_RETRY_OE_o   (VME_RETRY_OE_o),

	.DAT_i            (32'd0),
	.DAT_o            (),
	.ADR_o            (),
	.CYC_o            (),
	.ERR_i            (1'b0),
	.RTY_i            (1'b0),
	.SEL_o            (),
	.STB_o            (),
	.ACK_i            (1'b0),
	.WE_o             (),
	.STALL_i          (1'b0),

	.INT_ack_o        (),
	.IRQ_i            (),
	.debug            ()
);

	ledengine leda
	(
		.clk	(CLK),
		.led  (LED[1]),
		.trig (triga)
	);
	ledengine ledb
	(
		.clk	(CLK),
		.led  (LED[2]),
		.trig (trigb)
	);
	ledengine ledc
	(
		.clk	(CLK),
		.led  (LED[3]),
		.trig (trigc)
	);

	always @(posedge CLK) begin
		CNT <= CNT + 1;
		triga <= ! XAS;
		trigb <= ((!XAS) && (XAM == 6'h2F));
		trigc <= ((!XAS) && ((XAM == 6'h29) || (XAM == 6'h2D)));
		
	end;

endmodule
