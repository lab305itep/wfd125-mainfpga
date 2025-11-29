`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: ITEP
// Engineer: SvirLex
//
// Create Date:   23:05:18 11/29/2025
// Design Name:   gtpfifo
// Module Name:   /home/igor/proj/wfd125/wfd125-mainfpga/fifo_test.v
// Project Name:  fpga_main
// Target Device:  XC6SLX45T
// Tool versions:  
// Description: Test FIFO 
//
// Verilog Test Fixture created by ISE for module: gtpfifo
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module fifo_test;

	// Inputs
	reg gtp_clk = 0;
	reg [15:0] gtp_dat = 0;
	reg gtp_vld = 0;
	reg rst = 1;
	reg give = 0;
	reg getting = 0;
	reg arbcycle = 0;
	integer arbcnt = 0;

	// Outputs
	wire [31:0] data;
	wire have;
	wire empty;
	wire err_ovr;
	wire err_undr;
	wire missed;

	// Instantiate the Unit Under Test (UUT)
	gtpfifo uut (
		.gtp_clk(gtp_clk), 
		.gtp_dat(gtp_dat), 
		.gtp_vld(gtp_vld), 
		.rst(rst), 
		.give(give), 
		.data(data), 
		.have(have), 
		.empty(empty), 
		.err_ovr(err_ovr), 
		.err_undr(err_undr), 
		.missed(missed)
	);
	
	always begin
		gtp_clk = 1'b0;
		#4 gtp_clk = 1'b1;
		#4;
	end 
	
	always @ (posedge gtp_clk) begin
		if (arbcnt < 20) begin
			arbcnt <= arbcnt + 1;
			arbcycle <= 0;
		end else begin
			arbcnt <= 0;
			arbcycle <= 1;
		end
	end

	always @ (posedge gtp_clk) begin
		give <= 0;
		if (have && getting) begin
			give <= 1;
		end else if (arbcycle && !getting) begin
			give <= 1;
		end else if (!getting && have) begin
			getting <= 1;
			give <= 1;
		end else if (getting && !have) begin
			getting <= 0;
		end 
	end

	initial begin
		// Initialize Inputs
		gtp_dat = 0;
		gtp_vld = 0;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#100;

		// Add stimulus here
		rst <= 0;
		#100;
		
		repeat (100) begin
			@(posedge gtp_clk);
			gtp_vld <= 1;
			gtp_dat <= 16'h8804;
			@(posedge gtp_clk);
			gtp_vld <= 1;
			gtp_dat <= 16'h0555;
			@(posedge gtp_clk);
			gtp_vld <= 1;
			gtp_dat <= 16'h1AAA;
			@(posedge gtp_clk);
			gtp_vld <= 1;
			gtp_dat <= 16'h2BBB;
			@(posedge gtp_clk);
			gtp_vld <= 1;
			gtp_dat <= 16'h3CCC;
			repeat (50) begin
				@(posedge gtp_clk);
				gtp_vld <= 0;
			end
		end 
	end
      
endmodule

