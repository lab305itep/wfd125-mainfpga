`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:03:59 03/27/2015 
// Design Name:    memory
// Module Name:    memory 
// Project Name:   wfd125-mainfpga
// Target Devices: XC6SLX45T
// Description: 
//		Accepts and buffers data from 4 GTP recievers, passes it to SDRAM memory
//		in blocks with round-robbin arbitration
//		Supports full pipelined interface for Wishbone block transfers
//
//
//////////////////////////////////////////////////////////////////////////////////
module memory # (
    parameter READ_BURST_LEN = 16
)
(
    input         wb_clk,
    input         wb_rst,
   // Memory WishBone
    input         wbm_cyc,
    input         wbm_stb,
    input         wbm_we,
	 input [3:0]   wbm_sel,
	 input [28:0]  wbm_addr,	// byte address is 29 bit wide for 4 Gbits (512 Mbytes)
    input [31:0]  wbm_dat_i,
    output reg    wbm_ack,
    output reg    wbm_stall,
    output [31:0] wbm_dat_o,
   // Register WishBone
    input         wbr_cyc,
    input         wbr_stb,
    input         wbr_we,
	 input [1:0]   wbr_addr,
    input [31:0]  wbr_dat_i,
    output        wbr_ack,
    output [31:0] wbr_dat_o,
   // GTP data
	// reciever clock 125 MHz
	 input         gtp_clk,
	// recied data from 4 recievers
    input [63:0]  gtp_dat,
	// recieved data valid (not a comma)
    input         gtp_vld,
	// SDRAM interface
	 input         mcb_clk,
	// Address
    output [14:0] MEMA,
	// Bank addr
    output [2:0]  MEMBA,
	// Data
    inout [15:0]  MEMD,
	// Other single ended
    output        MEMRST,
    output        MEMCKE,
    output        MEMWE,
    output        MEMODT,
    output        MEMRAS,
    output        MEMCAS,
    output        MEMUDM,
    output        MEMLDM,
	// Pairs
    output [1:0]  MEMCK,
    output [1:0]  MEMUDQS,
    output [1:0]  MEMLDQS,
	// Impedance matching
    output        MEMZIO,
    output        MEMRZQ,
	// current status
    output [31:0] status
    );

	wire mem_rst;			// external reset or command from register
	wire wf_empty;			// port 0 write fifo empty -- end of previous write
	reg wf_enable = 0;	// port 0 write fifo enable
	reg [31:0] wf_data;	// data to be written to port 0 fifo
	reg [6:0] stb_cnt;
	reg [28:0] adr_beg;	// block beginning address

// main state machine
	reg [3:0] state;
	localparam ST_RST 		= 0;
	localparam ST_IDLE 		= 1;
	localparam ST_WR_FIFO 	= 2;
	localparam ST_WR_CMD		= 3;
	localparam ST_WR_WAIT	= 4;
	
	always @(posedge wb_clk) begin
		// Defaults
		wbm_stall <= 0;
		wbm_ack <= 0;
		wf_enable <= 0;
		if (mem_rst) begin
         state <= ST_RST;
      end else begin
			case (state)
				ST_RST : begin
					// Wait for end of current cycle here
					stb_cnt <= 0;
					if ~wbm_cyc begin
						state <= ST_IDLE;
					end
				end
            ST_IDLE : begin
					stb_cnt <= 0;
					if wbm_cyc & wbm_stb begin
						// This is first stb in a cycle
						stb_cnt <= stb_cnt + 1;
						adr_beg <= wbm_addr;
						if wbm_we begin
							// Write operation, assume that write fifo always has space for one word
							wf_data <= wbm_dat_i;	// memorize data for this write
							wf_enable <= 1;			// enable write
							wbm_ack <= 1;				// ack the data
							if ~wf_empty begin
								// Have to wait till previous write finishes
								wbm_stall <= 1;		// assert stall
								state <= ST_WR_WAIT;
							end else
								state <= ST_WR_FIFO;
							end
						end else begin
						// Read operation
						end
					end
            end
            ST_WRFIFO : begin
            end
            ST_WRCMD : begin
            end
         endcase 
      end
	end

// MIG DDR3 SDRAM controller
// we only use port 0 for Wishbone ternsfers and port 2 for GTP data writing
 memcntr # (
    .C1_P0_MASK_SIZE(4),
    .C1_P0_DATA_PORT_SIZE(32),
    .C1_P1_MASK_SIZE(4),
    .C1_P1_DATA_PORT_SIZE(32),
    .DEBUG_EN(0),
    .C1_MEMCLK_PERIOD(3300),		// Memory freq 125 MHz
    .C1_CALIB_SOFT_IP("TRUE"),
    .C1_SIMULATION("FALSE"),
    .C1_RST_ACT_LOW(0),
    .C1_INPUT_CLK_TYPE("INTERNAL"),		// Clocks are internal
    .C1_MEM_ADDR_ORDER("ROW_BANK_COLUMN"),
    .C1_NUM_DQ_PINS(16),
    .C1_MEM_ADDR_WIDTH(15),
    .C1_MEM_BANKADDR_WIDTH(3)
)
u_memcntr (
// system
  .c1_sys_clk             (mcb_clk),
  .c1_sys_rst_i           (mem_rst),                        
  .c1_clk0		        	  (),			// unused output
  .c1_rst0		           (),			// unused output
  .c1_calib_done          (),			// unused so far
// SDRAM chip signals to board
  .mcb1_dram_dq           (MEMD),  
  .mcb1_dram_a            (MEMA),  
  .mcb1_dram_ba           (MEMBA),
  .mcb1_dram_ras_n        (MEMRAS),                        
  .mcb1_dram_cas_n        (MEMCAS),                        
  .mcb1_dram_we_n         (MEMWE),                          
  .mcb1_dram_odt          (MEMODT),
  .mcb1_dram_cke          (MEMCKE),                          
  .mcb1_dram_ck           (MEMCK[0]),                          
  .mcb1_dram_ck_n         (MEMCK[1]),       
  .mcb1_dram_dqs          (MEMLDQS[0]),                          
  .mcb1_dram_dqs_n        (MEMLDQS[1]),
  .mcb1_dram_udqs         (MEMUDQS[0]),    // for X16 parts                        
  .mcb1_dram_udqs_n       (MEMUDQS[1]),    // for X16 parts
  .mcb1_dram_udm          (MEMUDM),        // for X16 parts
  .mcb1_dram_dm           (MEMLDM),
  .mcb1_dram_reset_n      (MEMRST),
  .mcb1_rzq               (MEMRZQ),  
  .mcb1_zio               (MEMZIO),
// port 0 bidirectional
   .c1_p0_cmd_clk                          (wb_clk),
   .c1_p0_cmd_en                           (0),
   .c1_p0_cmd_instr                        (0 ? 3'b011 : 3'b010), // write or read with autoprecharge
   .c1_p0_cmd_bl                           (0),		// burst length
   .c1_p0_cmd_byte_addr                    (0),
   .c1_p0_cmd_empty                        (),
   .c1_p0_cmd_full                         (),
   .c1_p0_wr_clk                           (wb_clk),
   .c1_p0_wr_en                            (0),
   .c1_p0_wr_mask                          (4'b0000),	// always all 4 bytes
   .c1_p0_wr_data                          (0),
   .c1_p0_wr_full                          (),
   .c1_p0_wr_empty                         (wf_empty),
   .c1_p0_wr_count                         (),
   .c1_p0_wr_underrun                      (),
   .c1_p0_wr_error                         (),
   .c1_p0_rd_clk                           (wb_clk),
   .c1_p0_rd_en                            (0),		// always valid if not empty
   .c1_p0_rd_data                          (),
   .c1_p0_rd_full                          (),
   .c1_p0_rd_empty                         (),
   .c1_p0_rd_count                         (),
   .c1_p0_rd_overflow                      (),
   .c1_p0_rd_error                         (),
// port1 unused
   .c1_p1_cmd_clk                          (0),
   .c1_p1_cmd_en                           (0),
   .c1_p1_cmd_instr                        (0),
   .c1_p1_cmd_bl                           (0),
   .c1_p1_cmd_byte_addr                    (0),
   .c1_p1_cmd_empty                        (),
   .c1_p1_cmd_full                         (),
   .c1_p1_wr_clk                           (0),
   .c1_p1_wr_en                            (0),
   .c1_p1_wr_mask                          (0),
   .c1_p1_wr_data                          (0),
   .c1_p1_wr_full                          (),
   .c1_p1_wr_empty                         (),
   .c1_p1_wr_count                         (),
   .c1_p1_wr_underrun                      (),
   .c1_p1_wr_error                         (),
   .c1_p1_rd_clk                           (0),
   .c1_p1_rd_en                            (0),
   .c1_p1_rd_data                          (),
   .c1_p1_rd_full                          (),
   .c1_p1_rd_empty                         (),
   .c1_p1_rd_count                         (),
   .c1_p1_rd_overflow                      (),
   .c1_p1_rd_error                         (),
// port 2 write only
   .c1_p2_cmd_clk                          (wb_clk),
   .c1_p2_cmd_en                           (0),
   .c1_p2_cmd_instr                        (3'b010),	// always write with autoprecharge
   .c1_p2_cmd_bl                           (0),
   .c1_p2_cmd_byte_addr                    (0),
   .c1_p2_cmd_empty                        (),
   .c1_p2_cmd_full                         (),
   .c1_p2_wr_clk                           (wb_clk),
   .c1_p2_wr_en                            (0),
   .c1_p2_wr_mask                          (4'b0000),
   .c1_p2_wr_data                          (0),
   .c1_p2_wr_full                          (),
   .c1_p2_wr_empty                         (),
   .c1_p2_wr_count                         (),
   .c1_p2_wr_underrun                      (),
   .c1_p2_wr_error                         (),
// ports 3-5 unused
   .c1_p3_cmd_clk                          (0),
   .c1_p3_cmd_en                           (0),
   .c1_p3_cmd_instr                        (0),
   .c1_p3_cmd_bl                           (0),
   .c1_p3_cmd_byte_addr                    (0),
   .c1_p3_cmd_empty                        (),
   .c1_p3_cmd_full                         (),
   .c1_p3_wr_clk                           (0),
   .c1_p3_wr_en                            (0),
   .c1_p3_wr_mask                          (0),
   .c1_p3_wr_data                          (0),
   .c1_p3_wr_full                          (),
   .c1_p3_wr_empty                         (),
   .c1_p3_wr_count                         (),
   .c1_p3_wr_underrun                      (),
   .c1_p3_wr_error                         (),
   .c1_p4_cmd_clk                          (0),
   .c1_p4_cmd_en                           (0),
   .c1_p4_cmd_instr                        (0),
   .c1_p4_cmd_bl                           (0),
   .c1_p4_cmd_byte_addr                    (0),
   .c1_p4_cmd_empty                        (),
   .c1_p4_cmd_full                         (),
   .c1_p4_wr_clk                           (0),
   .c1_p4_wr_en                            (0),
   .c1_p4_wr_mask                          (0),
   .c1_p4_wr_data                          (0),
   .c1_p4_wr_full                          (),
   .c1_p4_wr_empty                         (),
   .c1_p4_wr_count                         (),
   .c1_p4_wr_underrun                      (),
   .c1_p4_wr_error                         (),
   .c1_p5_cmd_clk                          (0),
   .c1_p5_cmd_en                           (0),
   .c1_p5_cmd_instr                        (0),
   .c1_p5_cmd_bl                           (0),
   .c1_p5_cmd_byte_addr                    (0),
   .c1_p5_cmd_empty                        (),
   .c1_p5_cmd_full                         (),
   .c1_p5_wr_clk                           (0),
   .c1_p5_wr_en                            (0),
   .c1_p5_wr_mask                          (0),
   .c1_p5_wr_data                          (0),
   .c1_p5_wr_full                          (),
   .c1_p5_wr_empty                         (),
   .c1_p5_wr_count                         (),
   .c1_p5_wr_underrun                      (),
   .c1_p5_wr_error                         ()
);

endmodule
