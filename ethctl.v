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
//
//////////////////////////////////////////////////////////////////////////////////
module ethctl(
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
//		Counters
	input blkcnt,
	input errcnt
);
	reg [31:0] CSR;
	reg [31:0] regB;
	reg [31:0] regC;
	reg [31:0] regD;
	
	assign phymdio = 1'bz;
	assign phymdc = 0;
	assign phyrst = CSR[31];
	
	always @(wb_adr, regA, regB, regC, regD)
	case (wb_adr)
		2'b00: wb_dat_o = CSR;
		2'b01: wb_dat_o = regB;
		2'b10: wb_dat_o = regC;
		2'b11: wb_dat_o = regD;
	endcase
	
	always @ (posedge wb_clk) begin
		wb_ack <= #1 wb_cyc & wb_stb;
		if (wb_rst) begin
			CSR = 0;
		end else if (wb_cyc & wb_stb & wb_we) begin
			case (wb_adr)
				2'b00: CSR = wb_dat_i;
				2'b01: regB = wb_dat_i;
				2'b10: regC = wb_dat_i;
				2'b11: regD = wb_dat_i;
			endcase
		end
	end
	
endmodule
