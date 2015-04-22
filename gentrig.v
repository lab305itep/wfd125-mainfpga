`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 		ITEP
// Engineer: 		SvirLex
// 
// Create Date:    01:18:39 apr-2015 
// Design Name: 	 fpga_main
// Module Name:    gentrig 
// Project Name: 	 wfd125
// Target Devices: s6
// Revision 0.01 - File Created
// Additional Comments: 
//		Makes trigger from chan FPGA coming triggers, or soft trigger.
//		Puts trgger block to memory. Issues trigger with sequential token for the whole system.
//		Controls system wide INH. Counts global time, triggers, missed triggers.
//
//		Serial trigger is 14 bit as minimum and sent LSB first at bit frequency gpt_clk/TOKEN_CLKDIV :
//		0 pnnn nnnn nnnn 1
//		1 start bit, n - 11-bit token (lower trigger number), p - parity = NOT (xor n), 0 - stop bit
//
//		Registers:
//		0 CSR (RW):
//			3:0   - corrsponding chan FPGA trigger enable
//			15:4  - trigger block time (125MHz ticks), actual blocking time 
//						cannot be less than token transmission time
//			30:16 - user word to be put to the trigger block to memory
//			31		- inhibit, set on power on
//		1 TRGCNT	(R) :
//			counts issued master triggers when not inhibited, 11 LSB are used as trigger token
//			any write to this register produced master soft trigger
//		2 MISCNT	(R) :
//			counts triggers that appear during blocking time (when not inhibited)
//		3 GTIME	(R) :
//			middle bits of 45 bit global 125 MHz time counter. One time unit is 1.024 us.
//			Counting paused on active inhibit
//			Any write to GTIME or MISCNT cases reset of all 3 counters
//
//		Block sent to memory fifo
//		0	10SC CCCL LLLL LLLL - S - soft trigger, CCCC - channel mask which produced the trigger, 
//										 L - data length in 16-bit words not including CW 
// 	1	0ttt pnnn nnnn nnnn - ttt - trigger block type (3'b010 = 2 - trigger info block)
//										 n - 11-bit trigger token = trigger number LSB, p - token parity = NOT (xor n)
//		2	0uuu uuuu uuuu uuuu - user word
//		3	0 GTIME[14:0]		  - lower GTIME
//		4	0 GTIME[29:15]		  - middle GTIME
//		5	0 GTIME[44:30]		  - higher GTIME
//
//////////////////////////////////////////////////////////////////////////////////

module gentrig # (
		parameter			TOKEN_CLKDIV = 4,
		parameter			TRIG_SPREAD = 4
)
(
		// GTP reciever data and k-char info
		input 				gtp_clk,
		input [63:0] 		gtp_dat,
		input [3:0] 		kchar,
		// intrface to memory fifo
		output reg [15:0]	trg_dat,
		output reg			trg_vld,
		// WB signals
		input 				wb_clk,
		input 				wb_rst,
		input 				wb_cyc,
		input 				wb_stb,
		input [1:0]			wb_adr,
		input 				wb_we,
		output reg 			wb_ack,
		input [31:0] 		wb_dat_i,
		output reg [31:0]	wb_dat_o,
		// trigger and inhibit
		output reg			trigger,
		output reg			inhibit
   );

	localparam	CH_COMMA = 16'h00BC;		// comma K28.5
	localparam  CH_TRIG  = 16'h801C;		// K-character K28.0

	reg [31:0] 	CSR = 32'h80000000;		// inhibit is set on power on
	reg [31:0] 	TRGCNT = 0;
	reg [31:0] 	MISCNT = 0;
	reg [44:0] 	GTIME = 0;
	reg 			cnt_reset = 0;
	reg 			soft_trig = 0;
	reg [2:0]	rd_sel = 0;
	reg			rd_rdy = 0;
	reg [31:0]	cnt_dat = 0;
	
	integer j;
	wire [3:0]  STRG = 0;
	wire			blk;				// sum of all blocking signals

	reg [13:0]	ser_trg = 0;
	reg [3:0]	ser_cnt = 0;
	reg [3:0]	ser_div = 0;

	// Inhibit and trigger outputs
	assign inhibit = CSR[31];
	assign trigger = ser_trg[0];
	
	// Make trigger signals from channels
	genvar i;
	generate
		for (i=0; i<4; i=i+1) begin: USTRG
			assign STRG[i] = CSR[i] & kchar[i] & (gtp_dat[16*i+15:16*i] == CH_TRIG);
		end	
	endgenerate
	
	assign blk = (|ser_cnt);		// and more

//		WishBone, assuming that WB clock is not faster than gtp_clk
//		i.e. 1 wb_clk signals will always be seen at gtp_clk
	always @ (posedge wb_clk) begin
		cnt_reset <= 0;
		soft_trig <= 0;
		wb_ack <= 0;
		if (wb_rst) begin
			cnt_reset <= 1;
			rd_sel <= 0;
		end else begin
			if (wb_cyc & wb_stb) begin
				if (wb_we) begin
					// writes, acknowledge immediately
					wb_ack <= 1;
					case (wb_adr)
						2'b00: begin
							CSR <= wb_dat_i;
						end
						2'b01: begin
							soft_trig <= 1;
						end
						2'b10: begin
							cnt_reset <= 1;
						end
						2'b11: begin
							cnt_reset <= 1;
						end
					endcase
				end else begin
					// reads
					if (wb_adr == 0) begin
						// present and ack CSR immediately
						wb_dat_o <= CSR;
						wb_ack <= 1;
					end else begin
						// initiate counters read
						for (j=1; j<4; j=j+1) if (wb_adr == j) rd_sel[j-1] <= 1;
					end
				end
			end	// wb_cyc & wb_stb
			if (rd_rdy) begin
				// counters latched
				rd_sel <= 0;		// clear latch req
				if (|rd_sel) begin 
					wb_dat_o <= cnt_dat;
					wb_ack <= 1;	// ack only once
				end
			end
		end	// not WB reset
	end	// posedge wb_clk

	always @ (posedge gtp_clk) begin
		// Sending trigger token (immediately on first appearing trigger from channels)
		if ((((|STRIG) & ~CSR[31]) | soft_trig) & ~blk) begin
			// start sending token on first trig in group if not inhibited or soft trigger
			ser_trg <= {1'b0, TRGCNT[10:0], 1'b1};
			ser_div <= TOKEN_CLKDIV - 1;
			ser_cnt <= 14;
		end else begin
			if (|ser_div) begin
				ser_div <= ser_div - 1;
			end else begin
				ser_div <= TOKEN_CLKDIV - 1;
				ser_trg <= {1'b0, ser_trg[13:1]};
				if (|ser_cnt) ser_cnt <= ser_cnt - 1;
			end
		end
		
		// Sending trigger block to memory fifo
		
		// count time
		if (~CSR[31]) begin
			GTIME <= GTIME + 1;
		end
		// latch counters for reading
		case (rd_sel)
			3'b001: begin
				cnt_dat <= TRGCNT;
				rd_rdy <= 1;
			end
			3'b010: begin
				cnt_dat <= MISCNT;
				rd_rdy <= 1;
			end
			3'b100: begin
				cnt_dat <= GTIME[22:7];
				rd_rdy <= 1;
			end
			default: begin
				rd_rdy <= 0;
			end
		endcase
		// reset counters
		if (cnt_reset) begin
			TRGCNT <= 0;
			MISCNT <= 0;
			GTIME <= 0;
		end
	end	// posedge gtp_clk

endmodule
