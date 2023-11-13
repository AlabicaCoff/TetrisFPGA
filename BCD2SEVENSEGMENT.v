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
	output reg [7:0] seg
    );
	 
always @ (*) begin
            case (bcd)
                0: seg <= 8'b11000000;
                1: seg <= 8'b11111001;
                2: seg <= 8'b10100100;
                3: seg <= 8'b10110000;
                4: seg <= 8'b10011001;
                5: seg <= 8'b10010010;
                6: seg <= 8'b10000010;
                7: seg <= 8'b11111000;
                8: seg <= 8'b10000000;
            endcase
	end
endmodule
