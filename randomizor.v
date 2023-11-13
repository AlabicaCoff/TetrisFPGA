`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:45:57 11/10/2023 
// Design Name: 
// Module Name:    randomizor 
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
module randomizor(
    input wire       clk,
    output reg [2:0] random
    );

    initial begin
        random = 0;
    end

    // Cycle through values at 100 MHz and select one
    // at user input, which is effectively random.
    always @ (posedge clk) begin
        if (random == 8) begin
            random <= 0;
        end else begin
            random <= random + 1;
        end
    end

endmodule