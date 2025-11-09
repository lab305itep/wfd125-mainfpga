`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: ITEP
// Engineer: SvirLex
//
// Create Date:   17:41:58 11/09/2025
// Design Name:   ethernet
// Module Name:   /home/igor/proj/wfd125/wfd125-mainfpga/ethernet_test.v
// Project Name:  fpga_main
// Target Device:  XC6SLX45T
// Tool versions:  
// Description:    Test ethernet mac-phy
//
// Verilog Test Fixture created by ISE for module: ethernet
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ethernet_test;

	// Inputs
	reg clk125;
	reg clk125_90;
	reg reset;
	reg [31:0] txd;
	reg txvld;
	reg txend;
	reg ready4cmd;
	reg rgmii_rx_clk;
	reg [3:0] rgmii_rxd;
	reg rgmii_rx_ctl;
	reg [7:0] d;
	reg [47:0] MAC;

	// Outputs
	wire error;
	wire rcvcnt;
	wire [4:0] debug;
	wire txready;
	wire [31:0] address;
	wire [31:0] value;
	wire [2:0] cmd;
	wire rgmii_tx_clk;
	wire [3:0] rgmii_txd;
	wire rgmii_tx_ctl;
	wire mac_gmii_tx_en;

	// Instantiate the Unit Under Test (UUT)
	ethernet uut (
		.clk125(clk125), 
		.clk125_90(clk125_90), 
		.reset(reset), 
		.error(error), 
		.rcvcnt(rcvcnt), 
		.debug(debug), 
		.MAC(MAC),
		.txd(txd), 
		.txvld(txvld), 
		.txend(txend), 
		.txready(txready), 
		.address(address), 
		.value(value), 
		.cmd(cmd), 
		.ready4cmd(ready4cmd), 
		.rgmii_rx_clk(rgmii_rx_clk), 
		.rgmii_rxd(rgmii_rxd), 
		.rgmii_rx_ctl(rgmii_rx_ctl), 
		.rgmii_tx_clk(rgmii_tx_clk), 
		.rgmii_txd(rgmii_txd), 
		.rgmii_tx_ctl(rgmii_tx_ctl), 
		.mac_gmii_tx_en(mac_gmii_tx_en)
	);

	always begin
		clk125 = 0;
		clk125_90 = 0;
		#2;
		clk125 = 0;
		clk125_90 = 1;
		#2;
		clk125 = 1;
		clk125_90 = 1;
		#2;
		clk125 = 1;
		clk125_90 = 0;
		#2;
	end
	
	always begin
		rgmii_rx_clk = 0;
		#3;
		rgmii_rx_clk = 1;
		#4;
		rgmii_rx_clk = 0;
		#1;
	end

	initial begin
		// Initialize Inputs
		d = 0;
		reset = 1;
		txd = 0;
		txvld = 0;
		txend = 0;
		ready4cmd = 0;
		rgmii_rxd = 0;
		rgmii_rx_ctl = 0;
		MAC = 48'h803755004318;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		reset = 0;
		ready4cmd = 1;
		#100;
		repeat (10) begin
			d = 8'h55;
			repeat (7) begin
				@(negedge rgmii_rx_clk) begin 
					rgmii_rx_ctl = 1;
					rgmii_rxd <= d[3:0];
				end
				@(posedge rgmii_rx_clk) begin 
					rgmii_rx_ctl = 1;
					rgmii_rxd <= d[7:4];
				end
			end
			d = 8'hD5;
			@(negedge rgmii_rx_clk) begin 
				rgmii_rx_ctl = 1;
				rgmii_rxd <= d[3:0];
			end
			@(posedge rgmii_rx_clk) begin 
				rgmii_rx_ctl = 1;
				rgmii_rxd <= d[7:4];
			end
			d = 128;
			repeat (12) begin
				@(negedge rgmii_rx_clk) begin 
					rgmii_rx_ctl = 1;
					rgmii_rxd <= d[3:0];
				end
				@(posedge rgmii_rx_clk) begin 
					rgmii_rx_ctl = 1;
					rgmii_rxd <= d[7:4];
				end
				d = d + 1;
			end
			d = 8'h8;
			@(negedge rgmii_rx_clk) begin 
				rgmii_rx_ctl = 1;
				rgmii_rxd <= d[3:0];
			end
			@(posedge rgmii_rx_clk) begin 
				rgmii_rx_ctl = 1;
				rgmii_rxd <= d[7:4];
			end
			d = 8'h0;
			@(negedge rgmii_rx_clk) begin 
				rgmii_rx_ctl = 1;
				rgmii_rxd <= d[3:0];
			end
			@(posedge rgmii_rx_clk) begin 
				rgmii_rx_ctl = 1;
				rgmii_rxd <= d[7:4];
			end
			d = 0;
			repeat (100) begin
				@(negedge rgmii_rx_clk) begin 
					rgmii_rx_ctl = 1;
					rgmii_rxd <= d[3:0];
				end
				@(posedge rgmii_rx_clk) begin 
					rgmii_rx_ctl = 1;
					rgmii_rxd <= d[7:4];
				end
				d = d + 1;
			end
			d = 8'hFF;
			repeat (12) begin
				@(negedge rgmii_rx_clk) begin 
					rgmii_rx_ctl = 0;
					rgmii_rxd <= d[3:0];
				end
				@(posedge rgmii_rx_clk) begin 
					rgmii_rx_ctl = 0;
					rgmii_rxd <= d[7:4];
				end
			end
			repeat (200) begin
				@(negedge rgmii_rx_clk) begin 
					rgmii_rx_ctl = 0;
					rgmii_rxd <= 0;
				end
			end
		end
	end
//	forever #100;

endmodule
