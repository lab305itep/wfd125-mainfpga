`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 		 ITEP
// Engineer: 		 SvirLex
// 
// Create Date:    19:59:41 04/05/2015 
// Design Name: 	 fpga-main
// Module Name:    rcv_arb
// Project Name: 	 wfd125
// Revision: 
// Revision 0.01 - File Created
// Description:
//		Performs Round Robbin arbitration between data FIFOs, passes data to SDRAM memory
//
//	Registers:	(bits not mentioned are not used)
//		0: 	CSR (RW)
//				CSR31	(RW)	Recieve FIFO enable/reset, when 0 fifos do not accept data and
//						no arbitration is performed, all pointers are kept initialized
//				CSR30	(RWC) Full reset of the module (MCB, WBRAM fsm, FIFOs) -- auto cleared
//				CSR29	(RWC) MCB and WBRAM fsm reset -- auto cleared
//				CSR28	(RW)  enable debug, when 1 WADR reads debug lines rather than last written block addr
//				CSR8	(R)   SDRAM GTP area full -  no more blocks can be written from GTP
//				CSR7	(R)   SDRAM GTP area emty -  no new data available for read
//				CSR6	(R)	underrun error: CW recieved earlier than expected, recieving stopped
//				CSR5	(R)	overrunrun error: no CW recieved when expected, recieving stopped
//				CSR4	(R)   OR of CSR[3:0]
//				CSR[3:0](R) (sticky) Recieve FIFO 3-0 overflow - packet missed, only cleared by asserting CSR30
//
//		4:		RADR	(RW)
//				RADR[28:2]	must be set by readout procedure to indicate the last physical address that was already read by it
//				RADR[1:0]	will be ignored and 00 used instead
//
//		8:		LIMR	(RW)
//				LIMR[31:16]	upper 16bit of the address of the first 8K block following the recieving area
//				LIMR[15:0]	upper 16bit of the address of the first 8K block of the recieving area
//				writing to this reg must be done when fifo is disabled with CSR31=0, otherwise writing is ignored
//
//		C:		WADR	(R)
//				WADR[28:2]	physical addres of the first free cell after recieved block is written
//				WADR[1:0]	always reads 00
//
//				with CSR28=1 reads debug lines as indicated in memory.v
//
//////////////////////////////////////////////////////////////////////////////////
module rcv_arb #(
	 parameter NFIFO = 5
)
(
	 input					wb_clk,
	 input					wb_rst,
   // Register WishBone
    input         		wbr_cyc,
    input         		wbr_stb,
    input         		wbr_we,
	 input [1:0]   		wbr_addr,
    input [31:0]  		wbr_dat_i,
    output reg    		wbr_ack,
    output reg [31:0]	wbr_dat_o,
	 // 	trace back a few bits from csr
	 output 					fifo_rst,
	 output 					mcb_rst,
	 output 					en_debug,
	 // interface with recieving FIFOs
	 input					gtp_clk,			// all arbitration and MIG writes are on this clock
	 output [NFIFO-1:0]	want,
	 input [31:0]			datfromfifo,	// common "tri-state"
	 input [NFIFO-1:0]	have,
	 input [NFIFO-1:0]	missed,
	 // inteface with MIG
	 output reg				cmd_enable,		// MIG port cmd fifo enable
	 input					cmd_full,		// MIG port cmd fifo full
	 output reg [5:0]		blen,				// MIG port current burst length
	 output					wr_enable,		// MIG port write fifo enable
	 input					wr_full,			// MIG port write fifo full
	 input					wr_empty,		// MIG port write fifo empty
	 output reg [28:0]	adr_rcv,			// MIG address within recieving area
	 output [31:0]			dattomcb			// MIG port write data
    );

	integer 	rr_cnt = 0;				// counter for Round Robbin arbitration
	wire 		fifohave;				// OR of dvalids from gtpfifos, actually have from currently selected fifo
	wire 		pause;					// pause gtpfifo readout
	wire		mem_full;				// recieving area of memory is full
	wire		mem_empty;				// recieving area of memory is empty
	wire		nextf;					// force increment of RR counter (after block is fully read)
	reg [28:0] waddr;					// current address for MIG write
	reg [7:0] towrite;				// length of current block
	reg err_undr = 0;					// underrun error
	reg err_ovr = 0;					// overrun error

	// registers
	reg [31:0]	csr = 0;					// control and status
	reg [31:0]	radr = 0;				// last read by readout procedure
	reg [31:0]	limr = 32'h00010000;	// limits of the recieving area, def. 8k starting @0
	reg [31:0]	wadr = 0;				// write address as diplayed to the user
	reg [5:0]	rst_cnt = 0;			// autoclear counter
	
	integer j;

	genvar i;
   generate
      for (i=0; i<NFIFO; i=i+1) 
      begin: gwant
         assign want[i] = ((rr_cnt == i) & ~pause) ? 1'b1 : 1'b0;
      end
   endgenerate
	
	assign	fifohave = |have;
	assign	dattomcb = datfromfifo;
	assign	wr_enable = fifohave;
	assign	mem_empty = (radr[28:0] == waddr);
	assign	mem_full = ((radr[28:0] - waddr) <= {{20{1'b0}}, 9'd8}) & ~mem_empty; // 2 dwords are always reserved just for fun
	assign	pause = wr_full | cmd_full | mem_full | err_undr | err_ovr;
	assign	nextf = (towrite == 1);
	
	assign	en_debug = csr[28];
	assign	fifo_rst = ~csr[31] | csr[30];
	assign	mcb_rst = csr[29];

	always @ (posedge gtp_clk) begin
		// defaults
		cmd_enable <= 0;
		
		if (fifo_rst) begin
			// reset
			rr_cnt <= 0;								// rest RR counter
			waddr <= {limr[15:0], {13{1'b0}}};	// init MIG pointers
			csr[4:0] <= 0;								// clear error bits
			blen <= 0;
			towrite <= 0;
			err_undr <= 0;
			err_ovr <= 0;
		end else begin
			// advance round robbin counter
			if ((~fifohave & ~pause) | (nextf & ~pause)) begin
				if (rr_cnt == NFIFO-1) begin
					rr_cnt <= 0;
				end else begin
					rr_cnt <= rr_cnt + 1;
				end
			end
			// latch waddr when MIG data fifo is empty
			if (wr_empty)	wadr <= waddr;
			// if we are writing this word
			if (fifohave) begin
				if ( waddr == {limr[31:16], 13'h1FFC} ) begin
					waddr <= {limr[15:0], 13'b0};
				end else begin
					waddr <= waddr + 4;
				end
				if (|towrite) towrite <= towrite - 1;	// default behavior
				if (blen < 31) blen <= blen + 1;			// default behavior
				if (datfromfifo[15]) begin
					// this is CW
					towrite <= datfromfifo[8:1];		// number of dwords to write -1
					blen <= 0;								// this is start of burst
					adr_rcv <= waddr;						// and this is burst starting address
					if (datfromfifo[8:1] == 0 || waddr == {limr[31:16], 13'h1FFC}) begin
						// if we are writing exactly 1 word
						cmd_enable <= 1;
					end
					if (|towrite) err_undr <= 1;	// must accept next CW with towrite=0, otherwize it's too early
				end else begin
					// issue command if: end of block, blen=32 or last address
					if (towrite == 1 || blen == 30 || waddr == {limr[31:16], 13'h1FFC}) begin
						cmd_enable <= 1;
						blen <= 0;
					end
					if (~(|towrite)) err_ovr <= 1;	// must have accepted CW with towrite=0, otherwize it's too late
				end
			end		// fifo have
		end		// not reset

		// sticky errors
		for (j = 0; j < 4; j=j+1) begin
			if (missed[j]) begin
				csr[j] <= 1;
				csr[4] <= 1;
			end
		end

	end		// posedge gtp_clk
		
	// WB registers
	always @(posedge wb_clk) begin
		// registers: reset-independent
		wbr_ack <=  wbr_cyc & wbr_stb;
		// wrte regs
		if (wbr_cyc & wbr_stb & wbr_we) begin;
			case (wbr_addr)
			2'b00:	begin
				csr[31:28] <= wbr_dat_i[31:28];
				if ( |wbr_dat_i[30:29]) rst_cnt <= 6'hFF;
			end
			2'b01:	radr[28:2] <= wbr_dat_i[28:2];
			2'b10:	begin
				if (~csr[31]) limr <= wbr_dat_i;
			end
			endcase
		end
		// read regs
		if (wbr_cyc & wbr_stb & ~wbr_we) begin;
			case (wbr_addr)
			2'b00:	wbr_dat_o <= {csr[31:9], mem_full, mem_empty, err_undr, err_ovr, csr[4:0]};
			2'b01:	wbr_dat_o <= radr;
			2'b10:	wbr_dat_o <= limr;
			2'b11:	wbr_dat_o <= wadr;
			endcase
		end
		// autoclear reset bits
		if ( |rst_cnt ) begin
			rst_cnt <= rst_cnt - 1;
		end else if (rst_cnt == 1) begin
			csr[30:29] <= 0;
		end
		if (fifo_rst) radr <= {limr[15:0], {13{1'b0}}};
	end		// posedge wb_clk

endmodule
