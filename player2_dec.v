module DecimalTo7Segment (
  input wire clk,      // Clock input
  input wire rst,      // Reset input
  input wire [15:0] decimal_input,  // 4-digit decimal input
  output reg [6:0] seg_output [3:0],  // 7-segment outputs for each digit
  output reg dp_output [3:0]  // Decimal point outputs for each digit
);

  reg [3:0] bcd [3:0]; // Binary-coded decimal representation for each digit
  reg [3:0] counter;   // Counter to slow down the update rate

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      // Initialize outputs and counter
      seg_output <= 7'b111_1111;
      dp_output <= 4'b1111;
      bcd <= 4'b0000;
      counter <= 4'b0000;
    end else begin
      // Increment the counter to slow down the update rate
      if (counter == 20_000) begin
        counter <= 4'b0000;

        // Convert decimal to BCD
        bcd[0] <= decimal_input[3:0];
        bcd[1] <= decimal_input[7:4];
        bcd[2] <= decimal_input[11:8];
        bcd[3] <= decimal_input[15:12];

        // Drive 7-segment displays based on BCD
        seg_output[0] <= get_7seg(bcd[0]);
        dp_output[0] <= 1'b0;

        seg_output[1] <= get_7seg(bcd[1]);
        dp_output[1] <= 1'b0;

        seg_output[2] <= get_7seg(bcd[2]);
        dp_output[2] <= 1'b0;

        seg_output[3] <= get_7seg(bcd[3]);
        dp_output[3] <= 1'b0;
      end else begin
        counter <= counter + 1;
      end
    end
  end

  // Function to map BCD digit to 7-segment representation
  function [6:0] get_7seg;
    input [3:0] bcd_digit;

    case (bcd_digit)
      4'b0000: get_7seg = 7'b0000001;  // 0
      4'b0001: get_7seg = 7'b1001111;  // 1
      4'b0010: get_7seg = 7'b0010010;  // 2
      4'b0011: get_7seg = 7'b0000110;  // 3
      4'b0100: get_7seg = 7'b1001100;  // 4
      4'b0101: get_7seg = 7'b0100100;  // 5
      4'b0110: get_7seg = 7'b0100000;  // 6
      4'b0111: get_7seg = 7'b0001111;  // 7
      4'b1000: get_7seg = 7'b0000000;  // 8
      4'b1001: get_7seg = 7'b0000100;  // 9
      default: get_7seg = 7'b1111111;  // Blank if not 0-9
    endcase
  endfunction

endmodule