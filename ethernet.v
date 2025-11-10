`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ITEP
// Engineer: SvirLex
// 
// Create Date:    00:52:30 11/06/2025 
// Design Name:    UWFD64 
// Module Name:    ethernet 
// Project Name:   mainfpga
// Target Devices: XC6SLX45T
// Tool versions: 
// Description:    Wrapper for ethernet MAC
// Module do all the ethernet communication and send commands to top:
// Commands (cmd):
// 0 - none
// 1 - read sdram data (<value> 32-bit words from the address <address>)
// 2 - read register at <address>
// 3 - write register at <address> with <value>
// 4-7 - reserved
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//	We process a few types of packets
//	Receive: ARP, PING, UDP and answer for these protocols
//	UDP data recaived - our commands:
// 32-bit word:
// 0 - command (1 - read SDRAM, 2 - read register, 3 - write register)
// 1 - address
// 2 - value for register write or length for SDRAM read. Long reads are divided not to 
// overflow ethernet packet maximum. We don't send splitted UDP packets
//	UDP replies:
// 0 - repeat the command, Set bit 31 if address or resulting address range are not valid.
// 1 - repeat the address
// 2 - read SDRAM : repeat the length
//     read register : the value read
//     write register : repeat the value
// 3.. SDRAM data. No data for wrong address(es)
//////////////////////////////////////////////////////////////////////////////////
module ethernet(
	// general
	input clk125,
	input clk125_90,
	input reset,
	output error,
	output rcvcnt,
	output [4:0] debug,
	output [13:0] mac_status,
	input [47:0] MAC,
	input [31:0] IP,
	// data to be sent
	input [31:0] txd,
	input txvld,
	input txend,
	output txready,
	// request received
	output [31:0] address,
	output [31:0] value,
	output [2:0] cmd,
	input ready4cmd,
	// PHY interface
	input rgmii_rx_clk,
	input [3:0] rgmii_rxd,
	input rgmii_rx_ctl,
	output rgmii_tx_clk,
	output [3:0] rgmii_txd,
	output rgmii_tx_ctl,
	output mac_gmii_tx_en
	);

	reg [7:0] tdata = 0;
	reg tvalid = 0;
	wire tready;
	reg tlast = 0;
	wire tuser;
	wire [7:0] rdata;
	wire rvalid;
	reg rready = 1;
	wire rlast;
	wire ruser;
	
	localparam IPG_GAP = 8'd12;
	
	localparam [3:0] 
		STATE_IDLE = 4'h0,
		STATE_RECEIVE = 4'h1,
		STATE_ARP = 4'h2,
		STATE_PING = 4'h3,
		STATE_RREG = 4'h4,
		STATE_WREG = 4'h5,
		STATE_SDRAM = 4'h6,
		STATE_ERROR = 4'h7,
		STATE_HEADER = 4'h8,
		STATE_FILL64 = 4'h9,
		STATE_FILLCOPY = 4'hA;
		
	reg [3:0] state;
	reg [3:0] next_state;
	reg rcv_error;
	localparam MAXRCV = 128;
	reg [7:0] rcv_buf [MAXRCV-1:0];
	reg [10:0] rcv_byte_cnt;
	reg [10:0] snd_byte_cnt;
	reg [15:0] ip_byte_len; 
	wire [47:0] src_MAC;
	wire [47:0] dst_MAC;
	wire [31:0] src_IP;
	wire [31:0] dst_IP;	
	localparam [15:0]
		ETH_TYPE_IP = 16'h0800,
		ETH_TYPE_ARP = 16'h0806;
	wire [15:0] Eth_type;
	wire [15:0] IP_length;
	localparam [7:0]
		IP_TYPE_ICMP = 8'd1,
		IP_TYPE_UDP = 8'd17;
	wire [7:0]  IP_protocol;
	wire [15:0] src_port;
	wire [15:0] dst_port;
	localparam [31:0] 
		CMD_READ_SDRAM = 32'd1,
		CMD_READ_REG = 32'd2,
		CMD_WRITE_REG = 32'd3;
	wire [31:0] CMD_cmd;
	wire [31:0] CMD_adr;
	wire [31:0] CMD_len;
	localparam [15:0]
		ARP_OP_RQST = 16'd1,
		ARP_OP_RPLY = 16'd2;
	wire [15:0] ARP_op;
	wire [47:0] ARP_SHA;	// sender MAC
	wire [31:0] ARP_SIP;	// sender IP
	wire [31:0] ARP_TIP;	// target IP
	localparam [7:0] 
		ICMP_TYPE_REPLY = 8'd0,
		ICMP_TYPE_REQUEST = 8'd8;
	wire [7:0]  ICMP_type;
	localparam ICMP_PING_CODE = 0;
	wire [7:0]  ICMP_code;
	
	assign error = rcv_error;
	assign txready = 1;
	assign tuser = 0;
	assign address = 0;
	assign value = 0;
	assign cmd = 0;
	assign debug[0] = rvalid;
	assign debug[1] = rlast;
	assign debug[2] = tready;
	assign debug[3] = error;
	assign debug[4] = rready;
	assign rcvcnt = rvalid;
	assign mac_status[13:10] = state;
//	Data in received block
	// Level 2 frame header
	//	Receive dst_MAC, MSB first
	assign dst_MAC[47:40] = rcv_buf[0]; 
	assign dst_MAC[39:32] = rcv_buf[1]; 
	assign dst_MAC[31:24] = rcv_buf[2]; 
	assign dst_MAC[23:16] = rcv_buf[3]; 
	assign dst_MAC[15:8]  = rcv_buf[4]; 
	assign dst_MAC[7:0]   = rcv_buf[5]; 
	//	Receive src_MAC, MSB first
	assign src_MAC[47:40] = rcv_buf[6]; 
	assign src_MAC[39:32] = rcv_buf[7]; 
	assign src_MAC[31:24] = rcv_buf[8]; 
	assign src_MAC[23:16] = rcv_buf[9]; 
	assign src_MAC[15:8]  = rcv_buf[10]; 
	assign src_MAC[7:0]   = rcv_buf[11];  
	//	Receive Ethernet type
	assign Eth_type[15:8] = rcv_buf[12]; 
	assign Eth_type[7:0]  = rcv_buf[13]; 
	//	IP header - we ignore most bytes so far including check sum
	assign IP_length[15:8] = rcv_buf[16];
	assign IP_length[7:0] = rcv_buf[17];
	assign IP_protocol    = rcv_buf[23]; 
	assign src_IP[31:24]  = rcv_buf[26]; 
	assign src_IP[23:16]  = rcv_buf[27]; 
	assign src_IP[15:8]   = rcv_buf[28]; 
	assign src_IP[7:0]    = rcv_buf[29]; 
	assign dst_IP[31:24]  = rcv_buf[30]; 
	assign dst_IP[23:16]  = rcv_buf[31]; 
	assign dst_IP[15:8]   = rcv_buf[32]; 
	assign dst_IP[7:0]    = rcv_buf[33]; 
	//	UDP header
	assign src_port[15:8] = rcv_buf[34]; 
	assign src_port[7:0]  = rcv_buf[35]; 
	assign dst_port[15:8] = rcv_buf[36]; 
	assign dst_port[7:0]  = rcv_buf[37]; 
	//	UDP data: our command
	assign CMD_cmd[31:24] = rcv_buf[42]; 
	assign CMD_cmd[23:16] = rcv_buf[43]; 
	assign CMD_cmd[15:8]  = rcv_buf[44]; 
	assign CMD_cmd[7:0]   = rcv_buf[45]; 
	assign CMD_adr[31:24] = rcv_buf[46]; 
	assign CMD_adr[23:16] = rcv_buf[47]; 
	assign CMD_adr[15:8]  = rcv_buf[48]; 
	assign CMD_adr[7:0]   = rcv_buf[49]; 
	assign CMD_len[31:24] = rcv_buf[50]; 
	assign CMD_len[23:16] = rcv_buf[51]; 
	assign CMD_len[15:8]  = rcv_buf[52]; 
	assign CMD_len[7:0]   = rcv_buf[53]; 
	//	ARP header
	assign ARP_op[15:8]   = rcv_buf[20]; 
	assign ARP_op[7:0]    = rcv_buf[21]; 
	assign ARP_SHA[47:40] = rcv_buf[22]; 
	assign ARP_SHA[39:32] = rcv_buf[23]; 
	assign ARP_SHA[31:24] = rcv_buf[24]; 
	assign ARP_SHA[23:16] = rcv_buf[25]; 
	assign ARP_SHA[15:8]  = rcv_buf[26]; 
	assign ARP_SHA[7:0]   = rcv_buf[27]; 
	assign ARP_SIP[31:24] = rcv_buf[28]; 
	assign ARP_SIP[23:16] = rcv_buf[29]; 
	assign ARP_SIP[15:8]  = rcv_buf[30]; 
	assign ARP_SIP[7:0]   = rcv_buf[31]; 
	assign ARP_TIP[31:24] = rcv_buf[38]; 
	assign ARP_TIP[23:16] = rcv_buf[39]; 
	assign ARP_TIP[15:8]  = rcv_buf[40]; 
	assign ARP_TIP[7:0]   = rcv_buf[41]; 
	//	ICMP - we support ping only
	assign ICMP_type      = rcv_buf[42];
	assign ICMP_code      = rcv_buf[43];

	always @(posedge clk125) begin
		// default values
		tvalid <= 0;
		tlast <= 0;
		
		if (reset) begin 
			state <= STATE_IDLE;
		end else case (state)
			STATE_IDLE: begin	// Wait for request
				rcv_byte_cnt <= 0;
				rcv_error <= 0;
				rready <= 1;
				if (rvalid) begin	// We expect here the first byte of Layer 2 frame
					rcv_buf[0] <= rdata;
					state <= STATE_RECEIVE;
					rcv_byte_cnt <= 1;
					if (ruser) rcv_error <= 1;
				end
			end
			STATE_RECEIVE: begin
				if (ruser) rcv_error <= 1;
				if (rcv_byte_cnt < MAXRCV) rcv_buf[rcv_byte_cnt] <= rdata;
				rcv_byte_cnt <= rcv_byte_cnt + 1;
				if (rlast) begin
					if (rcv_error) begin
						state <= STATE_IDLE;
					end else if (Eth_type == ETH_TYPE_IP && 
						dst_MAC == MAC && dst_IP == IP &&
						IP_protocol == IP_TYPE_ICMP && 
						ICMP_type == ICMP_TYPE_REQUEST && 
						ICMP_code == ICMP_PING_CODE) begin
						state <= STATE_HEADER;
						next_state <= STATE_PING;
						snd_byte_cnt <= 0;
						rready <= 0;
						ip_byte_len = (IP_length > MAXRCV-14) ? MAXRCV-14 : IP_length;
					end else if (Eth_type == ETH_TYPE_IP && 
						dst_MAC == MAC && dst_IP == IP &&
						IP_protocol == IP_TYPE_UDP) begin
						case (CMD_cmd) 
							CMD_READ_SDRAM: state <= STATE_SDRAM;
							CMD_READ_REG: state <= STATE_RREG;
							CMD_WRITE_REG: state <= STATE_WREG;
							default: state <= STATE_ERROR;
						endcase
						snd_byte_cnt <= 0;
						rready <= 0;
					end else if (Eth_type == ETH_TYPE_ARP &&
						ARP_op == ARP_OP_RQST && ARP_TIP == IP) begin
						state <= STATE_HEADER;
						next_state <= STATE_ARP;
						rready <= 0;
						snd_byte_cnt <= 0;
					end else begin
						state <= STATE_IDLE;
					end
				end
			end
			STATE_ARP: begin
				case (snd_byte_cnt)
				14 : tdata <= 0; //	Hardware type (1 - ethernet)
				15 : tdata <= 1;
				16 : tdata <= 8; // 	Protocal type (0x0800 - IPv4)
				17 : tdata <= 0;
				18 : tdata <= 6; //	Hardware (MAC) length
				19 : tdata <= 4; //	Protocol (IPv4) length
				20 : tdata <= ARP_OP_RPLY[15:8];
				21 : tdata <= ARP_OP_RPLY[7:0];
				22 : tdata <= MAC[47:40];
				23 : tdata <= MAC[39:32];
				24 : tdata <= MAC[31:24];
				25 : tdata <= MAC[23:16];
				26 : tdata <= MAC[15:8];
				27 : tdata <= MAC[7:0];
				28 : tdata <= IP[31:24];
				29 : tdata <= IP[23:16];
				30 : tdata <= IP[15:8];
				31 : tdata <= IP[7:0];
				32 : tdata <= src_MAC[47:40];
				33 : tdata <= src_MAC[39:32];
				34 : tdata <= src_MAC[31:24];
				35 : tdata <= src_MAC[23:16];
				36 : tdata <= src_MAC[15:8];
				37 : tdata <= src_MAC[7:0];
				38 : tdata <= src_IP[31:24];
				39 : tdata <= src_IP[23:16];
				40 : tdata <= src_IP[15:8];
				41 : begin
					tdata <= src_IP[7:0];
					state <= STATE_FILL64;
				end
				endcase
				tvalid <= 1;
				snd_byte_cnt <= snd_byte_cnt + 1;				
			end
			STATE_PING: begin
				case (snd_byte_cnt)
				14 : tdata <= 8'h45;	// Version = 4, header length = 5
				15 : tdata <= 0;	// DSCP, ECN
				16 : tdata <= ip_byte_len[15:8];	// Length high byte
				17 : tdata <= ip_byte_len[7:0];	// Length low byte
				18 : tdata <= 0;	// ID ?
				19 : tdata <= 0;	// ID ?
				20 : tdata <= 0;	// Offset & flags
				21 : tdata <= 0;	// Offset
				22 : tdata <= 8'h40;	// TTL
				23 : tdata <= IP_TYPE_ICMP;
				24 : tdata <= 0;	// Check sum ??? TODO
				25 : tdata <= 0;	// Check sum ??? TODO
				26 : tdata <= IP[31:24];
				27 : tdata <= IP[23:16];
				28 : tdata <= IP[15:8];
				29 : tdata <= IP[7:0];
				30 : tdata <= src_IP[31:24];
				31 : tdata <= src_IP[23:16];
				32 : tdata <= src_IP[15:8];
				33 : tdata <= src_IP[7:0];
				34 : tdata <= ICMP_TYPE_REPLY;
				35 : tdata <= ICMP_PING_CODE;
				36 : tdata <= 0;	// Check sum ??? TODO
				37 : begin
					tdata <= 0;	// Check sum ??? TODO
					state <= STATE_FILLCOPY;
				end
				endcase
				tvalid <= 1;
				snd_byte_cnt <= snd_byte_cnt + 1;								
			end
			STATE_SDRAM: begin
				state <= STATE_IDLE;
			end
			STATE_RREG: begin
				state <= STATE_IDLE;
			end
			STATE_WREG: begin
				state <= STATE_IDLE;
			end
			STATE_ERROR: begin
				state <= STATE_IDLE;
			end
			STATE_HEADER: if (tready) begin
				case (snd_byte_cnt) 
				//	destination: source of the received packet
				0  : tdata <= src_MAC[47:40];
				1  : tdata <= src_MAC[39:32];
				2  : tdata <= src_MAC[31:24];
				3  : tdata <= src_MAC[23:16];
				4  : tdata <= src_MAC[15:8];
				5  : tdata <= src_MAC[7:0];
				//	source: always our MAC
				6  : tdata <= MAC[47:40];
				7  : tdata <= MAC[39:32];
				8  : tdata <= MAC[31:24];
				9  : tdata <= MAC[23:16];
				10 : tdata <= MAC[15:8];
				11 : tdata <= MAC[7:0];
				12 : begin 
					if (next_state == STATE_ARP) begin
						tdata <= ETH_TYPE_ARP[15:8];
					end else begin
						tdata <= ETH_TYPE_IP[15:8];
					end
				end
				13 : begin 
					if (next_state == STATE_ARP) begin
						tdata <= ETH_TYPE_ARP[7:0];
					end else begin
						tdata <= ETH_TYPE_IP[7:0];
					end
					state <= next_state;
				end
				endcase				
				tvalid <= 1;
				snd_byte_cnt <= snd_byte_cnt + 1;
			end
			STATE_FILL64: begin
				if (snd_byte_cnt == 59) begin	// Minimum packet is 64 bytes = 60 + 4(CRC)
					state <= STATE_IDLE;
					tlast <= 1;
				end
				tdata <= 0;
				tvalid <= 1;
				snd_byte_cnt <= snd_byte_cnt + 1;				
			end
			STATE_FILLCOPY: begin
				if (snd_byte_cnt == ip_byte_len + 13) begin	// PING response - send copy of received packet
					state <= STATE_IDLE;
					tlast <= 1;
				end
				tdata <= rcv_buf[snd_byte_cnt];
				tvalid <= 1;
				snd_byte_cnt <= snd_byte_cnt + 1;				
			end
			default : begin
				state <= STATE_IDLE;
			end
		endcase
	end
	
	
//	Ethernet by Alex Forencich (GHz RGMII Ethernet MAC to the Digilent Genesys2 board)
	eth_mac_1g_rgmii_fifo #(
		.TARGET("XILINX"),
		.IODDR_STYLE("IODDR2"),
		.CLOCK_INPUT_STYLE("BUFIO2")
	) ethernet_mac (
		.gtx_clk(clk125),
		.gtx_clk90(clk125_90),
		.gtx_rst(reset),	// translate VME reset here
		.logic_clk(clk125),
		.logic_rst(reset),
	/*
	 * AXI input
	 */
		.tx_axis_tdata(tdata),
		.tx_axis_tvalid(tvalid),
		.tx_axis_tready(tready),
		.tx_axis_tlast(tlast),
		.tx_axis_tuser(tuser),
	/*
	 * AXI output
	 */
		.rx_axis_tdata(rdata),
		.rx_axis_tvalid(rvalid),
		.rx_axis_tready(rready),
		.rx_axis_tlast(rlast),
		.rx_axis_tuser(ruser),

	/*
	 * RGMII interface
	 */
		.rgmii_rx_clk(rgmii_rx_clk),
		.rgmii_rxd(rgmii_rxd),
		.rgmii_rx_ctl(rgmii_rx_ctl),
		.rgmii_tx_clk(rgmii_tx_clk),
		.rgmii_txd(rgmii_txd),
		.rgmii_tx_ctl(rgmii_tx_ctl),
		.mac_gmii_tx_en(mac_gmii_tx_en),		
	/*
	 * Status
	 */
		.tx_fifo_overflow(mac_status[0]),
		.tx_fifo_bad_frame(mac_status[1]),
		.tx_fifo_good_frame(mac_status[2]),
		.rx_error_bad_frame(mac_status[3]),
		.rx_error_bad_fcs(mac_status[4]),
		.rx_fifo_overflow(mac_status[5]),
		.rx_fifo_bad_frame(mac_status[6]),
		.rx_fifo_good_frame(mac_status[7]),
		.speed(mac_status[9:8]),
		.rx_fcs_reg(),
		.tx_fcs_reg(),
	/*
	 * Configuration
	 */
		.ifg_delay(IPG_GAP)
	);

endmodule
