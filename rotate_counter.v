`timescale 1ns / 1ps

module rotate_counter (
  input wire rotate,      // Clock input
  input wire reset,    // Reset input
  output reg [2:0] count // 4-bit counter output
);

  always @(posedge rotate or posedge reset) begin
    if (reset) begin
      count <= 3'b000; // Reset the counter to 0
    end else begin
      if (count == 3'b100) begin
        count <= 3'b000; // Reset when the counter reaches 3
      end else begin
        count <= count + 1; // Increment the counter
      end
    end
  end

endmodule

