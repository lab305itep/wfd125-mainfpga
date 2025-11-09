`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ITEP
// Engineer: SvirLex
// 
// Create Date:    19:46:33 11/06/2025 
// Design Name:    UWFD64
// Module Name:    ethctl 
// Project Name:   fpga_main
// Target Devices: XC6SLX45T
// Tool versions: 
// Description:    Slow control of ethernet interface
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//	Address map:
// 0    CSR
// 4    MDIO
// 8    received block counter
// 12   error counter
//	CSR bits:
// 31	- enable PHY (clear reset)
//      MDIO bits:
// 31   - busy (read only)
// 30   - reset MDIO
// 22:21 - operation: 0 - none, 1 - write, 2 - read, 3 - reserved
// 20:16 - register address
// 15:0 - data (read/write)
//////////////////////////////////////////////////////////////////////////////////
module ethctl #
(
	parameter PHYADDR = 5'b00111,
	parameter MDIOCLKDIV = 8'b01100100
)(
//		Wishbone
	input [31:0] wb_dat_i,
	output reg [31:0] wb_dat_o,
	input wb_we,
	input wb_clk,
	input wb_cyc,
	output reg wb_ack,
	input wb_stb,
	input [1:0] wb_adr,
	input wb_rst,
//		Phy MDC
	inout phymdio,
	output phymdc,
	input phyint,
	output phyrst,
//		Counter pulses
	input blkcnt,
	input errcnt
);

	reg [31:0] CSR;
	reg [31:0] MDIO;
	reg [31:0] BlockCnt;
	reg [31:0] ErrorCnt;
	reg mdio_read;
	reg mdio_write;
	wire start_of_read;
	wire start_of_write;
	wire [15:0] mdio_rdata;
	wire mdio_vld;
	wire mdio_busy;
	wire mdio_hz;
	wire mdio_in;
	wire mdio_out;
	reg err_pulse;
	reg blk_pulse;
	
	assign phymdio = (mdio_hz) ? 1'bz : mdio_out;
	assign mdio_in = phymdio;
	assign phyrst = CSR[31];

	rgmii_mdio mdio_inst (
		.iWbClk(wb_clk),
		.iRst_n(!(wb_rst | MDIO[30])),
	//---------------------------------------------------------------------------
	//-- signals from register file
	//---------------------------------------------------------------------------
		.iPHYAddr(PHYADDR),
		.iRegAddr(MDIO[20:16]),
		.iNoPre(1'b0),			// always send preamble
		.iData2PHY(MDIO[15:0]),
		.iClkDiv(MDIOCLKDIV),
		.iRdOp(mdio_read),
		.iWrOp(mdio_write),
	//---------------------------------------------------------------------------
	//-- signals to register file
	//---------------------------------------------------------------------------
		.oDataFromPHY(mdio_rdata),	// data from PHY registers
		.oDataFromPHYValid(mdio_vld),	// only valid for 1 clock cycle
		.oClrRdOp(start_of_read), 	// only valid for 1 clock cycle
		.oClrWrOp(start_of_write), 	// only valid for 1 clock cycle
		.oMDIOBusy(mdio_busy),		// management is busy
	//---------------------------------------------------------------------------
	//-- Management interface
	//---------------------------------------------------------------------------
		.iMDI(mdio_in),
		.oMDO(mdio_out),
		.oMDHz(mdio_hz),		// mdio is in HighZ state
		.oMDC(phymdc)
	);

	always @(wb_adr, CSR, MDIO, BlockCnt, ErrorCnt)
	case (wb_adr)
		2'b00: wb_dat_o = CSR;
		2'b01: wb_dat_o = MDIO;
		2'b10: wb_dat_o = BlockCnt;
		2'b11: wb_dat_o = ErrorCnt;
	endcase
	
	always @ (posedge wb_clk) begin
		wb_ack <= #1 wb_cyc & wb_stb;
		mdio_read = 0;
		mdio_write = 0;
		if (wb_rst) begin
			CSR = 0;
			MDIO = 0;
			BlockCnt = 0;
			ErrorCnt = 0;
		end else begin
		// CSR
			if (wb_cyc & wb_stb & wb_we & wb_adr == 0) begin
				CSR = wb_dat_i;
			end
		// MDIO
			if (wb_cyc & wb_stb & wb_we & wb_adr == 1) begin
				MDIO = wb_dat_i;
			end
			MDIO[31] = mdio_busy;
			if (mdio_vld) begin
				MDIO[15:0] = mdio_rdata;
			end
			if (MDIO[22:21] == 1) begin
				mdio_write = 1;
			end
			if (MDIO[22:21] == 2) begin
				mdio_read = 1;
			end
			if (start_of_read || start_of_write) begin
				MDIO[22:21] = 0;
			end
		// Block counter
			if (wb_cyc & wb_stb & wb_we & wb_adr == 2) begin
				BlockCnt = 0;					// reset on write
			end else if (blk_pulse) begin
				BlockCnt = BlockCnt + 1;
			end
		// Error counter
			if (wb_cyc & wb_stb & wb_we & wb_adr == 3) begin
				ErrorCnt = 0;					// reset on write
			end else if (err_pulse) begin
				ErrorCnt = ErrorCnt + 1;
			end
		end
	end
	
	always @ (posedge wb_clk or posedge blkcnt) begin
		if (blk_pulse) begin
			blk_pulse = 0;
		end else if (blkcnt) begin
			blk_pulse = 1;
		end
	end
	
endmodule
