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
//			6:4	- 1 + time in clocks to accumulate OR of all trigger sources
//			15:7  - 1 + trigger blocking time (125MHz ticks), actual blocking time 
//						cannot be less than token transmission time 14*TOKEN_CLKDIV clocks
//			28:16 - period in ms of the soft trigger generation, zero value means no periodical soft trigger, not generated on INH
//			29    - auxillary trigger input enable
//			30    - enable trigger info blocks (type = 2) to be sent to FIFO
//			31		- inhibit, set on power on
//		1 TRGCNT	(R) :
//			counts issued master triggers when not inhibited, 11 LSB are used as trigger token
//			any write to this register produces master soft trigger, independently on INH
//		2 MISCNT	(R) :
//			counts triggers that appear during blocking time (when not inhibited)
//		3 GTIME	(R) :
//			middle bits of 45 bit global 125 MHz time counter. One time unit is 1.024 us.
//			Counting paused on active inhibit
//			Any write to GTIME or MISCNT cases reset of all 3 counters
//
//		Block sent to memory fifo
//		0	1PSC CCCL LLLL LLLL - S - soft trigger, P - periodical trigger, CCCC - channel mask which produced the trigger, 
//										 L=7 - data length in 16-bit words not including CW 
// 	1	0ttt penn nnnn nnnn - ttt - trigger block type (3'b010 = 2 - trigger info block)
//										 n - 10-bit trigger token = trigger number LSB, e - token error (always zero here)
//										 p - block sequential number LSB, for trigger block = trigger number LSB
//		2	0uuu uuuu uuuu uuuu - user word
//		3	0 GTIME[14:0]		  - lower GTIME
//		4	0 GTIME[29:15]		  - middle GTIME
//		5	0 GTIME[44:30]		  - higher GTIME
//		6  0 TRIGCNT[14:0]	  - lower trigger counter, 11 LSB coinside with token
//		7  0 TRIGCNT[29:15]	  - higher trigger counter
//
//////////////////////////////////////////////////////////////////////////////////

