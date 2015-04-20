`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 		 ITEP
// Engineer: 		 SvirLex
// 
// Create Date:    18:41:07 04/20/2015 
// Design Name: 	 fpga_main
// Module Name:    cmux21 
// Project Name: 	 wfd125
// Target Devices: S6
// Revision 0.01 - File Created
// Additional Comments: 
//		This is a real logic multiplexer using CARRY4 logic
//
//////////////////////////////////////////////////////////////////////////////////
module cmux21(
    input I0,
    input I1,
    input S,
    output O
    );
	 
	 // assuming S=0 selects DI, S=1 selects chain
	 
	 wire [3:0] DI;
	 wire [3:0] SI;
	 wire [3:0] CO;
	 
	 assign DI[3] = I0;
	 assign DI[2] = I1;
	 assign DI[1:0] = 2'b00;
	 
	 assign SI[3] = S;
	 assign SI[2] = 1'b0;
	 assign SI[1:0] = 2'b00;
	 
	 assign O = CO[3];

   CARRY4 CARRY4_inst (
      .CO(CO),         // 4-bit carry out
      .O(),            // 4-bit carry chain XOR data out
      .CI(1'b0),       // 1-bit carry cascade input
      .CYINIT(1'b0),   // 1-bit carry initialization
      .DI(DI),         // 4-bit carry-MUX data in
      .S(SI)            // 4-bit carry-MUX select input
   );


endmodule
