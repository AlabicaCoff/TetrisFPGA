`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:52:13 11/11/2023 
// Design Name: 
// Module Name:    game_clk 
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
module game_clock(
    input wire clk,
    input wire rst,
    input wire pause,
	 input wire [11:0] score,
    output reg game_clk
    );

    reg [31:0] counter;
    always @ (posedge clk) begin
        if (!pause) begin
            if (rst) begin
                counter <= 0;
                game_clk <= 0;
            end else begin
                if (counter == 10000000) begin // 1 Hz
                    counter <= 0;
                    game_clk <= 1;
                end else begin
                    counter <= counter + 1;
                    game_clk <= 0;
                end
					 /*if (score > 10'b000000010000) begin
						if(counter >= 2000000) begin
							counter <= 0;
							game_clk <= 1;
						end else begin
							counter <= counter + 1;
							game_clk <= 0;
						end
					 end else if (score > 10'b000000001000) begin
						if(counter >= 4000000) begin
							counter <= 0;
							game_clk <= 1;
						end else begin
							counter <= counter + 1;
							game_clk <= 0;
						end
					 end else if (score > 10'b000000000100) begin
						if(counter >= 5000000) begin
							counter <= 0;
							game_clk <= 1;
						end else begin
							counter <= counter + 1;
							game_clk <= 0;
						end
					 end else if (score > 10'b000000000010) begin
						if(counter >= 10000000) begin
							counter <= 0;
							game_clk <= 1;
						end else begin
							counter <= counter + 1;
							game_clk <= 0;
						end
					 end else if (score >= 10'b000000000000) begin
						if(counter >= 10000000) begin
							counter <= 0;
							game_clk <= 1;
						end else begin
							counter <= counter + 1;
							game_clk <= 0;
						end
					 end*/
						
            end
        end
    end

endmodule