module gentrig # (
		parameter			TOKEN_CLKDIV = 4,			// (>= 4, <= 16)
		parameter			TOKEN_LENGTH = 10			//	only token itself (<= 10), transmission will also include start/stop and par
)
(
		// GTP reciever data and k-char info
		input 				gtp_clk,
		input [63:0] 		gtp_dat,
		input [3:0] 		kchar,
		input             auxtrig,
		// intrface to memory fifo
		output reg [15:0]	trg_dat,
		output reg			trg_vld,
		// user word from CSR
		input [14:0] 		usr_word,
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
		output 				trigger,
		output 				inhibit
   );

	localparam	CH_COMMA = 16'h00BC;		// comma K28.5
	localparam  CH_TRIG  = 16'h801C;		// K-character K28.0
	localparam  MEM_WORDS  = 8;			// TRIG: number of words sent to memory FIFO (<=14)
	wire [8:0]	MEM_LEN = MEM_WORDS-1;	// TRIG: length of fifo block in CW
	localparam  CMEM_WORDS  = 9;			// CYCLE: number of words sent to memory FIFO  (<=14)
	wire [8:0]	CMEM_LEN = CMEM_WORDS-1;	// CYCLE: length of fifo block in CW

	reg [31:0] 	CSR = 32'h80000000;		// inhibit is set on power on
	reg [31:0] 	TRGCNT = 0;					// master triggers counter
	reg [31:0] 	MISCNT = 0;					// triggers missed because of blocking
	reg [44:0] 	GTIME = 0;					// global system time
	reg [44:0] 	GTIMES = 0;					// global system time
	reg [31:0] 	CYCCNT = 0;					// cycles, initated by long aux trigger
	
	reg 		cnt_reset = 0;				// counters reset
	reg 		soft_trig = 0;				// soft trigger
	reg			st_req = 0;					// soft trigger request from WB
	reg			st_done = 0;				// soft trigger ack
	reg [2:0]	rd_sel = 0;					//	prepare counters for readout through WB
	reg			rd_rdy = 0;					// selected counter ready for readout
	reg [31:0]	cnt_dat = 0;				// selected counter data for readout
	
	integer j;
	reg [3:0]	CTRG = 0;						// current mask of triggers from channel sources, if enabled and not inhibited
	reg			ATRG = 0;						// AUX trig masked

	reg [2:0]	aux_trig_d = 0;				// for detection of aux trigger
	reg			auxlong = 0;					// long aux = cycle
	reg [9:0]	auxlong_cnt;					// cycle = aux active for 8 us 
	reg			cycle = 0;					// cycle 1 CLK pulse after 8 us aux detected

	reg [TOKEN_LENGTH+2:0]	ser_trg = 0;	// shift reg for serial token, 3 bits longer than token length
	reg [3:0]	ser_cnt = 0;	// counter of transmitted token bits
	reg [3:0]	ser_div = 0;	// conter of frq divider for token transmission
	reg [4:0]	mem_cnt = 0;	// counter for words transmitted to memory
	reg [4:0]	cmem_cnt = 0;	// counter for cycle words transmitted to memory
	reg [6:0]	or_trg = 0;		//	to accumulate triggers from different sources
	reg [2:0]	or_cnt = 0;		// to count time to accumulate triggers from different sources
	wire [10:0]	tok_mem;			// 11-bit token part of fifo block (strictly 11 bit)
	reg [10:0]	tok_mem_store;		// 11-bit token part of fifo block (strictly 11 bit), stored at trigger block write
	reg [8:0]	blk_cnt = 0;	// blocking time count
	wire		blk;				// sum of all blocking signals
	wire		missed_sense;	// if 1, we are sensitive to missed triggers
	wire		ms_p;				// about 1 ms single clk pulse
	reg			per_trig = 0;	// periodical soft trigger
	reg [13:0]	per_cnt = 0;	// periodical soft trigger period counter
	wire 		any_trig;		// or of all reigger sources
	reg			trg_block_enable = 0;	// enable sending trigger block to FIFO

	// Inhibit and trigger outputs
	assign inhibit = CSR[31];
	assign trigger = ser_trg[0];
	
	// trigger blocking
	assign blk = (|ser_cnt) | (|mem_cnt) | (|blk_cnt) | auxlong | (|cmem_cnt);
	// missed sensitivity
	assign missed_senese = blk & (mem_cnt < (MEM_WORDS+1));
	// token to memory (no error, will be padded to 11 bits)
	assign tok_mem = {1'b0, TRGCNT[TOKEN_LENGTH-1:0]};
	// millisecond pulse
	assign ms_p = (&GTIME[16:0]) & ~CSR[31];
	// trigger OR
	assign any_trig = (|CTRG) | soft_trig | per_trig | ATRG;
	
	// Make trigger signals from channels
//	genvar i;
//	generate
//		for (i=0; i<4; i=i+1) begin: UCTRG
//			assign CTRG[i] = ~CSR[31] & CSR[i] & kchar[i] & (gtp_dat[16*i+15:16*i] == CH_TRIG);
//		end	
//	endgenerate

//		WishBone, assuming that WB clock is not faster than gtp_clk
//		i.e. 1 wb_clk signals will always be seen at gtp_clk
	always @ (posedge wb_clk) begin
		cnt_reset <= 0;
		wb_ack <= 0;
		if (wb_rst) begin
			cnt_reset <= 1;
			rd_sel <= 0;
			st_req <= 0;
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
							st_req <= 1;
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
			if (st_done) begin
				st_req <= 0;
			end
		end	// not WB reset
	end	// posedge wb_clk

	// Triggers are served and distributed at gtp_clk
	// Global time is maintained by the master trigger source in terms of its gtp_clk
	always @ (posedge gtp_clk) begin
		trg_vld <= 0;		// default
		// reclock trigger from X's
		for (j=0; j<4; j=j+1) begin
			CTRG[j] <= ~CSR[31] & CSR[j] & kchar[j] & (gtp_dat[16*j +:16] == CH_TRIG);
		end	
		// process aux trigger, including long as cycle indicator
		ATRG <= 0;			// this is 1 CLK aux trigger, to be ored with other trigger sources
		auxlong <= 0;		// this is long embracing cycle signal, used for blocking, directly follows ATRG
		cycle <= 0;			// this is 1 CLK cycle pulse, generated when trigger longer than 8 us detected
		case (aux_trig_d[2:1])
			2'b01: begin
				ATRG <= ~CSR[31];
				auxlong_cnt <= 1000;
			end
			2'b11: begin
				auxlong <= 1;
				if (auxlong_cnt == 1) begin
					cycle <= 1;
				end
				if (|auxlong_cnt) begin
					auxlong_cnt <= auxlong_cnt - 1;
				end
			end
			default: begin
				auxlong_cnt <= 0;
			end
		endcase
		aux_trig_d <= {aux_trig_d[1], aux_trig_d[0] & CSR[29], auxtrig};

		// Sending trigger token (immediately on first appearing trigger from channels)
		// token transmission is always longer than writing to memory, even if TOKEN_CLKDIV=1
		if (any_trig & ~blk) begin
			// start sending token on first trig in group if not inhibited or soft trigger
			ser_trg <= {1'b0, ~(^TRGCNT[TOKEN_LENGTH-1:0]), TRGCNT[TOKEN_LENGTH-1:TOKEN_LENGTH/2], ~TRGCNT[TOKEN_LENGTH/2-1:0], 1'b1};
			ser_div <= TOKEN_CLKDIV - 1;
			ser_cnt <= TOKEN_LENGTH + 2;
		end else begin
			if (|ser_div) begin
				// just skip clocks
				ser_div <= ser_div - 1;
			end else if (|ser_cnt) begin
				// shift serial reg
				ser_div <= TOKEN_CLKDIV - 1;
				ser_trg <= {1'b0, ser_trg[TOKEN_LENGTH+2:1]};
				ser_cnt <= ser_cnt - 1;
			end
		end
		
		// Sending trigger block to memory fifo (parallely with token)
		if (any_trig & ~blk) begin
			// initialize and catch first trigger to OR
			mem_cnt <= MEM_WORDS + 1;
			or_trg <= {ATRG, per_trig, soft_trig, CTRG};
			or_cnt <= CSR[6:4];
			GTIMES <= GTIME;
		end else begin
			if (mem_cnt == (MEM_WORDS + 1)) begin
				// stay here during trigger catching time
				if (|or_cnt) begin
					or_trg <= or_trg | {ATRG, 2'b00, CTRG};
					or_cnt <= or_cnt - 1;
				end else begin
					mem_cnt <= mem_cnt - 1;
				end
			end else begin
				if (|mem_cnt) begin
					// send trig info words one by one
					case (mem_cnt)
						//		0	10SC CCCL LLLL LLLL 	CW
						MEM_WORDS   : trg_dat <= {1'b1, or_trg[5:0], MEM_LEN};	//	 L=7 
						// 	1	0ttt pnnn nnnn nnnn - ttt=2 - trigger info block, token
						MEM_WORDS-1 : begin
							trg_dat <= {4'b0010, TRGCNT[0], tok_mem};
							tok_mem_store <= tok_mem;
						end
						//		2	0uuu uuuu uuuu uuuu - user word
						MEM_WORDS-2 : trg_dat <= {1'b0, usr_word}; 
						//		3	0 GTIME[14:0]		  - lower GTIME
						MEM_WORDS-3 : trg_dat <= {1'b0, GTIMES[14:0]}; 
						//		4	0 GTIME[29:15]		  - middle GTIME
						MEM_WORDS-4 : trg_dat <= {1'b0, GTIMES[29:15]}; 
						//		5	0 GTIME[44:30]		  - higher GTIME
						MEM_WORDS-5 : trg_dat <= {1'b0, GTIMES[44:30]}; 
						//		6  0 TRIGCNT[14:0]	  - lower trigger counter, 11 LSB coinside with token
						MEM_WORDS-6 : trg_dat <= {1'b0, TRGCNT[14:0]}; 
						//		7  0 TRIGCNT[29:15]	  - higher trigger counter
						MEM_WORDS-7 : begin
							trg_dat <= {1'b0, TRGCNT[29:15]};
							TRGCNT <= TRGCNT + 1;		//	increment trigger counter here, not used anymore with this trigger
						end
					endcase
					trg_vld <= trg_block_enable;	// acknowledge trigger data
					mem_cnt <= mem_cnt - 1;			// to the next word
				end else begin// zero mem_cnt
					trg_block_enable <= CSR[30];
				end
			end
		end

		// Sending cycle block to memory fifo, no other activity 8 us before
		if (cycle) begin
			// initialize
			cmem_cnt <= CMEM_WORDS;
			GTIMES <= GTIME;
		end else begin
			if (|cmem_cnt) begin
			// send cycle info words one by one
				case (cmem_cnt)
					//		0	10SC CCCL LLLL LLLL 	CW
					CMEM_WORDS   : trg_dat <= {1'b1, 6'b0, CMEM_LEN};	//	 L=8 
					// 	1	0ttt pnnn nnnn nnnn - ttt=6 - cycle info block
					CMEM_WORDS-1 : trg_dat <= {4'b0111, tok_mem_store[0], tok_mem_store};
					//		2	0 GTIME[14:0]		  - lower GTIME
					CMEM_WORDS-2 : trg_dat <= {1'b0, GTIMES[14:0]}; 
					//		3	0 GTIME[29:15]		  - middle GTIME
					CMEM_WORDS-3 : trg_dat <= {1'b0, GTIMES[29:15]}; 
					//		4	0 GTIME[44:30]		  - higher GTIME
					CMEM_WORDS-4 : trg_dat <= {1'b0, GTIMES[44:30]}; 
					//		5  0 TRIGCNT[14:0]	  - lower trigger counter, 11 LSB coinside with token
					CMEM_WORDS-5 : trg_dat <= {1'b0, TRGCNT[14:0]}; 
					//		6  0 TRIGCNT[29:15]	  - higher trigger counter
					CMEM_WORDS-6 : begin
							trg_dat <= {1'b0, TRGCNT[29:15]};
//							TRGCNT[15:0] <= 0;		//	clear trigger counter here, not used anymore with this cycle
// Don't touch TRGCNT		TRGCNT[31:16] <= TRGCNT[31:16] + 1;
						end
					//		7  0 CYCCNT[29:15]	  - higher cycle counter
					CMEM_WORDS-7 : trg_dat <= {1'b0, CYCCNT[14:0]}; 
					//		8  0 CYCCNT[29:15]	  - higher cycle counter
					CMEM_WORDS-8 : begin
							trg_dat <= {1'b0, CYCCNT[29:15]};
							CYCCNT <= CYCCNT + 1;		//	increment cycle counter here, not used anymore with this cycle
						end
				endcase
				trg_vld <= 1;					// acknowledge trigger data
				cmem_cnt <= cmem_cnt - 1;		// to the next word
			end 
		end

		// additional blocking
		if (any_trig & ~blk) begin
			blk_cnt <= CSR[15:7];
		end else if (|blk_cnt) begin
			blk_cnt <= blk_cnt - 1;
		end
		
		// counting missed triggers
		if (any_trig & missed_sense) begin
			MISCNT <= MISCNT + 1;
		end

		// count global time
		if (~CSR[31]) begin
			GTIME <= GTIME + 1;
		end
		
		// periodical trigger
		per_trig <= 0;
		if (ms_p & (|CSR[28:16])) begin
			if (~(|per_cnt)) begin
				per_cnt <= CSR[28:16] - 1;
				per_trig <= 1;
			end else begin
				per_cnt <= per_cnt - 1;
			end
		end
		
		// process soft trigger request
		soft_trig <= 0;
		if (st_req) begin
			if (~st_done) begin
				soft_trig <= 1;
			end
			st_done <= 1;
		end else begin
			st_done <= 0;
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
				cnt_dat <= GTIME[38:7];
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
			CYCCNT <= 0;
		end
	end	// posedge gtp_clk

endmodule
