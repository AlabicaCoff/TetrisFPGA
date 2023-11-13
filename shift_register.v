`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:22:00 11/13/2023 
// Design Name: 
// Module Name:    shift_register 
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
module shift_register(
		input clk,
		input ce,
		output reg game_clk
    );

    reg [31:0] counter;
    always @ (posedge clk) begin
            if (ce) begin
					if (counter == 10000000) begin // 1 Hz
							  counter <= 0;
							  game_clk <= 1;
						 end else begin
							  counter <= counter + 1;
							  game_clk <= 0;
						 end
            end else begin
						counter <= 0;
                game_clk <= 0;                

            end 
    end



endmodule
