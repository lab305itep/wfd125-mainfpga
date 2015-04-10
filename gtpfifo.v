`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company: ITEP
// Engineer: SvirLex
// 
// Create Date:    04/06/2015 
// Design Name: 	 main_fpga
// Module Name:    myblkram 
// Project Name: 	 wfd125
// Target Devices: 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//		Accepts 16-bit input words accompanied with valid.
//		Considers blocks starting with CW with 15th bit set 
//		CW format: 1 CCCCCC LLLLLLLLL, C:6-bit channel number, L:9-bit block length, not including CW
//		all other words in the block MUST NOT contain 15th bit
//		Add 0x8000 filler at the end of block with odd number of 16-bit words (CW with zero block length)
//		Checks that full block can be written to fifo at the acceptance of the first word CW,
//		if not, drops the whole block and sets 'missed' error flag for one CLK
//		Assumes that writing to MIG happens at gtp_clk clocking
//		If at least one full block is in fifo, immediately signals 'have' together with valid data
//		in response to 'give' and advances read pointer
//		Assumes that arbitter will read full block based on its length
//		
/////////////////////////////////////////////////////////////////////////////////////////////////////////
module gtpfifo(
		input 			gtp_clk,
		input [15:0] 	gtp_dat,
		input 			gtp_vld,
		input				rst,
		input 			give,
		output[31:0]	data,
		output 	 		have,
		output reg 		missed
   );

	parameter MBITS = 13;

	reg [31:0] 			fifo [2**MBITS-1:0];
	reg [MBITS-1:0] 	waddr = 0;		// current fifo write pointer
	reg [MBITS-1:0] 	waddrb = 0;		// pointer to the end of full written block
	reg [MBITS-1:0] 	raddr = 0;		// current fifo read pointer
	wire [MBITS-1:0]	graddr;			// fifo read addr for get operation from arb
	wire [MBITS-1:0]	len;				// block length in Dwords directly from CW field
	reg  [7:0]			towrite;			// number of Dwords to write - 1
	reg					writing = 0;	// if we are now writing the body of a block
	reg					align = 0;		// if we need to add filler after the odd number of words
	reg 					odd = 0;			// next word is odd
	reg [15:0] 			evendat = 0;	// holder for even words
	reg [31:0] 			rdata = 0;		// read fifo output

	assign len = {{(MBITS-8){1'b0}}, gtp_dat[8:1]} + 1;		// total number of 32-bit words to write (from CW)	
	assign graddr = (give) ? (raddr + 1) : raddr;
	assign have = give & (raddr != waddrb);
	assign data = (have) ? rdata : 32'hZZZZZZZZ;

	always @ (posedge gtp_clk) begin
		// defaults
		missed <= 0;
		if (rst) begin
			waddr <= 0;
			waddrb <= 0;
			raddr <= 0;
			odd <= 0;
			writing <= 0;
		end else begin
			// write fifo
			if (gtp_vld) begin
				if (~writing) begin
					// waiting for a valid word with 15th bit set
					if (gtp_dat[15]) begin
						// CW recieved
						if (raddr - waddr > len || raddr == waddr) begin
							// if enough place for a block
							towrite <= gtp_dat[8:1];		// length to write - 1
							align <= ~gtp_dat[0];			// if we need to add filler to complete last word
							evendat <= gtp_dat;				// memorize first word (even)
							odd <= 1;							// next word is odd
							writing <= 1;						// further we will be writing the block according to the length
						end else begin
							// no space for this block
							missed <= 1;						// indicate missed block, stay here to wait for next CW
						end
					end
				end else begin
					// writing the body of block
					if ( |towrite ) begin
						// not the last Dword
						if (odd) begin
							// this is odd word, write together with previous
							fifo[waddr] <= {gtp_dat, evendat};		// write
							waddr <= waddr + 1;							// incremnt write addr
							towrite <= towrite - 1;						// decrement goal
							odd <= 0;										// indicate next word is even
						end else begin
							// this is even word, just memorize it for further writing
							evendat <= gtp_dat;							// memorize data
							odd <= 1;										// indicate next word is odd
						end
					end else begin
						// this is the last Dword
						if (odd) begin
							// we can only be here if no alignment was necessary, just finish
							fifo[waddr] <= {gtp_dat, evendat};		// write
							waddr <= waddr + 1;							// incremnt write addr
							waddrb <= waddr + 1;							// move block write pointer
							writing <= 0;									// finished with this block
						end else begin
							// this is last even word
							if (align) begin
								// if we need alignment, do it and finish
								fifo[waddr] <= {16'h8000, gtp_dat};		// write with alighnment
								waddr <= waddr + 1;							// incremnt write addr
								waddrb <= waddr + 1;							// move block write pointer
								writing <= 0;									// finished with this block
							end else begin
								// like rgular even word, just memorize it for further writing
								evendat <= gtp_dat;							// memorize data
								odd <= 1;										// indicate next word is odd
							end
						end
					end
				end
			end	// write fifo
			
			// read fifo
			rdata <= fifo[graddr];
			if (have) begin
				raddr <= raddr + 1;
			end	// read fifo
			
		end	// not reset
	end	// posedge CLK


	
endmodule
