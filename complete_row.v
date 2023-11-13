`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:45:11 11/11/2023 
// Design Name: 
// Module Name:    complete_row 
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
module complete_row(
    input wire                                   clk,
    input wire                                   pause,
    input wire [199:0] fallen_pieces,
    output reg [4:0]                 row,
    output wire                                  enabled
	 //output reg [5:0]										 enabled
    );

	 //reg [4:0] row;
    initial begin
        row = 5;
    end

     // Enabled is high when the current row is complete (all 1s)
     assign enabled = &fallen_pieces[row*10 +: 10];

     // Increment the row under test when the clock goes high
     always @ (posedge clk) begin
         if (!pause) begin
             if (row == 19) begin
                 row <= 0;
             end else begin
                 row <= row + 1;
             end
				
         end
     end

endmodule