`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:20:00 11/11/2023 
// Design Name: 
// Module Name:    BCD2SEVENSEGMENT 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module BCD2SEVENSEGMENT(
	input [3:0] bcd,
	output reg [6:0] seg
    );
	 
always @ (*) begin
            case (bcd)
                0: seg <= ~7'b1000000;
                1: seg <= ~7'b1111001;
                2: seg <= ~7'b0100100;
                3: seg <= ~7'b0110000;
                4: seg <= ~7'b0011001;
                5: seg <= ~7'b0010010;
                6: seg <= ~7'b0000010;
                7: seg <= ~7'b1111000;
                8: seg <= ~7'b0000000;
					 9: seg <= 7'b1101111;
            endcase
	end
endmodule
