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

	wire CLK125;
	wire [3:0] trig;
	reg once = 1;
	reg greset = 1;
	
	wire [5:0]   VME_GA_i;
	assign 		 VME_GA_i = {^C2X[4:0],~C2X[4:0]};
	
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
	
	wire [63:0]  gtp_data_o;
	wire [3:0]   gtp_kchar_o;
	wire [63:0]  gtp_data_i;
	wire [3:0]   gtp_kchar_i;
	reg  [31:0]  CNT = 0;
	reg [5:1] tpdebug = 0;

	assign TP = tpdebug;
	always @ (posedge CLK125) begin
		tpdebug[5] <= gtp_kchar_i[0];
		tpdebug[4] <= gtp_data_o[63] & gtp_kchar_o[3];
		tpdebug[3] <= gtp_data_o[47] & gtp_kchar_o[2];
		tpdebug[2] <= gtp_data_o[31] & gtp_kchar_o[1];
		tpdebug[1] <= gtp_data_o[15] & gtp_kchar_o[0];
	end

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
	
	wire [31:0] main_csr;
	assign ICX[5] = main_csr[31];	// WB reset to channel FPGA
	inoutreg reg_csr (
		.wb_clk (wb_clk), 
		.wb_cyc (wb_m2s_reg_csr_cyc), 
		.wb_stb (wb_m2s_reg_csr_stb), 
		.wb_adr (wb_m2s_reg_csr_adr[2]), 
		.wb_we  (wb_m2s_reg_csr_we), 
		.wb_dat_i (wb_m2s_reg_csr_dat), 
		.wb_dat_o (wb_s2m_reg_csr_dat), 
		.wb_ack (wb_s2m_reg_csr_ack),
		.reg_o   (main_csr),
		.reg_i	(~main_csr)
	);
	assign wb_s2m_reg_csr_rty = 0;
	assign wb_s2m_reg_csr_err = 0;

	gtprcv4 # (.WB_DIVIDE(5), .WB_MULTIPLY(3))
	UGTP (
		.rxpin	({RX3, RX2, RX1, RX0}),	// input data pins
		.txpin	({TX3, TX2, TX1, TX0}),	// output data pins
		.clkpin	(RCLK),						// input clock pins - tile0 package pins A10/B10
		.clkout	(CLK125),					// output 125 MHz clock
		.clkwb   (wb_clk),					// output clock for wishbone
//			Do remapping here
		.data_o		({gtp_data_o[15:0], gtp_data_o[31:16], gtp_data_o[47:32], gtp_data_o[63:48]}),	// data received
		.charisk_o	({gtp_kchar_o[0], gtp_kchar_o[1], gtp_kchar_o[2], gtp_kchar_o[3]}), 		// K-char signature received
		.data_i		({gtp_data_i[15:0], gtp_data_i[31:16], gtp_data_i[47:32], gtp_data_i[63:48]}),	// data received
		.charisk_i	({gtp_kchar_i[0], gtp_kchar_i[1], gtp_kchar_i[2], gtp_kchar_i[3]}), 		// K-char signature received
		.locked  ()
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
	assign wb_rst 			= ~greset;
	assign wb_m2s_VME64xCore_Top_adr[1:0] = 2'b00;

/*	dtack UDTACK (
		.wb_clk			(wb_clk),
		.vme_dtack		(VME_DTACK_n_o),
		.vme_dtack_oe	(VME_DTACK_OE_o),
		.xdtack			(XDTACK),
		.xdtackoe		(XDTACKOE)
	);
*/

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
	.clk_i(wb_clk),
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

//		LEDs
genvar i;
generate
	for (i = 0; i < 4; i = i + 1) begin : GLED
		ledengine ULED
		(
			.clk	(CLK125),
			.led  (LED[i]),
			.trig (trig[i])
		);
	end
endgenerate

//		clock buffer control
   i2c_master_slave UI2C (
		.wb_clk_i  (wb_clk), 
		.wb_rst_i  (~wb_rst),		// active high 
		.arst_i    (1'b0), 		// active high
		.wb_adr_i  (wb_m2s_i2c_ms_cbuf_adr[4:2]), 
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
	assign wb_s2m_i2c_ms_cbuf_err = 0;
	assign wb_s2m_i2c_ms_cbuf_rty = 0;

//		Trigger processing
	wire [15:0] trg2gtp;
	wire kchar2gtp;
	
	assign gtp_data_i = {trg2gtp, trg2gtp, trg2gtp, trg2gtp};
	assign gtp_kchar_i = {kchar2gtp, kchar2gtp, kchar2gtp, kchar2gtp};
	
   triggen UTRIG (
		.wb_clk  	(wb_clk), 
		.wb_rst  	(~wb_rst), 
		.wb_adr  	(wb_m2s_triggen_adr[2]), 
		.wb_dat_i  	(wb_m2s_triggen_dat), 
		.wb_dat_o  	(wb_s2m_triggen_dat),
		.wb_we   	(wb_m2s_triggen_we),
		.wb_stb  	(wb_m2s_triggen_stb),
		.wb_cyc  	(wb_m2s_triggen_cyc), 
		.wb_ack  	(wb_s2m_triggen_ack), 
		.trg_data_i	(gtp_data_o),
		.trg_data_o (trg2gtp),
		.clk			(CLK125),
		.kchar_i		(gtp_kchar_o),
		.kchar_o		(kchar2gtp),
		.trg_ext(1'b0)
	);

	assign wb_s2m_triggen_err = 0;
	assign wb_s2m_triggen_rty = 0;

//		Fifo memory
	wire [15:0] fifo_cnt_A;
	wire [15:0] fifo_cnt_B;
	wire [15:0] fifo_cnt_C;
	wire [15:0] fifo_cnt_D;

rcvfifo fifoA (
		.wb_stb		(wb_m2s_fifoA_stb),
		.wb_cyc		(wb_m2s_fifoA_cyc),
		.wb_ack		(wb_s2m_fifoA_ack),
		.wb_dat_o	(wb_s2m_fifoA_dat),
		.wb_we		(wb_m2s_fifoA_we),
		.wb_clk		(wb_clk),
		.gtp_clk		(CLK125),
		.gtp_dat		(gtp_data_o[15:0]),
		.gtp_vld		(!gtp_kchar_o[0]),
		.fifocnt		(fifo_cnt_A),
		.overflow	(trig[0])
   );

	assign wb_s2m_fifoA_err = 0;
	assign wb_s2m_fifoA_rty = 0;	

rcvfifo fifoB(
		.wb_stb		(wb_m2s_fifoB_stb),
		.wb_cyc		(wb_m2s_fifoB_cyc),
		.wb_ack		(wb_s2m_fifoB_ack),
		.wb_dat_o	(wb_s2m_fifoB_dat),
		.wb_we		(wb_m2s_fifoB_we),
		.wb_clk		(wb_clk),
		.gtp_clk		(CLK125),
		.gtp_dat		(gtp_data_o[31:16]),
		.gtp_vld		(!gtp_kchar_o[1]),
		.fifocnt		(fifo_cnt_B),
		.overflow	(trig[1])
   );

	assign wb_s2m_fifoB_err = 0;
	assign wb_s2m_fifoB_rty = 0;	

rcvfifo fifoC(
		.wb_stb		(wb_m2s_fifoC_stb),
		.wb_cyc		(wb_m2s_fifoC_cyc),
		.wb_ack		(wb_s2m_fifoC_ack),
		.wb_dat_o	(wb_s2m_fifoC_dat),
		.wb_we		(wb_m2s_fifoC_we),
		.wb_clk		(wb_clk),
		.gtp_clk		(CLK125),
		.gtp_dat		(gtp_data_o[47:32]),
		.gtp_vld		(!gtp_kchar_o[2]),
		.fifocnt		(fifo_cnt_C),
		.overflow	(trig[2])
    );

	assign wb_s2m_fifoC_err = 0;
	assign wb_s2m_fifoC_rty = 0;	

rcvfifo fifoD(
		.wb_stb		(wb_m2s_fifoD_stb),
		.wb_cyc		(wb_m2s_fifoD_cyc),
		.wb_ack		(wb_s2m_fifoD_ack),
		.wb_dat_o	(wb_s2m_fifoD_dat),
		.wb_we		(wb_m2s_fifoD_we),
		.wb_clk		(wb_clk),
		.gtp_clk		(CLK125),
		.gtp_dat		(gtp_data_o[63:48]),
		.gtp_vld		(!gtp_kchar_o[3]),
		.fifocnt		(fifo_cnt_D),
		.overflow	(trig[3])
   );

	assign wb_s2m_fifoD_err = 0;
	assign wb_s2m_fifoD_rty = 0;	

//		Registers	
	inoutreg regA (
		.wb_clk (wb_clk), 
		.wb_cyc (wb_m2s_regA_cyc), 
		.wb_stb (wb_m2s_regA_stb), 
		.wb_adr (wb_m2s_regA_adr[2]), 
		.wb_we  (wb_m2s_regA_we), 
		.wb_dat_i (wb_m2s_regA_dat), 
		.wb_dat_o (wb_s2m_regA_dat), 
		.wb_ack (wb_s2m_regA_ack),
		.reg_o   (),
		.reg_i	({trig[0], 15'h0000, fifo_cnt_A})
	);
	assign wb_s2m_regA_rty = 0;
	assign wb_s2m_regA_err = 0;

	inoutreg regB (
		.wb_clk (wb_clk), 
		.wb_cyc (wb_m2s_regB_cyc), 
		.wb_stb (wb_m2s_regB_stb), 
		.wb_adr (wb_m2s_regB_adr[2]), 
		.wb_we  (wb_m2s_regB_we), 
		.wb_dat_i (wb_m2s_regB_dat), 
		.wb_dat_o (wb_s2m_regB_dat), 
		.wb_ack (wb_s2m_regB_ack),
		.reg_o   (),
		.reg_i	({trig[1], 15'h0000, fifo_cnt_B})
	);
	assign wb_s2m_regB_rty = 0;
	assign wb_s2m_regB_err = 0;

	inoutreg regC (
		.wb_clk (wb_clk), 
		.wb_cyc (wb_m2s_regC_cyc), 
		.wb_stb (wb_m2s_regC_stb), 
		.wb_adr (wb_m2s_regC_adr[2]), 
		.wb_we  (wb_m2s_regC_we), 
		.wb_dat_i (wb_m2s_regC_dat), 
		.wb_dat_o (wb_s2m_regC_dat), 
		.wb_ack (wb_s2m_regC_ack),
		.reg_o   (),
		.reg_i	({trig[2], 15'h0000, fifo_cnt_C})
	);
	assign wb_s2m_regC_rty = 0;
	assign wb_s2m_regC_err = 0;

	inoutreg regD (
		.wb_clk (wb_clk), 
		.wb_cyc (wb_m2s_regD_cyc), 
		.wb_stb (wb_m2s_regD_stb), 
		.wb_adr (wb_m2s_regD_adr[2]), 
		.wb_we  (wb_m2s_regD_we), 
		.wb_dat_i (wb_m2s_regD_dat), 
		.wb_dat_o (wb_s2m_regD_dat), 
		.wb_ack (wb_s2m_regD_ack),
		.reg_o   (),
		.reg_i	({trig[3], 15'h0000, fifo_cnt_D})
	);
	assign wb_s2m_regD_rty = 0;
	assign wb_s2m_regD_err = 0;

//		Global counter
	always @(posedge CLK125) begin
		if (!once) greset <= !C2X[7];
		CNT <= CNT + 1;
		if (CNT == 1000000) once = 0;
	end;

//		SPI to DAC
wire [6:0] empty_spi_csa;
xspi_master  #(
	.CLK_DIV (49),
	.CLK_POL (1'b1)
) dac_spi (
	 .wb_rst    (~wb_rst),
    .wb_clk    (wb_clk),
    .wb_we     (wb_m2s_dac_spi_we),
    .wb_dat_i  (wb_m2s_dac_spi_dat[15:0]),
    .wb_dat_o  (wb_s2m_dac_spi_dat[15:0]),
    .wb_cyc		(wb_m2s_dac_spi_cyc),
    .wb_stb		(wb_m2s_dac_spi_stb),
    .wb_ack		(wb_s2m_dac_spi_ack),
    .spi_dat   (BDACD),
    .spi_clk   (BDACC),
    .spi_cs    ({empty_spi_csa, BDACCS}),
    .wb_adr		(wb_m2s_dac_spi_adr[2])
);
	assign wb_s2m_dac_spi_err = 0;
	assign wb_s2m_dac_spi_rty = 0;	
	assign wb_s2m_dac_spi_dat[31:16] = 0;	

//		SPI to other xilinxes
wire [6:0] empty_spi_csb;
xspi_master  #(
	.CLK_DIV (49),
	.CLK_POL (1'b0)
) icx_spi (
	 .wb_rst    (~wb_rst),
    .wb_clk    (wb_clk),
    .wb_we     (wb_m2s_icx_spi_we),
    .wb_dat_i  (wb_m2s_icx_spi_dat[15:0]),
    .wb_dat_o  (wb_s2m_icx_spi_dat[15:0]),
    .wb_cyc		(wb_m2s_icx_spi_cyc),
    .wb_stb		(wb_m2s_icx_spi_stb),
    .wb_ack		(wb_s2m_icx_spi_ack),
    .spi_dat   (ICX[3]),
    .spi_clk   (ICX[4]),
    .spi_cs    ({empty_spi_csb, ICX[2]}),
    .wb_adr		(wb_m2s_icx_spi_adr[2])
);
	assign wb_s2m_icx_spi_err = 0;
	assign wb_s2m_icx_spi_rty = 0;	
	assign wb_s2m_icx_spi_dat[31:16] = 0;	

endmodule
