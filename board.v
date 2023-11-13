`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:16:05 11/10/2023 
// Design Name: 
// Module Name:    board 
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
module board (
  input wire clk,       // Clock input
  input wire reset,     // Reset input
  input wire [9:0] index_x,
  input wire [9:0] index_y,
  input wire [2:0] data,
  output reg [2:0] pixels
);

  reg [2:0] matrix [0:19][0:9]; // Assuming a 10x10 matrix
	integer i;
	integer j;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      // Reset the entire matrix to 0
      for (i = 0; i < 20; i = i + 1) begin
        for (j = 0; j < 10; j = j + 1) begin
          matrix[i][j] <= 3'b000;
        end
      end
    end else begin
      // Write data to the specified location in the matrix
      if (index_x < 20 && index_y < 10) begin
        matrix[index_y][index_x] <= data;
      end
    end
  end

  // Output the pixel value at the specified location
  always @* begin
    pixels <= (index_x < 20 && index_y < 10) ? matrix[index_y][index_x] :3'b000;
  end

endmodule