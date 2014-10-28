`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:18:39 10/29/2014 
// Design Name: 
// Module Name:    triggen 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//		Makes trigger from chan FPGA coming triggers,
//		external trigger and soft trigger.
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//		CSR bits:
//	3:0  - corrsponding chan FPGA trigger enable
// 4    - external trigger enable
// 7    - soft trigger (auto clear)
//	15:8 - trigger block time (125MHz ticks)
//////////////////////////////////////////////////////////////////////////////////
module triggen(
		input [63:0] trg_data_i,
		output reg [15:0] trg_data_o,
		input clk,
		input [3:0] kchar_i,
		output reg kchar_o,
		input wb_clk,
		input wb_rst,
		input [31:0] wb_data_i,
		output [31:0] wb_data_o,
		input wb_cyc,
		output reg wb_ack,
		input wb_adr,
		input wb_stb,
		input wb_we,
		input trg_ext
   );

	localparam	CH_COMMA = 16'h00BC;		// comma K28.5
	localparam  CH_TRIG  = 16'h801C;		// K-character K28.0

	reg [31:0] CSR;
	reg [31:0] CNT;
	reg [3:0]  STRG;
	reg [7:0]  dcnt;
	integer i;
	

//		WishBone
	assign wb_data_o = (wb_adr) ? CNT : CSR;
	always @ (posedge wb_clk) begin
		wb_ack <= wb_cyc && wb_stb;
		if (wb_cyc && wb_stb && wb_we) begin
			if (wb_adr) begin
				CNT <= wb_data_i;
			end else begin
				CSR <= wb_data_i;
			end
		end
		if (CSR[7]) CSR[7] <= 0;
	end

//		Trigger
	always @ (posedge clk) begin
		trg_data_o <= {8'h00, CH_COMMA};
		kchar_o <= 1;
		for (i=0; i<4; i=i+1) begin
			STRG[i] <= CSR[i] && kchar_i[i] && (trg_data_i[16*i+7:16*i] == CH_TRIG);
		end
		if (dcnt == 0 && ((STRG != 0) || CSR[7] || (CSR[4] && trg_ext_s))) begin
			dcnt <= CSR[15:8];
			kchar_o <= 0;
			trg_data_o <= {1'b1, CNT[14:0]};
		end
		if (dcnt != 0) dcnt <= dcnt - 1;
	end

endmodule
