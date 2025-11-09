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

	wire [7:0] tdata;
	wire tvalid;
	wire tready;
	wire tlast;
	wire tuser;
	wire [7:0] rdata;
	wire rvalid;
	reg rready;
	wire rlast;
	wire ruser;
	
	localparam [2:0] 
		STATE_IDLE = 3'h0,
		STATE_RECEIVE = 3'h1,
		STATE_ARP = 3'h2,
		STATE_PING = 3'h3,
		STATE_RREG = 3'h4,
		STATE_WREG = 3'h5,
		STATE_SDRAM = 3'h6,
		STATE_ERROR = 3'h7;
		
	reg [2:0] state;
	reg rcv_error;
	localparam MAXRCV = 64;
	reg [7:0] rcv_buf [MAXRCV-1:0];
	wire [10:0] rcv_byte_cnt;
	wire [10:0] snd_byte_cnt;
	wire [47:0] src_MAC;
	wire [47:0] dst_MAC;
	wire [31:0] src_IP;
	wire [31:0] dst_IP;	
	localparam [15:0]
		ETH_TYPE_IP = 16'h0800,
		ETH_TYPE_ARP = 16'h0806;
	wire [15:0] Eth_type;
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
	assign debug[4] = 0;
	assign rcvcnt = rlast;
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
	assign src_MAC[23:26] = rcv_buf[9]; 
	assign src_MAC[15:8]  = rcv_buf[10]; 
	assign src_MAC[7:0]   = rcv_buf[11];  
	//	Receive Ethernet type
	assign Eth_type[15:8] = rcv_buf[12]; 
	assign Eth_type[7:0]  = rcv_buf[13]; 
	//	IP header - we ignore most bytes so far including check sum
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
		case (state)
			STATE_IDLE: begin	// Wait for request
				rcv_byte_cnt <= 0;
				rcv_error <= 0;
				IP_protocol <= 0;
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
						state <= STATE_PING;
						snd_byte_cnt <= 0;
						rready <= 0;
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
						state <= STATE_ARP;
						rready <= 0;
						snd_byte_cnt <= 0;
					end else begin
						state <= STATE_IDLE;
					end
				end
			end
			STATE_ARP: begin
				case (snd_byte_cnt) 
				//???????????????????????????	
				endcase
			end
			STATE_PING: begin
			end
			STATE_SDRAM: begin
			end
			STATE_RREG: begin
			end
			STATE_WREG: begin
			end
			STATE_ERROR: begin
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
		.mac_gmii_tx_en(mac_gmii_tx_en)
	);

endmodule
