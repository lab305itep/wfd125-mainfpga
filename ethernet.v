`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ITEP
// Engineer: SvirLex
// 
// Create Date:    00:52:30 11/06/2025 
// Design Name:    UWFD64 
// Module Name:    ethernet 
// Project Name:   mainfpga
// Target Devices: XC6SLX45T
// Tool versions: 
// Description:    Wrapper for ethernet MAC
// Module do all the ethernet communication and send commands to top:
// Commands (cmd):
// 0 - none
// 1 - read sdram data (<value> 32-bit words from the address <address>)
// 2 - read register at <address>
// 3 - write register at <address> with <value>
// 4-7 - reserved
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ethernet(
	// general
	input clk125,
	input clk125_90,
	input reset,
	output error,
	output rcvcnt,
	output [4:0] debug,
	// data to be sent
	input [31:0] txd,
	input txvld,
	input txend,
	output txready,
	// request received
	output [31:0] address,
	output [31:0] value,
	output [2:0] cmd,
	input ready4cmd,
	// PHY interface
	input rgmii_rx_clk,
	input [3:0] rgmii_rxd,
	input rgmii_rx_ctl,
	output rgmii_tx_clk,
	output [3:0] rgmii_txd,
	output rgmii_tx_ctl,
	output mac_gmii_tx_en
	);

	wire [7:0] tdata;
	wire tvalid;
	wire tready;
	wire tlast;
	wire tuser;
	wire [7:0] rdata;
	wire rvalid;
	wire rready;
	wire rlast;
	wire ruser;
	
	assign error = ruser | tuser;
	assign txready = tready;
	assign address = 0;
	assign value = 0;
	assign cmd = 0;
	assign rready = 1;
	assign debug[0] = rvalid;
	assign debug[1] = rlast;
	assign debug[2] = tready;
	assign debug[3] = error;
	assign debug[4] = 0;
	assign rcvcnt = rlast;
	
//	Ethernet by Alex Forencich (GHz RGMII Ethernet MAC to the Digilent Genesys2 board)
	eth_mac_1g_rgmii_fifo #(
		.TARGET("XILINX"),
		.IODDR_STYLE("IODDR2"),
		.CLOCK_INPUT_STYLE("BUFIO2")
	) ethernet_phy (
		.gtx_clk(clk125),
		.gtx_clk90(clk125_90),
		.gtx_rst(reset),	// translate VME reset here
		.logic_clk(clk125),
		.logic_rst(reset),
	/*
	 * AXI input
	 */
		.tx_axis_tdata(tdata),
		.tx_axis_tvalid(tvalid),
		.tx_axis_tready(tready),
		.tx_axis_tlast(tlast),
		.tx_axis_tuser(tuser),
	/*
	 * AXI output
	 */
		.rx_axis_tdata(rdata),
		.rx_axis_tvalid(rvalid),
		.rx_axis_tready(rready),
		.rx_axis_tlast(rlast),
		.rx_axis_tuser(ruser),

	/*
	 * RGMII interface
	 */
		.rgmii_rx_clk(rgmii_rx_clk),
		.rgmii_rxd(rgmii_rxd),
		.rgmii_rx_ctl(rgmii_rx_ctl),
		.rgmii_tx_clk(rgmii_tx_clk),
		.rgmii_txd(rgmii_txd),
		.rgmii_tx_ctl(rgmii_tx_ctl),
		.mac_gmii_tx_en(mac_gmii_tx_en)
	);

endmodule
