`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:			 ITEP 
// Engineer: 		 SvirLex
// 
// Create Date:    19:59:41 09/26/2014 
// Design Name: 	 fpga_main
// Module Name:    csreg 
// Project Name: 	 wfd125
// Target Devices: s6
// Revision 0.01 - File Created
// Additional Comments: 
//		This is a CSR regiter, with main purpose to make commutations between
//		CSR[2:0]  defines connection of trigger:
//		CSR[3]	 unused
//		CSR[6:4]  defines connection of INH:
//		CSR[7]	 unused
//		CSR[10:8] defines connection of clocks together with programming of CDCUN
//		CSR[11]	 unused
//		CSR[31:12]	are general outputs to the upper hierarchy, CSR[31] is used for peripheral WB reset
//		CSR+4 [31:0] are general inputs from the upper hierarchy, unused so far
//
//////////////////////////////////////////////////////////////////////////////////
module csreg(
	// WB signals
    input [31:0] wb_dat_i,
    output [31:0] wb_dat_o,
    input wb_we,
    input wb_clk,
    input wb_cyc,
    output reg wb_ack,
    input wb_stb,
	 input wb_adr,
	 // reg outputs for other purposes
    output [19:0]		gen_o,
    input [31:0] 		gen_i,
	 // inputs from triggen
	 input				trig,
	 input				inh,
	 // front panel signals
	 inout [1:0] 		trig_FP,
	 inout [1:0] 		inh_FP,
	 // back panel signals
	 inout [1:0] 		trig_BP,
	 inout [1:0]		inh_BP,
	 // signals to peripheral X's
	 output [1:0]		trig_ICX,
	 output				inh_ICX,
	 // outputs to drive CLK muxes
    output 				ECLKSEL,
    output 				OCLKSEL,
    output 				CLKENFP,
    output 				CLKENBP,
    output 				CLKENBFP
    );
	 
// so far
   assign ECLKSEL = 1'bz;
   assign OCLKSEL = 1'bz;
   assign CLKENFP = 1'bz;
   assign CLKENBP = 1'bz;
   assign CLKENBFP = 1'bz;

	reg [31:0] csr;
	reg [31:0] reg_i;
	assign wb_dat_o = (wb_adr) ? csr : reg_i;
	assign gen_o = csr[31:12];
	
	// trigger propagation signals
	wire 	trig_from_FP;
	wire 	trig_to_FP;
	reg	trig_en_FP = 0;
	reg	trig_FP_sel = 0;
	wire 	trig_from_BP;
	wire 	trig_to_BP;
	reg	trig_en_BP = 0;
	reg	trig_BP_sel = 0;
	wire	trig_to_ICX;
	reg [1:0] trig_ICX_sel;
	
	// WB protocol
	always @ (posedge wb_clk) begin
		wb_ack <= wb_cyc & wb_stb;
		if (wb_cyc & wb_stb & wb_we & wb_adr) csr <= wb_dat_i;
		reg_i <= gen_i;
	end

	// Trigger propagation
   IOBUFDS #(
      .IOSTANDARD("LVDS_33")    // Specify the I/O standard
   ) trig_fp (
      .O(trig_from_FP),    // Buffer output
      .IO(trig_FP[0]),   	// Diff_p inout (connect directly to top-level port)
      .IOB(trig_FP[1]), 	// Diff_n inout (connect directly to top-level port)
      .I(trig_to_FP),      // Buffer input
      .T(trig_en_FP)       // 3-state enable input, high=input, low=output
   );
	
   IOBUFDS #(
      .IOSTANDARD("LVDS_33")    // Specify the I/O standard
   ) trig_bp (
      .O(trig_from_BP),    // Buffer output
      .IO(trig_BP[0]),   	// Diff_p inout (connect directly to top-level port)
      .IOB(trig_BP[1]), 	// Diff_n inout (connect directly to top-level port)
      .I(trig_to_BP),      // Buffer input
      .T(trig_en_BP)       // 3-state enable input, high=input, low=output
   );
	
   OBUFDS #(
      .IOSTANDARD("LVDS_33") // Specify the output I/O standard
   ) trig_icx (
      .O(trig_ICX[0]),     // Diff_p output (connect directly to top-level port)
      .OB(trig_ICX[1]),    // Diff_n output (connect directly to top-level port)
      .I(trig_to_ICX)      // Buffer input 
   );

	cmux21 trig_fp_sel(
    .I0	(trig),
    .I1	(trig_from_BP),
    .S	(trig_FP_sel),
    .O	(trig_to_FP)
    );

	cmux21 trig_bp_sel(
    .I0	(trig),
    .I1	(trig_from_FP),
    .S	(trig_BP_sel),
    .O	(trig_to_BP)
    );
	 
	cmux41 trig_icx_sel(
    .I0	(trig),
    .I1	(trig_from_FP),
    .I2	(trig_from_BP),
	 .I3	(1'b0),
    .S	(trig_ICX_sel),
    .O	(trig_to_ICX)
    );

	
	always @ (posedge wb_clk) begin
		// bront and back panel transmitters are disabled by default
		trig_en_FP <= 0;
		trig_en_BP <= 0;
		case (csr[2:0])
      3'b000 : begin		// internal trig to X's
                  trig_ICX_sel <= 0;
               end
      3'b001 : begin		// internal trig to X's and front panel
                  trig_ICX_sel <= 0;
						trig_FP_sel <= 0;
						trig_en_FP <= 1;
               end
      3'b010 : begin		// internal trig to X's and back panel
                  trig_ICX_sel <= 0;
						trig_BP_sel <= 0;
						trig_en_BP <= 1;
               end
      3'b011 : begin		// internal trig to X's, back and front panel
                  trig_ICX_sel <= 0;
						trig_FP_sel <= 0;
						trig_en_FP <= 1;
						trig_BP_sel <= 0;
						trig_en_BP <= 1;
               end
      3'b100 : begin		// front panel trig to X's
                  trig_ICX_sel <= 1;
               end
      3'b101 : begin		// front panel trig to X's and back panel
                  trig_ICX_sel <= 1;
						trig_BP_sel <= 1;
						trig_en_BP <= 1;
               end
      3'b110 : begin		// back panel trig to X's
                  trig_ICX_sel <= 2;
               end
      3'b111 : begin		// back panel trig to X's and front panel
                  trig_ICX_sel <= 2;
						trig_FP_sel <= 1;
						trig_en_FP <= 1;
               end
		endcase

	end

endmodule
