`timescale 1ns / 1ps

// Main Module
module Tetris(
	input osc,
	input reset,
	input left,
	input right,
	input down,
	input rotate,
	input increment,
	output h_sync,
	output v_sync,
	output reg [2:0] vga_rgb
    );
	 
	// Define HIGH and LOW
	parameter LOW = 1'b_0;
	parameter HIGH = 1'b_1;
	
	// Define Variables
	parameter [9:0] BOX_SIZE = 10'd_14;
	parameter [9:0] FONT_W = 10'd_25;
	parameter [9:0] FONT_H = 10'd_40;
	parameter [9:0] FONT_D = 10'd_5;
	
	// Declare Variables
	wire is_display_active;
	wire [9:0] next_x;
	wire [9:0] next_y;
	
	// Initial tetris pos
	reg [9:0] num1_pos_x = 10'd_200;
	reg [9:0] num1_pos_y = 10'd_80;
	reg [9:0] num2_pos_x = 10'd_260;
	reg [9:0] num2_pos_y = 10'd_80;
	reg [9:0] score_pos_x = 10'd_200;
	reg [9:0] score_pos_y = 10'd_20;
	reg [9:0] text_pos_x = 10'd_365;
	reg [9:0] text_pos_y = 10'd_0;
	reg [22:0] sec_counter;
	
	// Clock 1 Hz
	wire clk_1hz;
	clk_divider clk_modded(
						.clk_20MHz(osc),
						.clk_1Hz(clk_1hz)
						);
	
	// vga_driver module for generate a vsync and hsync signal
	vga_driver test_driver(
						.clk(osc), 
						.reset(reset),
						.next_x(next_x),
						.next_y(next_y),
						.v_sync(v_sync),
						.h_sync(h_sync),
						.is_active(is_display_active)
						);

	// Debounce PB
	wire ePB5;
	wire dPB5;				
	debounce debounce0(
					.raw(increment),
					.clk(osc),
					.enabled(ePB5),
					.disabled(dPB5)
					);
								
	wire	[3:0] digit0_1; 
	wire	[3:0] digit1_1;
	wire	[3:0] digit2_1;

	// Score Counter
	BCD_counter BCD_counter1(
							.clk(osc),
							.rst(reset),
							.increment(ePB5),
							.digit2(digit2_1),
							.digit1(digit1_1),
							.digit0(digit0_1)
							);
	
	wire	[3:0] digit0_2; 
	wire	[3:0] digit1_2;
	wire	[3:0] digit2_2;
	BCD_counter BCD_counter2(
							.clk(osc),
							.rst(reset),
							.increment(ePB5),
							.digit2(digit2_2),
							.digit1(digit1_2),
							.digit0(digit0_2)
							);
								
	wire [7:0] pixels0_1;
	wire [7:0] pixels1_1; 
	wire [7:0] pixels2_1;
	chars score0_1(
				.char(digit0_1),
				.rownum(next_y - num1_pos_y),
				.pixels(pixels0_1)
				);
	
	chars score1_1(
				.char(digit1_1),
				.rownum(next_y - num1_pos_y),
				.pixels(pixels1_1)
				);
					
	chars score2_1(
				.char(digit2_1),
				.rownum(next_y - num1_pos_y),
				.pixels(pixels2_1)
				);
					
	wire [7:0] pixels0_2;
	wire [7:0] pixels1_2; 
	wire [7:0] pixels2_2;
	chars score0_2(
				.char(digit0_2),
				.rownum(next_y - num2_pos_y),
				.pixels(pixels0_2)
				);
	
	chars score1_2(
				.char(digit1_2),
				.rownum(next_y - num2_pos_y),
				.pixels(pixels1_2)
				);
					
	chars score2_2(
				.char(digit2_2),
				.rownum(next_y - num2_pos_y),
				.pixels(pixels2_2)
				);
	
	reg type = 0;
	wire [3:0] blk_pixels0;
	wire [3:0] blk_pixels1;
	wire [3:0] blk_pixels2;
	wire [3:0] blk_pixels3;
	blocks_module block(
					.type(type),
					.rot(rotate),
					.pixels0(blk_pixels0),
					.pixels1(blk_pixels1),
					.pixels2(blk_pixels2),
					.pixels3(blk_pixels3)
					);

	// Rising Edge Detector for clk 1 hz
	wire clk_1hz_edge;
	posedge_detect clk_posedge_detector(
									.signal(clk_1hz),
									.clk(osc),
									.signal_rising(clk_1hz_edge));
								
	// Rising Edge Detector for left pushbutton				
	wire left_edge;
	posedge_detect left_posedge_detector(
									.signal(left),
									.clk(osc),
									.signal_rising(left_edge));
	
	// Rising Edge Detector for right pushbutton		
	wire right_edge;
	posedge_detect right_posedge_detector(
										.signal(right),
										.clk(osc),
										.signal_rising(right_edge)
										);
					
	// Rising Edge Detector for down pushbutton		
	wire down_edge;
	posedge_detect down_posedge_detector(
										.signal(down),
										.clk(osc),
										.signal_rising(down_edge)
										);
	
	
	// Controller
	always @(posedge osc) begin
		// Reset
		if (reset) begin 
			sec_counter <= 23'd_0;
			text_pos_x <= 10'd_357;
			text_pos_y <= 10'd_0;
		end
		else begin
			sec_counter <= (sec_counter == 23'd_199999)?23'd_0:(sec_counter + 23'd_1);
			// Move block left
			if (left_edge) begin
				if (text_pos_x  <= 10'd_357) text_pos_x <= text_pos_x
				else text_pos_x <= text_pos_x - BOX_SIZE
			end
			// Move block right
			else if (right_edge) begin
				if (text_pos_y + BOX_SIZE >= 10'd_500) text_pos_x <= text_pos_x
				else text_pos_x <= text_pos_x + BOX_SIZE
			end
			// Stay
			else begin
				text_pos_x <= text_pos_x;
			end
			
			// Move block down
			if (down_edge) begin
				if (text_pos_y + (2 * BOX_SIZE) >= 10'd_477) text_pos_y <= text_pos_y
				else text_pos_y <= text_pos_y + BOX_SIZE
			end
			// Gravity fall
			if (clk_1hz_edge) begin
				if (text_pos_y + (2 * BOX_SIZE) >= 10'd_477) text_pos_y <= text_pos_y
				else text_pos_y <= text_pos_y + BOX_SIZE
			end
		end
	end
	
	// Loop Display
	always @(posedge osc) begin
		if (is_display_active) begin
			//Draw Border
			if (((next_x >= 10'd_356) && (next_x < 10'd_357)) || ((next_x >= 10'd506) && (next_x < 10'd_507)) || ((next_x >= 10'd_4) && (next_x < 10'd_5)) 
			|| ((next_x >= 10'd_172) && (next_x < 10'd_173)) || ((next_x >= 10'd_356) && (next_x < 10'd_507) && (next_y >= 10'd_478)) 
			|| ((next_x >= 10'd_4) && (next_x < 10'd_172) && (next_y >= 10'd_478))) vga_rgb <= 3'b111;
			else vga_rgb <= 3'b000;
			
			//Draw Block
			if ((next_y >= text_pos_y) && (next_y < text_pos_y + 60)) begin
				if ((next_x >= text_pos_x) && (next_x < text_pos_x + 60)) begin
					if ((next_y - text_pos_y) / 15 == 0) if (blk_pixels0[(next_x - text_pos_x) / 15]) vga_rgb <= 3'b100;
					if ((next_y - text_pos_y) / 15 == 1) if (blk_pixels1[(next_x - text_pos_x) / 15]) vga_rgb <= 3'b100;
					if ((next_y - text_pos_y) / 15 == 2) if (blk_pixels2[(next_x - text_pos_x) / 15]) vga_rgb <= 3'b100;
					if ((next_y - text_pos_y) / 15 == 3) if (blk_pixels3[(next_x - text_pos_x) / 15]) vga_rgb <= 3'b100;
				end
			end
		
			// Draw S
			if ((next_y >= score_pos_y) && (next_y < score_pos_y + 10'd_4) && (next_x >= score_pos_x) && (next_x < score_pos_x + 10'd_25)) 
				vga_rgb <= 3'b111;
			if ((next_y >= score_pos_y + 10'd_4) && (next_y < score_pos_y + 10'd_10) && (next_x >= score_pos_x) && (next_x < score_pos_x + 10'd_6)) 
				vga_rgb <= 3'b111;
			if ((next_y >= score_pos_y + 10'd_8) && (next_y < score_pos_y + 10'd_12) && (next_x >= score_pos_x) && (next_x < score_pos_x + 10'd_25))
				vga_rgb <= 3'b111;
			if ((next_y >= score_pos_y + 10'd_12) && (next_y < score_pos_y + 10'd_18) && (next_x >= score_pos_x + 10'd_19) && (next_x < score_pos_x + 10'd_25))
				vga_rgb <= 3'b111;
			if ((next_y >= score_pos_y + 10'd_18) && (next_y < score_pos_y + 10'd_22) && (next_x >= score_pos_x) && (next_x < score_pos_x + 10'd_25))
				vga_rgb <= 3'b111;
			
			// Draw C
			if ((next_y >= score_pos_y) && (next_y < score_pos_y + 10'd_4) && (next_x >= score_pos_x + (1 * FONT_W) + FONT_D) && (next_x < score_pos_x + (1 * FONT_W) + FONT_D + 10'd_25))
				vga_rgb <= 3'b111;
			if ((next_y >= score_pos_y) && (next_y < score_pos_y + 10'd_22) && (next_x >= score_pos_x + (1 * FONT_W) + FONT_D) && (next_x < score_pos_x + (1 * FONT_W) + FONT_D + 10'd_6))
				vga_rgb <= 3'b111;
			if ((next_y >= score_pos_y + 10'd_18) && (next_y < score_pos_y + 10'd_22) && (next_x >= score_pos_x + (1 * FONT_W) + FONT_D) && (next_x < score_pos_x + (1 * FONT_W) + FONT_D + 10'd_25))
				vga_rgb <= 3'b111;
			
			// Draw O
			if ((next_y >= score_pos_y) && (next_y < score_pos_y + 10'd_4) && (next_x >= score_pos_x + (2 * FONT_W) + (2 * FONT_D)) && (next_x < score_pos_x + (2 * FONT_W) + (2 * FONT_D) + 10'd_25))
				vga_rgb <= 3'b111;
			if ((next_y >= score_pos_y) && (next_y < score_pos_y + 10'd_22) && (next_x >= score_pos_x + (2 * FONT_W) + (2 * FONT_D)) && (next_x < score_pos_x + (2 * FONT_W) + (2 * FONT_D) + 10'd_6))
				vga_rgb <= 3'b111;
			if ((next_y >= score_pos_y) && (next_y < score_pos_y + 10'd_22) && (next_x >= score_pos_x + (2 * FONT_W) + (2 * FONT_D) + 10'd_19) && (next_x < score_pos_x + (2 * FONT_W) + (2 * FONT_D) + 10'd_25))
				vga_rgb <= 3'b111;
			if ((next_y >= score_pos_y + 10'd_18) && (next_y < score_pos_y + 10'd_22) && (next_x >= score_pos_x + (2 * FONT_W) + (2 * FONT_D)) && (next_x < score_pos_x + (2 * FONT_W) + (2 * FONT_D) + 10'd_25))
				vga_rgb <= 3'b111;

			// Draw R
			if ((next_y >= score_pos_y) && (next_y < score_pos_y + 10'd_4) && (next_x >= score_pos_x + (3 * FONT_W) + (3 * FONT_D)) && (next_x < score_pos_x + (3 * FONT_W) + (3 * FONT_D) + 10'd_21))
				vga_rgb <= 3'b111;
			if ((next_y >= score_pos_y + 10'd_9) && (next_y < score_pos_y + 10'd_13) && (next_x >= score_pos_x + (3 * FONT_W) + (3 * FONT_D)) && (next_x < score_pos_x + (3 * FONT_W) + (3 * FONT_D) + 10'd_21))
				vga_rgb <= 3'b111;
			if ((next_y >= score_pos_y) && (next_y < score_pos_y + 10'd_22) && (next_x >= score_pos_x + (3 * FONT_W) + (3 * FONT_D)) && (next_x < score_pos_x + (3 * FONT_W) + (3 * FONT_D) + 10'd_6))
				vga_rgb <= 3'b111;
			if ((next_y >= score_pos_y + 10'd_4) && (next_y < score_pos_y + 10'd_9) && (next_x >= score_pos_x + (3 * FONT_W) + (3 * FONT_D) + 10'd_19) && (next_x < score_pos_x + (3 * FONT_W) + (3 * FONT_D) + 10'd_25))
				vga_rgb <= 3'b111;
			if ((next_y >= score_pos_y + 10'd_13) && (next_y < score_pos_y + 10'd_22) && (next_x >= score_pos_x + (3 * FONT_W) + (3 * FONT_D) + 10'd_19) && (next_x < score_pos_x + (3 * FONT_W) + (3 * FONT_D) + 10'd_25))
				vga_rgb <= 3'b111;

			// Draw E
			if ((next_y >= score_pos_y) && (next_y < score_pos_y + 10'd_4) && (next_x >= score_pos_x + (4 * FONT_W) + (4 * FONT_D)) && (next_x < score_pos_x + (4 * FONT_W) + (4 * FONT_D) + 10'd_25))
				vga_rgb <= 3'b111;
			if ((next_y >= score_pos_y + 10'd_9) && (next_y < score_pos_y + 10'd_13) && (next_x >= score_pos_x + (4 * FONT_W) + (4 * FONT_D)) && (next_x < score_pos_x + (4 * FONT_W) + (4 * FONT_D) + 10'd_25))
				vga_rgb <= 3'b111;
			if ((next_y >= score_pos_y) && (next_y < score_pos_y + 10'd_22) && (next_x >= score_pos_x + (4 * FONT_W) + (4 * FONT_D)) && (next_x < score_pos_x + (4 * FONT_W) + (4 * FONT_D) + 10'd_6))
				vga_rgb <= 3'b111;
			if ((next_y >= score_pos_y + 10'd_18) && (next_y < score_pos_y + 10'd_22) && (next_x >= score_pos_x + (4 * FONT_W) + (4 * FONT_D)) && (next_x < score_pos_x + (4 * FONT_W) + (4 * FONT_D) + 10'd_25))
				vga_rgb <= 3'b111;
		
			// Draw Digit0 for Player 1
			if ((next_y >= num1_pos_y) && (next_x >= num1_pos_x + (2 * 8) + (2 * 5)) && (next_y < num1_pos_y + (1 * 8)) && (next_x < num1_pos_x + (3 * 8) + (2 * 5)) && (pixels0_1[8 - (next_x - (num1_pos_x + (3 * 8) + (2 * 5)))]))
				vga_rgb <= 3'b111;
			// Draw Digit1 for Player 1
			if ((next_y >= num1_pos_y) && (next_x >= num1_pos_x + (1 * 8) + (1 * 5)) && (next_y < num1_pos_y + (1 * 8)) && (next_x < num1_pos_x + (2 * 8) + (1 * 5)) && (pixels1_1[8 - (next_x - (num1_pos_x + (2 * 8) + (1 * 5)))]))
				vga_rgb <= 3'b111;
			// Draw Digit2 for Player 1
			if ((next_y >= num1_pos_y) && (next_x >= num1_pos_x) && (next_y < num1_pos_y + (1 * 8)) && (next_x < num1_pos_x + (1 * 8)) && (pixels2_1[8 - (next_x - num1_pos_x)]))
				vga_rgb <= 3'b111;
		
			// Draw Digit0 for Player 2
			if ((next_y >= num2_pos_y) && (next_x >= num2_pos_x + (2 * 8) + (2 * 5)) && (next_y < num2_pos_y + (1 * 8)) && (next_x < num2_pos_x + (3 * 8) + (2 * 5)) && (pixels0_2[8 - (next_x - (num2_pos_x + (3 * 8) + (2 * 5)))]))
				vga_rgb <= 3'b111;
			// Draw Digit1 for Player 2
			if ((next_y >= num2_pos_y) && (next_x >= num2_pos_x + (1 * 8) + (1 * 5)) && (next_y < num2_pos_y + (1 * 8)) && (next_x < num2_pos_x + (2 * 8) + (1 * 5)) && (pixels1_2[8 - (next_x - (num2_pos_x + (2 * 8) + (1 * 5)))]))
				vga_rgb <= 3'b111;
			// Draw Digit2 for Player 2
			if ((next_y >= num2_pos_y) && (next_x >= num2_pos_x) && (next_y < num2_pos_y + (1 * 8)) && (next_x < num2_pos_x + (1 * 8)) && (pixels2_2[8 - (next_x - num2_pos_x)]))
				vga_rgb <= 3'b111;
		end
		else vga_rgb <= 3'b000;
	end
endmodule


