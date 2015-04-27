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
//			0 - I->I 	internal trigger to channels
//			1 - I->FI	internal trigger to channels and front panel
//			2 - I->BI	internal trigger to channels and back panel
//			3 - I->FBI	internal trigger to channels, front and back panels
//			4 - F->I		front panel trigger to channels
//			5 - F->BI	front panel trigger to channels and back panel
//			6 - B->I		back panel trigger to channels
//			7 - B->FI	back panel trigger to channels and front panel
//		CSR[3]	 if 1, channels do not accept trigger
//		CSR[6:4]  defines connection of INH similarly to trigger connections
//		CSR[7]	 if 1, channels are insensitive to INH
//		CSR[10:8] defines connection of clocks similarly to trigger connections
//			in addition, programming of CDCUN required:
//			for modes 0-3 IN1 of CDCUN must be selected
//			for modes 4-7 IN2 of CDCUN must be selected
//		CSR[15:11]	 general purpose CSR outputs
//		CSR[30:16]	 user word to be put to trigger block written to memory	 
//		CSR[31] 		 peripheral WB reset
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
	 // reg outputs/inputs for general purposes
    output [4:0]		gen_o,
    input [31:0] 		gen_i,
	 // assigned outputs
	 output				pwb_rst,		// peripheral wishbone reset
	 output [14:0]		usr_word,	// user word to be put to trigger memory block
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
    output reg			ECLKSEL,
    output reg			OCLKSEL,
    output reg			CLKENFP,
    output reg			CLKENBP,
    output reg			CLKENBFP
    );
	 
	reg [31:0] csr;
	reg [31:0] reg_i;
	
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
	
	// inhibit propagation signals
	wire 	inh_from_FP;
	wire 	inh_to_FP;
	reg	inh_en_FP = 0;
	reg	inh_FP_sel = 0;
	wire 	inh_from_BP;
	wire 	inh_to_BP;
	reg	inh_en_BP = 0;
	reg	inh_BP_sel = 0;
	wire	inh_to_ICX;
	reg [1:0] inh_ICX_sel;

	assign gen_o = csr[15:11];
	assign pwb_rst = csr[31];
	assign usr_word = csr[30:16];

	// WB protocol
	assign wb_dat_o = (wb_adr) ? reg_i : csr;

	always @ (posedge wb_clk) begin
		wb_ack <= wb_cyc & wb_stb;
		if (wb_cyc & wb_stb & wb_we & (~wb_adr)) csr <= wb_dat_i;
		reg_i <= gen_i;
	end

	// Clock control
	always @ (posedge wb_clk) begin
		// default values are all zeroes, meaning no outputs are enabled
		ECLKSEL <= 0;
		OCLKSEL <= 0;
		CLKENFP <= 0;
		CLKENBP <= 0;
		CLKENBFP <= 0;
		case (csr[10:8])
      3'b000 : begin		// internal clock to ADC's, needs CDCUN select input 0
               end
      3'b001 : begin		// internal clock to ADC's and front panel, needs CDCUN select input 0
						CLKENFP <= 1;
               end
      3'b010 : begin		// internal clock to ADC's and back panel, needs CDCUN select input 0
						CLKENBP <= 1;
               end
      3'b011 : begin		// internal clock to ADC's, front and back panel, needs CDCUN select input 0
						CLKENFP <= 1;
						CLKENBP <= 1;
               end
      3'b100 : begin		// front panel clock to ADC's, needs CDCUN select input 1
               end
      3'b101 : begin		// front panel clock to ADC's and back panel, needs CDCUN select input 1
                  OCLKSEL <= 1;
						CLKENBP <= 1;
               end
      3'b110 : begin		// back panel clock to ADC's, needs CDCUN select input 1
						ECLKSEL <= 1;
               end
      3'b111 : begin		// back panel clock to ADC's and front panel, needs CDCUN select input 1
						ECLKSEL <= 1;
						CLKENBFP <= 1;
               end
		endcase
	end

	// Trigger propagation
	
	// Front panel input is always terminated
   IOBUFDS #(
      .DIFF_TERM("TRUE"),   	  // Differential Termination
      .IOSTANDARD("LVDS_25")    // Specify the I/O standard
   ) trig_fp (
      .O(trig_from_FP),    // Buffer output
      .IO(trig_FP[0]),   	// Diff_p inout (connect directly to top-level port)
      .IOB(trig_FP[1]), 	// Diff_n inout (connect directly to top-level port)
      .I(trig_to_FP),      // Buffer input
      .T(trig_en_FP)       // 3-state enable input, high=input, low=output
   );
	
   // Back panel input should be terminated only in the module last in crate
	IOBUFDS #(
