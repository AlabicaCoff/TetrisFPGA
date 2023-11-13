`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:20:17 11/12/2023 
// Design Name: 
// Module Name:    calc_color_blk 
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
module calc_color_blk(
		input wire cur_piece,
		output reg [2:0] cur_color_piece
    );
	 
	 always @(*) begin
			case (cur_piece)
				2: cur_color_piece = 3'b111;
				1: cur_color_piece = 3'b101;
				0: cur_color_piece = 3'b010;
				3: cur_color_piece = 3'b100;
				4: cur_color_piece = 3'b011;
				5: cur_color_piece = 3'b101;
				6: cur_color_piece = 3'b110;
				7: cur_color_piece = 3'b111;
				default : cur_color_piece = 3'b111;
			endcase
	 end


endmodule
