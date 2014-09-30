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
    input [5:0] XGA,	// active low
	// Data
    inout [31:0] XD, 
	// Strobes
    input XAS,			// active low
    input [1:0] XDS,	// active low
    input XWRITE,		// 0 = write
    output XDTACK,	// active low
    output XDTACKOE,	// active low
    output ADIR,		// 0 - inward
    output DDIR,		// 0 - inward
	// Errors/resets
    input XRESET,
    output XBERR,
    output XRETRY,
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
    inout CBUFSCL,
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

	wire			 wb_clk;
	wire         wb_rst;
`include "wb_intercon.vh"

	wire CLK;
	wire CLK125;
	wire CLK250;
	wire tile0_gtp0_refclk_i;
	wire tile0_resetdone0_i;
	wire [1:0] GTPCLKOUT;
	wire CLKBUFIO;
	// module addressed bits
	reg ADS = 0;
	reg [31:0] CNT = 0;
//	reg triga = 0;
//	reg trigb = 0;
//	reg trigc = 0;
	reg once = 1;
	reg greset = 1;
	wire comma;
	
	wire [5:0] VME_GA_i;
	
	assign 		 VME_GA_i = 6'b111110;
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
	wire [7:0]   debug;
	wire [1:0]   dummy_vme_addr;
	wire         CBUFSDA_o;
	wire			 CBUFSCL_o;
	wire         CBUFSDA_en;
	wire			 CBUFSCL_en;
	
	wire [31:0]  REG_INPUT;
	wire [31:0]  REG_OUTPUT;
	
	wire [15:0]  GTP_DAT_A;
	wire [15:0]  GTP_DAT_B;
	wire [15:0]  GTP_DAT_C;
	wire [15:0]  GTP_DAT_D;
	wire         tile0_plllkdet_o;
	wire [1:0]   rxcomma;

	assign comma = (CNT[7:0] == 8'hBC) ? 1'b1 : 1'b0;

// 	assign LED[0] = (REG_OUTPUT[0]) ? CNT[26] : CNT[23];
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
   assign BDACC = 1'bz;
   assign BDACD = 1'bz;
   assign BDACCS = 1'bz;
   assign ECLKSEL = 1'bz;
   assign OCLKSEL = 1'bz;
   assign CLKENFP = 1'bz;
   assign CLKENBP = 1'bz;
   assign CLKENBFP = 1'bz;

	assign TP[5:1] = {CBUFSDA_o, CBUFSCL_o, CBUFSDA_en, CBUFSCL_en, 1'b0};

    //--------------------------- The GTP Wrapper -----------------------------
    s6_gtpwizard_v1_11 #
    (
        .WRAPPER_SIM_GTPRESET_SPEEDUP   (0),      // Set this to 1 for simulation
        .WRAPPER_SIMULATION             (0)       // Set this to 1 for simulation
    )
    s6_gtpwizard_v1_11_i
    (
        //_____________________________________________________________________
        //TILE0  (X0_Y0)
        //---------------------- Loopback and Powerdown Ports ----------------------
        .TILE0_LOOPBACK0_IN             (REG_OUTPUT[2:0]),
        .TILE0_LOOPBACK1_IN             (REG_OUTPUT[2:0]),
        //------------------------------- PLL Ports --------------------------------
        .TILE0_CLK00_IN                 (tile0_gtp0_refclk_i),
        .TILE0_CLK01_IN                 (tile0_gtp0_refclk_i),
        .TILE0_GTPRESET0_IN             (),
        .TILE0_GTPRESET1_IN             (),
        .TILE0_PLLLKDET0_OUT            (tile0_plllkdet_o),
        .TILE0_PLLLKDET1_OUT            (),
        .TILE0_RESETDONE0_OUT           (),
        .TILE0_RESETDONE1_OUT           (),
        //--------------------- Receive Ports - 8b10b Decoder ----------------------
        .TILE0_RXCHARISCOMMA0_OUT       (),
        .TILE0_RXCHARISCOMMA1_OUT       (),
        .TILE0_RXCHARISK0_OUT           (),
        .TILE0_RXCHARISK1_OUT           (),
        .TILE0_RXDISPERR0_OUT           ({dummy_1, GTP_DISPERR_A}),
        .TILE0_RXDISPERR1_OUT           ({dummy_2, GTP_DISPERR_B}),
        .TILE0_RXNOTINTABLE0_OUT        ({dummy_3, GTP_NOTINTAB_A}),
        .TILE0_RXNOTINTABLE1_OUT        ({dummy_4, GTP_NOTINTAB_B}),
        //------------- Receive Ports - Comma Detection and Alignment --------------
        .TILE0_RXBYTEISALIGNED0_OUT     (GTP_ALIGNED_A),
        .TILE0_RXBYTEISALIGNED1_OUT     (GTP_ALIGNED_B),
        .TILE0_RXCOMMADET0_OUT          (),
        .TILE0_RXCOMMADET1_OUT          (),
        .TILE0_RXENMCOMMAALIGN0_IN      (1'b1),
        .TILE0_RXENMCOMMAALIGN1_IN      (1'b1),
        .TILE0_RXENPCOMMAALIGN0_IN      (1'b1),
        .TILE0_RXENPCOMMAALIGN1_IN      (1'b1),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .TILE0_RXDATA0_OUT              (GTP_DAT_A),
        .TILE0_RXDATA1_OUT              (GTP_DAT_B),
        .TILE0_RXUSRCLK0_IN             (CLK250),
        .TILE0_RXUSRCLK1_IN             (CLK250),
        .TILE0_RXUSRCLK20_IN            (CLK125),
        .TILE0_RXUSRCLK21_IN            (CLK125),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .TILE0_RXN0_IN                  (RX0[1]),
        .TILE0_RXN1_IN                  (RX1[1]),
        .TILE0_RXP0_IN                  (RX0[0]),
        .TILE0_RXP1_IN                  (RX1[0]),
        //------------- Receive Ports - RX Loss-of-sync State Machine --------------
        .TILE0_RXLOSSOFSYNC0_OUT        (),
        .TILE0_RXLOSSOFSYNC1_OUT        (),
        //-------------------------- TX/RX Datapath Ports --------------------------
        .TILE0_GTPCLKOUT0_OUT           (GTPCLKOUT),
        .TILE0_GTPCLKOUT1_OUT           (),
        //----------------- Transmit Ports - 8b10b Encoder Control -----------------
        .TILE0_TXCHARISK0_IN            ({1'b0, comma}),
        .TILE0_TXCHARISK1_IN            ({1'b0, comma}),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .TILE0_TXDATA0_IN               (CNT[15:0]),
        .TILE0_TXDATA1_IN               (CNT[15:0]),
        .TILE0_TXUSRCLK0_IN             (CLK250),
        .TILE0_TXUSRCLK1_IN             (CLK250),
        .TILE0_TXUSRCLK20_IN            (CLK125),
        .TILE0_TXUSRCLK21_IN            (CLK125),
        //------------- Transmit Ports - TX Driver and OOB signalling --------------
        .TILE0_TXN0_OUT                 (TX0[1]),
        .TILE0_TXN1_OUT                 (TX1[1]),
        .TILE0_TXP0_OUT                 (TX0[0]),
        .TILE0_TXP1_OUT                 (TX1[0]),
    
        //_____________________________________________________________________
        //_____________________________________________________________________
        //TILE1  (X1_Y0)
 
        //---------------------- Loopback and Powerdown Ports ----------------------
        .TILE1_LOOPBACK0_IN             (REG_OUTPUT[2:0]),
        .TILE1_LOOPBACK1_IN             (REG_OUTPUT[2:0]),
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
        .TILE1_RXCHARISCOMMA0_OUT       (),
        .TILE1_RXCHARISCOMMA1_OUT       (),
        .TILE1_RXCHARISK0_OUT           (),
        .TILE1_RXCHARISK1_OUT           (),
        .TILE1_RXDISPERR0_OUT           ({dummy_5, GTP_DISPERR_C}),
        .TILE1_RXDISPERR1_OUT           ({dummy_6, GTP_DISPERR_D}),
        .TILE1_RXNOTINTABLE0_OUT        ({dummy_7, GTP_NOTINTAB_C}),
        .TILE1_RXNOTINTABLE1_OUT        ({dummy_8, GTP_NOTINTAB_D}),
        //------------- Receive Ports - Comma Detection and Alignment --------------
        .TILE1_RXBYTEISALIGNED0_OUT     (GTP_ALIGNED_C),
        .TILE1_RXBYTEISALIGNED1_OUT     (GTP_ALIGNED_D),
        .TILE1_RXCOMMADET0_OUT          (),
        .TILE1_RXCOMMADET1_OUT          (),
        .TILE1_RXENMCOMMAALIGN0_IN      (1'b1),
        .TILE1_RXENMCOMMAALIGN1_IN      (1'b1),
        .TILE1_RXENPCOMMAALIGN0_IN      (1'b1),
        .TILE1_RXENPCOMMAALIGN1_IN      (1'b1),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .TILE1_RXDATA0_OUT              (GTP_DAT_C),
        .TILE1_RXDATA1_OUT              (GTP_DAT_D),
        .TILE1_RXUSRCLK0_IN             (CLK250),
        .TILE1_RXUSRCLK1_IN             (CLK250),
        .TILE1_RXUSRCLK20_IN            (CLK125),
        .TILE1_RXUSRCLK21_IN            (CLK125),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .TILE1_RXN0_IN                  (RX2[1]),
        .TILE1_RXN1_IN                  (RX3[1]),
        .TILE1_RXP0_IN                  (RX2[0]),
        .TILE1_RXP1_IN                  (RX3[0]),
        //------------- Receive Ports - RX Loss-of-sync State Machine --------------
        .TILE1_RXLOSSOFSYNC0_OUT        (),
        .TILE1_RXLOSSOFSYNC1_OUT        (),
        //-------------------------- TX/RX Datapath Ports --------------------------
        .TILE1_GTPCLKOUT0_OUT           (),
        .TILE1_GTPCLKOUT1_OUT           (),
        //----------------- Transmit Ports - 8b10b Encoder Control -----------------
        .TILE1_TXCHARISK0_IN            ({1'b0, comma}),
        .TILE1_TXCHARISK1_IN            ({1'b0, comma}),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .TILE1_TXDATA0_IN               (CNT[15:0]),
        .TILE1_TXDATA1_IN               (CNT[15:0]),
        .TILE1_TXUSRCLK0_IN             (CLK250),
        .TILE1_TXUSRCLK1_IN             (CLK250),
        .TILE1_TXUSRCLK20_IN            (CLK125),
        .TILE1_TXUSRCLK21_IN            (CLK125),
        //------------- Transmit Ports - TX Driver and OOB signalling --------------
        .TILE1_TXN0_OUT                 (TX2[1]),
        .TILE1_TXN1_OUT                 (TX3[1]),
        .TILE1_TXP0_OUT                 (TX2[0]),
        .TILE1_TXP1_OUT                 (TX3[0])
    );
    
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
      .O(CLK125_i), // 1-bit output: Clock buffer output
      .I(CLKBUFIO)  // 1-bit input: Clock buffer input
   );

   PLL_BASE #(
      .BANDWIDTH("OPTIMIZED"),             // "HIGH", "LOW" or "OPTIMIZED" 
      .CLKFBOUT_MULT(4),                   // Multiply value for all CLKOUT clock outputs (1-64)
      .CLKFBOUT_PHASE(0.0),                // Phase offset in degrees of the clock feedback output (0.0-360.0).
      .CLKIN_PERIOD(8.0),                  // Input clock period in ns to ps resolution (i.e. 33.333 is 30
                                           // MHz).
      // CLKOUT0_DIVIDE - CLKOUT5_DIVIDE: Divide amount for CLKOUT# clock output (1-128)
      .CLKOUT0_DIVIDE(4),
      .CLKOUT1_DIVIDE(2),
      .CLKOUT2_DIVIDE(5),
      .CLKOUT3_DIVIDE(1),
      .CLKOUT4_DIVIDE(1),
      .CLKOUT5_DIVIDE(1),
      // CLKOUT0_DUTY_CYCLE - CLKOUT5_DUTY_CYCLE: Duty cycle for CLKOUT# clock output (0.01-0.99).
      .CLKOUT0_DUTY_CYCLE(0.5),
      .CLKOUT1_DUTY_CYCLE(0.5),
      .CLKOUT2_DUTY_CYCLE(0.5),
      .CLKOUT3_DUTY_CYCLE(0.5),
      .CLKOUT4_DUTY_CYCLE(0.5),
      .CLKOUT5_DUTY_CYCLE(0.5),
      // CLKOUT0_PHASE - CLKOUT5_PHASE: Output phase relationship for CLKOUT# clock output (-360.0-360.0).
      .CLKOUT0_PHASE(0.0),
      .CLKOUT1_PHASE(0.0),
      .CLKOUT2_PHASE(0.0),
      .CLKOUT3_PHASE(0.0),
      .CLKOUT4_PHASE(0.0),
      .CLKOUT5_PHASE(0.0),
      .CLK_FEEDBACK("CLKFBOUT"),           // Clock source to drive CLKFBIN ("CLKFBOUT" or "CLKOUT0")
      .COMPENSATION("SYSTEM_SYNCHRONOUS"), // "SYSTEM_SYNCHRONOUS", "SOURCE_SYNCHRONOUS", "EXTERNAL" 
      .DIVCLK_DIVIDE(1),                   // Division value for all output clocks (1-52)
      .REF_JITTER(0.1),                    // Reference Clock Jitter in UI (0.000-0.999).
      .RESET_ON_LOSS_OF_LOCK("FALSE")      // Must be set to FALSE
   )
   PLL_BASE_inst (
      .CLKFBOUT(CLKPLLFB), // 1-bit output: PLL_BASE feedback output
      // CLKOUT0 - CLKOUT5: 1-bit (each) output: Clock outputs
      .CLKOUT0(CLK125_o),
      .CLKOUT1(CLK250_o),
      .CLKOUT2(CLK100_o),
      .CLKOUT3(),
      .CLKOUT4(),
      .CLKOUT5(),
      .LOCKED(),     // 1-bit output: PLL_BASE lock status output
      .CLKFBIN(CLKPLLFB),   // 1-bit input: Feedback clock input
      .CLKIN(CLK125_i),       // 1-bit input: Clock input
      .RST(~tile0_plllkdet_o)            // 1-bit input: Reset input
   );

   BUFG BUFG_inst250 (
      .O(CLK250), // 1-bit output: Clock buffer output
      .I(CLK250_o)  // 1-bit input: Clock buffer input
   );
   BUFG BUFG_inst125 (
      .O(CLK125), // 1-bit output: Clock buffer output
      .I(CLK125_o)  // 1-bit input: Clock buffer input
   );
   BUFG BUFG_inst100 (
      .O(CLK), // 1-bit output: Clock buffer output
      .I(CLK100_o)  // 1-bit input: Clock buffer input
   );


/***************************************************************
								VME
****************************************************************/
	assign XBERR         = ~VME_BERR_o;
	assign XDTACK        = VME_DTACK_OE_o ? VME_DTACK_n_o : 1'bz;
	assign XDTACKOE      = VME_DTACK_OE_o ? 1'b0 : 1'bz;
	assign XRETRY        = VME_RETRY_n_o;
	assign XA            = (VME_ADDR_DIR_o) ? {VME_ADDR_o, VME_LWORD_n_o} : 32'bZ;
	assign ADIR          = VME_ADDR_DIR_o;
	assign VME_ADDR_i    = XA[31:1];
	assign VME_LWORD_n_i = XA[0];
	assign XD            = (VME_DATA_DIR_o) ? VME_DATA_o : 32'bZ;
	assign DDIR          = (VME_DATA_DIR_o) ? 1'b1 : 1'bz;
	assign VME_DATA_i    = XD;
	assign XIRQ     		= {VME_IRQ_o[7:5], VME_IRQ_o[3:1]};
	assign wb_clk = CLK;
	assign wb_rst = ~greset;
	assign wb_m2s_VME64xCore_Top_adr[1:0] = 2'b00;

VME64xCore_Top #(
    .g_clock (8), 	    		// clock period (ns)
    .g_wb_data_width (32),		// WB data width:
    .g_wb_addr_width (32),		// WB address width:
	 .g_BoardID       (125),
    .g_ManufacturerID (305),
    .g_RevisionID     (1),
    .g_ProgramID      (1)
)
vme (
	.clk_i(CLK),
	.rst_n_i(wb_rst),

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

	.DAT_i            (wb_s2m_VME64xCore_Top_dat),
	.DAT_o            (wb_m2s_VME64xCore_Top_dat),
	.ADR_o            ({dummy_vme_addr, wb_m2s_VME64xCore_Top_adr[31:2]}),
	.CYC_o            (wb_m2s_VME64xCore_Top_cyc),
	.ERR_i            (wb_s2m_VME64xCore_Top_err),
	.RTY_i            (wb_s2m_VME64xCore_Top_rty),
	.SEL_o            (wb_m2s_VME64xCore_Top_sel),
	.STB_o            (wb_m2s_VME64xCore_Top_stb),
	.ACK_i            (wb_s2m_VME64xCore_Top_ack),
	.WE_o             (wb_m2s_VME64xCore_Top_we),
	.STALL_i          (1'b0),

	.INT_ack_o        (),
	.IRQ_i            (1'b0),
	.debug            (debug)
);

	ledengine leda
	(
		.clk	(CLK125),
		.led  (LED[0]),
		.trig (triga)
	);
	
   ledengine ledb
	(
		.clk	(CLK125),
		.led  (LED[1]),
		.trig (trigb)
	);
	ledengine ledc
	(
		.clk	(CLK125),
		.led  (LED[2]),
		.trig (trigc)
	);
	ledengine ledd
	(
		.clk	(CLK125),
		.led  (LED[3]),
		.trig (trigd)
	);

	assign wb_s2m_simple_gpio_rty = 0;
	assign wb_s2m_simple_gpio_err = 0;
	
	inoutreg somereg(
		.wb_clk (CLK), 
		.wb_cyc (wb_m2s_simple_gpio_cyc), 
		.wb_stb (wb_m2s_simple_gpio_stb), 
		.wb_adr (wb_m2s_simple_gpio_adr[2]), 
		.wb_we  (wb_m2s_simple_gpio_we), 
		.wb_dat_i (wb_m2s_simple_gpio_dat), 
		.wb_dat_o (wb_s2m_simple_gpio_dat), 
		.wb_ack (wb_s2m_simple_gpio_ack),
		.reg_o   (REG_OUTPUT),
		.reg_i	(REG_INPUT)
	);

	assign wb_s2m_i2c_ms_cbuf_err = 0;
	assign wb_s2m_i2c_ms_cbuf_rty = 0;

  i2c_master_slave i2c_ms_cbuf (
		.wb_clk_i  (CLK), 
		.wb_rst_i  (~wb_rst),		// active high 
		.arst_i    (1'b0), 		// active high
		.wb_adr_i  (wb_m2s_i2c_ms_cbuf_adr[6:4]), 
		.wb_dat_i  (wb_m2s_i2c_ms_cbuf_dat), 
		.wb_dat_o  (wb_s2m_i2c_ms_cbuf_dat),
		.wb_we_i   (wb_m2s_i2c_ms_cbuf_we),
		.wb_stb_i  (wb_m2s_i2c_ms_cbuf_stb),
		.wb_cyc_i  (wb_m2s_i2c_ms_cbuf_cyc), 
		.wb_ack_o  (wb_s2m_i2c_ms_cbuf_ack), 
		.wb_inta_o (),
		.scl_pad_i (CBUFSCL), 
		.scl_pad_o (CBUFSCL_o), 
		.scl_padoen_o (CBUFSCL_en), 	// active low ?
		.sda_pad_i (CBUFSDA), 
		.sda_pad_o (CBUFSDA_o), 
		.sda_padoen_o (CBUFSDA_en)		// active low ?
	);

   assign CBUFSCL = (!CBUFSCL_en) ? (CBUFSCL_o) : 1'bz;
   assign CBUFSDA = (!CBUFSDA_en) ? (CBUFSDA_o) : 1'bz;

myblkram mymemA(
    .wb_adr		(wb_m2s_mymemA_adr[10:2]),
    .wb_stb		(wb_m2s_mymemA_stb),
    .wb_cyc		(wb_m2s_mymemA_cyc),
    .wb_ack		(wb_s2m_mymemA_ack),
    .wb_dat_o	(wb_s2m_mymemA_dat),
    .wb_dat_i	(wb_m2s_mymemA_dat),
    .wb_we		(wb_m2s_mymemA_we),
    .wb_clk		(CLK),
	 .wb_rst		(~wb_rst),
	 .wb_sel		(wb_m2s_mymemA_sel),
    .gtp_clk	(CLK125),
    .gtp_dat	(GTP_DAT_A),
    .gtp_vld	(1'b1),
    .cntrl_run (REG_OUTPUT[16]),
    .cntrl_ready ()
    );

	assign wb_s2m_mymemA_err = 0;
	assign wb_s2m_mymemA_rty = 0;	

myblkram mymemB(
    .wb_adr		(wb_m2s_mymemB_adr[10:2]),
    .wb_stb		(wb_m2s_mymemB_stb),
    .wb_cyc		(wb_m2s_mymemB_cyc),
    .wb_ack		(wb_s2m_mymemB_ack),
    .wb_dat_o	(wb_s2m_mymemB_dat),
    .wb_dat_i	(wb_m2s_mymemB_dat),
    .wb_we		(wb_m2s_mymemB_we),
    .wb_clk		(CLK),
	 .wb_rst		(~wb_rst),
	 .wb_sel		(wb_m2s_mymemB_sel),
    .gtp_clk	(CLK125),
    .gtp_dat	(GTP_DAT_B),
    .gtp_vld	(1'b1),
    .cntrl_run (REG_OUTPUT[17]),
    .cntrl_ready ()
    );

	assign wb_s2m_mymemB_err = 0;
	assign wb_s2m_mymemB_rty = 0;	

myblkram mymemC(
    .wb_adr		(wb_m2s_mymemC_adr[10:2]),
    .wb_stb		(wb_m2s_mymemC_stb),
    .wb_cyc		(wb_m2s_mymemC_cyc),
    .wb_ack		(wb_s2m_mymemC_ack),
    .wb_dat_o	(wb_s2m_mymemC_dat),
    .wb_dat_i	(wb_m2s_mymemC_dat),
    .wb_we		(wb_m2s_mymemC_we),
    .wb_clk		(CLK),
	 .wb_rst		(~wb_rst),
	 .wb_sel		(wb_m2s_mymemC_sel),
    .gtp_clk	(CLK125),
    .gtp_dat	(GTP_DAT_C),
    .gtp_vld	(1'b1),
    .cntrl_run (REG_OUTPUT[18]),
    .cntrl_ready ()
    );

	assign wb_s2m_mymemC_err = 0;
	assign wb_s2m_mymemC_rty = 0;	

myblkram mymemD(
    .wb_adr		(wb_m2s_mymemD_adr[10:2]),
    .wb_stb		(wb_m2s_mymemD_stb),
    .wb_cyc		(wb_m2s_mymemD_cyc),
    .wb_ack		(wb_s2m_mymemD_ack),
    .wb_dat_o	(wb_s2m_mymemD_dat),
    .wb_dat_i	(wb_m2s_mymemD_dat),
    .wb_we		(wb_m2s_mymemD_we),
    .wb_clk		(CLK),
	 .wb_rst		(~wb_rst),
	 .wb_sel		(wb_m2s_mymemD_sel),
    .gtp_clk	(CLK125),
    .gtp_dat	(GTP_DAT_D),
    .gtp_vld	(1'b1),
    .cntrl_run (REG_OUTPUT[19]),
    .cntrl_ready ()
    );

	assign wb_s2m_mymemD_err = 0;
	assign wb_s2m_mymemD_rty = 0;	

	always @(posedge CLK) begin
		if (!once) greset <= 0;
	end;

	always @(posedge CLK125) begin
		CNT <= CNT + 1;
		if (CNT == 27'h7FFFFFF) once = 0;
//		triga <= GTP_DISPERR_A | GTP_DISPERR_B | GTP_DISPERR_C | GTP_DISPERR_D | ICX[0] | ICX [4] | ICX[8] | ICX[12];
//		trigb <= GTP_NOTINTAB_A | GTP_NOTINTAB_B | GTP_NOTINTAB_C | GTP_NOTINTAB_D | ICX[1] | ICX [5] | ICX[9] | ICX[13];
	end;

   assign REG_INPUT = {1'b0, GTP_ALIGNED_D, GTP_NOTINTAB_D, GTP_DISPERR_D, 1'b0, GTP_ALIGNED_C, GTP_NOTINTAB_C, GTP_DISPERR_C, 1'b0, GTP_ALIGNED_B, GTP_NOTINTAB_B, GTP_DISPERR_B, 1'b0, GTP_ALIGNED_A, GTP_NOTINTAB_A, GTP_DISPERR_A, ICX};
//	assign LED[3] = GTP_ALIGNED_A & GTP_ALIGNED_B & GTP_ALIGNED_C & GTP_ALIGNED_D & ICX[2] & ICX[6] & ICX[10] & ICX[14]; 

checkser ckserA(
	.data (GTP_DAT_A),
	.clk	(CLK125),
	.err	(triga)
);

checkser ckserB(
	.data (GTP_DAT_B),
	.clk	(CLK125),
	.err	(trigb)
);

checkser ckserC(
	.data (GTP_DAT_C),
	.clk	(CLK125),
	.err	(trigc)
);

checkser ckserD(
	.data (GTP_DAT_D),
	.clk	(CLK125),
	.err	(trigd)
);


endmodule
