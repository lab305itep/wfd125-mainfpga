`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:17:13 11/08/2025
// Design Name:   ethctl
// Module Name:   /home/igor/proj/wfd125/wfd125-mainfpga/ethctl_test.v
// Project Name:  fpga_main
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ethctl
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ethctl_test;

	// Inputs
	reg [31:0] wb_dat_i;
	reg wb_we;
	reg wb_clk;
	reg wb_cyc;
	reg wb_stb;
	reg [1:0] wb_adr;
	reg wb_rst;
	reg phyint;
	reg blkcnt;
	reg errcnt;

	// Outputs
	wire [31:0] wb_dat_o;
	wire wb_ack;
	wire phymdc;
	wire phyrst;

	// Bidirs
	wire phymdio;

	// Instantiate the Unit Under Test (UUT)
	ethctl uut (
		.wb_dat_i(wb_dat_i), 
		.wb_dat_o(wb_dat_o), 
		.wb_we(wb_we), 
		.wb_clk(wb_clk), 
		.wb_cyc(wb_cyc), 
		.wb_ack(wb_ack), 
		.wb_stb(wb_stb), 
		.wb_adr(wb_adr), 
		.wb_rst(wb_rst), 
		.phymdio(phymdio), 
		.phymdc(phymdc), 
		.phyint(phyint), 
		.phyrst(phyrst), 
		.blkcnt(blkcnt), 
		.errcnt(errcnt)
	);

	always begin
		wb_clk = 1'b0;
		#5 wb_clk = 1'b1;
		#5;
	end 

	initial begin
		// Initialize Inputs
		wb_dat_i = 0;
		wb_we = 0;
		wb_clk = 0;
		wb_cyc = 0;
		wb_stb = 0;
		wb_adr = 0;
		wb_rst = 1;
		phyint = 0;
		blkcnt = 0;
		errcnt = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		wb_rst = 0;
		wb_dat_i = 32'h80000000;
		#20;
		wb_we = 1;
		wb_cyc = 1;
		wb_stb = 1;
		#20;
		wb_we = 0;
		wb_cyc = 0;
		wb_stb = 0;
		#1000;
		wb_dat_i = 32'h420000;
		wb_adr = 1;
		#20
		wb_we = 1;
		wb_cyc = 1;
		wb_stb = 1;
		#20;
		wb_we = 0;
		wb_cyc = 0;
		wb_stb = 0;
		
		forever #100;

	end
      
endmodule

