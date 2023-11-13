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
            end
        end
    end

endmodule
