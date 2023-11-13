`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:43:21 11/11/2023 
// Design Name: 
// Module Name:    randomizer 
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
module randomizer(
    input wire       clk,
    output reg [2:0] random
    );

    reg [2:0] rand = 1;

    // Cycle through values at 100 MHz and select one
    // at user input, which is effectively random.
    always @ (posedge clk) begin
        if (rand == 7) begin
            rand <= 1;
        end else begin
            rand <= rand + 1;
        end
		random <= rand;
    end


endmodule
