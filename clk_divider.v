`timescale 1ns / 1ps

// Mod Clock 20MHz to 1 Hz
module clk_divider (
    input wire clk_20MHz,   // 20 MHz input clock
    output reg clk_1Hz     // 1 Hz output clock
);

reg [24:0] counter;  // 25-bit counter to divide the clock

always @(posedge clk_20MHz) begin
    if (counter == 25'd9999999) begin
        counter <= 0;
        clk_1Hz <= ~clk_1Hz; // Toggle the 1 Hz output
    end
    else begin
        counter <= counter + 1;
    end
end

endmodule