`ifdef TERM_TRIG_BP
      .DIFF_TERM("TRUE"),   	  // Differential Termination
`else
      .DIFF_TERM("FALSE"),   	  // Differential Termination
`endif
      .IOSTANDARD("BLVDS_25")   // Specify the I/O standard
   ) trig_bp (
      .O(trig_from_BP),    // Buffer output
      .IO(trig_BP[0]),   	// Diff_p inout (connect directly to top-level port)
      .IOB(trig_BP[1]), 	// Diff_n inout (connect directly to top-level port)
      .I(trig_to_BP),      // Buffer input
      .T(trig_en_BP)       // 3-state enable input, high=input, low=output
   );
	
	// no differential outputs on bank 3
	assign trig_ICX[0] = trig_to_ICX;
	assign trig_ICX[1] = ~trig_to_ICX;

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
		// front and back panel transmitters are disabled by default
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
		if (csr[3]) trig_ICX_sel <= 3;	// disable trigger to X's
	end

	// INH propagation
	
	// Front panel input is always terminated
   IOBUFDS #(
      .DIFF_TERM("TRUE"),   	  // Differential Termination
      .IOSTANDARD("LVDS_25")    // Specify the I/O standard
   ) inh_fp (
      .O(inh_from_FP),    // Buffer output
      .IO(inh_FP[0]),   	// Diff_p inout (connect directly to top-level port)
      .IOB(inh_FP[1]), 	// Diff_n inout (connect directly to top-level port)
      .I(inh_to_FP),      // Buffer input
      .T(inh_en_FP)       // 3-state enable input, high=input, low=output
   );
	
   // Back panel input should be terminated only in the module last in crate
	IOBUFDS #(
`ifdef TERM_INH_BP
      .DIFF_TERM("TRUE"),   	  // Differential Termination
`else
      .DIFF_TERM("FALSE"),   	  // Differential Termination
`endif
      .IOSTANDARD("BLVDS_25")   // Specify the I/O standard
   ) inh_bp (
      .O(inh_from_BP),    // Buffer output
      .IO(inh_BP[0]),   	// Diff_p inout (connect directly to top-level port)
      .IOB(inh_BP[1]), 	// Diff_n inout (connect directly to top-level port)
      .I(inh_to_BP),      // Buffer input
      .T(inh_en_BP)       // 3-state enable input, high=input, low=output
   );
	
	// onboard INH is single ended
	assign inh_ICX = inh_to_ICX;

	cmux21 inh_fp_sel(
    .I0	(inh),
    .I1	(inh_from_BP),
    .S	(inh_FP_sel),
    .O	(inh_to_FP)
    );

	cmux21 inh_bp_sel(
    .I0	(inh),
    .I1	(inh_from_FP),
    .S	(inh_BP_sel),
    .O	(inh_to_BP)
    );
	 
	cmux41 inh_icx_sel(
    .I0	(inh),
    .I1	(inh_from_FP),
    .I2	(inh_from_BP),
	 .I3	(1'b0),
    .S	(inh_ICX_sel),
    .O	(inh_to_ICX)
    );

	always @ (posedge wb_clk) begin
		// front and back panel transmitters are disabled by default
		inh_en_FP <= 0;
		inh_en_BP <= 0;
		case (csr[6:4])
      3'b000 : begin		// internal inh to X's
                  inh_ICX_sel <= 0;
               end
      3'b001 : begin		// internal inh to X's and front panel
                  inh_ICX_sel <= 0;
						inh_FP_sel <= 0;
						inh_en_FP <= 1;
               end
      3'b010 : begin		// internal inh to X's and back panel
                  inh_ICX_sel <= 0;
						inh_BP_sel <= 0;
						inh_en_BP <= 1;
               end
      3'b011 : begin		// internal inh to X's, back and front panel
                  inh_ICX_sel <= 0;
						inh_FP_sel <= 0;
						inh_en_FP <= 1;
						inh_BP_sel <= 0;
						inh_en_BP <= 1;
               end
      3'b100 : begin		// front panel inh to X's
                  inh_ICX_sel <= 1;
               end
      3'b101 : begin		// front panel inh to X's and back panel
                  inh_ICX_sel <= 1;
						inh_BP_sel <= 1;
						inh_en_BP <= 1;
               end
      3'b110 : begin		// back panel inh to X's
                  inh_ICX_sel <= 2;
               end
      3'b111 : begin		// back panel inh to X's and front panel
                  inh_ICX_sel <= 2;
						inh_FP_sel <= 1;
						inh_en_FP <= 1;
               end
		endcase
		if (csr[7]) inh_ICX_sel <= 3;	// X's are insensitive to INH
	end

endmodule
