`timescale 1ns / 1ps

module Tetris(
	input osc,
	input sw_reset,
	input btn_left,
	input btn_right,
	input btn_down,
	input btn_rotate,
	input btn_play_pause,
	output h_sync,
	output v_sync,
	output reg [2:0] vga_rgb,
	output [3:0] common,
	output [6:0] segment,
	output [7:0] LED,
	output [7:0] MN
    );
	
	// Define Variables
	parameter [9:0] FONT_W = 10'd_25;
	parameter [9:0] FONT_H = 10'd_40;
	parameter [9:0] FONT_D = 10'd_5;
	
	// Declare Variables
	wire is_display_active;
	wire [9:0] next_x;
	wire [9:0] next_y;
	
	// Initial tetris pos
	reg [9:0] num1_pos_x = 10'd_190;
	reg [9:0] num1_pos_y = 10'd_80;
	reg [9:0] num2_pos_x = 10'd_240;
	reg [9:0] num2_pos_y = 10'd_80;
	reg [9:0] score_pos_x = 10'd_180;
	reg [9:0] score_pos_y = 10'd_20;
	
	reg [199:0] fallen_pieces;
	reg [199:0] red_fallen_pieces;
	reg [199:0] green_fallen_pieces;
	reg [199:0] blue_fallen_pieces;
	
	parameter [9:0] SECOND_BOARD_X = 10'd178;
	parameter [9:0] SECOND_BOARD_Y = 10'd179;
	
	parameter [2:0] MODE_IDLE = 3'd0;
	parameter [2:0] MODE_PLAY = 3'd1;
	parameter [2:0] MODE_PAUSE = 3'd2;
	parameter [2:0] MODE_GAMEOVER = 3'd3;
	
	parameter [3:0] BLOCK_WIDE = 4'd10;
	parameter [4:0] BLOCK_HEIGHT = 5'd20;
	parameter [9:0] BLOCK_SIZE = 10'd_15;
	

	reg [3:0] cur_pos_x;
	reg [4:0] cur_pos_y;
	reg [3:0] next_pos_x;
	reg [4:0] next_pos_y;
	reg [1:0] cur_rot;

	parameter [9:0] NEXT_BLK_X = 10'd240;
	parameter [8:0] NEXT_BLK_Y = 9'd140;
	
	wire [7:0] cur_blk_1;
	wire [7:0] cur_blk_2;
	wire [7:0] cur_blk_3;
	wire [7:0] cur_blk_4;

	wire [7:0] next_blk_1;
	wire [7:0] next_blk_2;
	wire [7:0] next_blk_3;
	wire [7:0] next_blk_4;
	
	wire [2:0] cur_width;
	wire [2:0] cur_height;
	reg [2:0] cur_piece = 4;
	reg [2:0] next_piece=3;
	wire [2:0] random_piece;
	
	reg [15:0] counter_400hz=0;
	reg [2:0] mode;
	
	reg [7:0] tmp_MN;
	reg [7:0] tmp_LED = 8'b10000000;
	
	initial begin
        mode = MODE_IDLE;

	end
	
	reg [3:0] tmp_common = 4'b1110;
	reg [6:0] tmp_segment;
	
	reg	[3:0] digit0_2; 
	reg	[3:0] digit1_2;
	reg	[3:0] digit2_2;

	reg	[3:0] digit0_1; 
	reg	[3:0] digit1_1;
	reg	[3:0] digit2_1;
	
	
	// vga_driver module for generate a vsync and hsync signal
	vga_driver driver(
						.clk(osc),
						.reset(sw_reset),
						.next_x(next_x),
						.next_y(next_y),
						.v_sync(v_sync),
						.h_sync(h_sync),
						.is_active(is_display_active)
						);
	
	wire game_clk;
	game_clock game_clock (.clk(osc), .rst(sw_reset), .pause( mode != MODE_PLAY), .score({digit2_1,digit1_1,digit_0_1}), .game_clk(game_clk));
					


	randomizer randomizer (.clk(osc), .random(random_piece));
	wire[2:0] cur_color_piece;
	
	
    calc_cur_blk calc_cur_blk (
        .piece(cur_piece),
        .pos_x(cur_pos_x),
        .pos_y(cur_pos_y),
        .rot(cur_rot),
		  .block_wide(BLOCK_WIDE),
        .blk_1(cur_blk_1),
        .blk_2(cur_blk_2),
        .blk_3(cur_blk_3),
        .blk_4(cur_blk_4),
        .width(cur_width),
        .height(cur_height),
		  .blk_color(cur_color_piece)
    );
	 wire [2:0] next_color_piece;
    calc_cur_blk calc_next_blk (
        .piece(next_piece),
        .pos_x(next_pos_x),
        .pos_y(next_pos_y),
		  .block_wide(4),
        .blk_1(next_blk_1),
        .blk_2(next_blk_2),
        .blk_3(next_blk_3),
        .blk_4(next_blk_4),
		  .blk_color(next_color_piece)
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

    wire btn_rotate_en;
    wire btn_left_en;
    wire btn_right_en;
    wire btn_down_en;
	 wire btn_play_pause_en;
    // Debounce all of the input signals
		
	 
    debounce debouncer_btn_rotate (
        .raw(btn_rotate),
        .clk(osc),
        .enabled(btn_rotate_en)
    );
    debounce debouncer_btn_left (
        .raw(btn_left),
        .clk(osc),
        .enabled(btn_left_en)
    );
    debounce debouncer_btn_right (
        .raw(btn_right),
        .clk(osc),
        .enabled(btn_right_en)
    );
    debounce debouncer_btn_down (
        .raw(btn_down),
        .clk(osc),
        .enabled(btn_down_en)
    );
    debounce debouncer_btn_p (
        .raw(btn_play_pause),
        .clk(osc),
        .enabled(btn_play_pause_en)
    );

	wire [3:0] test_pos_x;
	wire [4:0] test_pos_y;
	wire [1:0] test_rot;
   
	calc_test_pos_rot calc_test_pos_rot (
        .mode(mode),
        .game_clk(game_clk),
        .btn_left_en(btn_left_en),
        .btn_right_en(btn_right_en),
        .btn_rotate_en(btn_rotate_en),
        .btn_down_en(btn_down_en),
        .cur_pos_x(cur_pos_x),
        .cur_pos_y(cur_pos_y),
        .cur_rot(cur_rot),
        .test_pos_x(test_pos_x),
        .test_pos_y(test_pos_y),
        .test_rot(test_rot)
    );
    wire [7:0] test_blk_1;
    wire [7:0] test_blk_2;
    wire [7:0] test_blk_3;
    wire [7:0] test_blk_4;
    wire [2:0] test_width;
    wire [2:0] test_height;
	 
    calc_cur_blk calc_test_blk (
        .piece(cur_piece),
        .pos_x(test_pos_x),
        .pos_y(test_pos_y),
        .rot(test_rot),
		  .block_wide(BLOCK_WIDE),
        .blk_1(test_blk_1),
        .blk_2(test_blk_2),
        .blk_3(test_blk_3),
        .blk_4(test_blk_4),
        .width(test_width),
        .height(test_height)
    );
	 wire [6:0] seg_first_digit;
	 wire [6:0] seg_second_digit;
	 wire [6:0] seg_third_digit;
	 wire [6:0] seg_fourth_digit;
	 
	 BCD2SEVENSEGMENT bcd2sevensegment(.bcd(digit0_2),.seg(seg_first_digit));
	 BCD2SEVENSEGMENT bcd2sevensegment2(.bcd(digit1_2),.seg(seg_second_digit));
	 BCD2SEVENSEGMENT bcd2sevensegment3(.bcd(digit2_2),.seg(seg_third_digit));
	 BCD2SEVENSEGMENT bcd2sevensegment4(.bcd(0),.seg(seg_fourth_digit));

	 
	function intersects_fallen_pieces;
        input wire [7:0] blk1;
        input wire [7:0] blk2;
        input wire [7:0] blk3;
        input wire [7:0] blk4;
        begin
            intersects_fallen_pieces = fallen_pieces[blk1] ||
                                       fallen_pieces[blk2] ||
                                       fallen_pieces[blk3] ||
                                       fallen_pieces[blk4];
        end
    endfunction

    // This signal goes high when the test positions/rotations intersect with
    // fallen blocks.
    wire test_intersects = intersects_fallen_pieces(test_blk_1, test_blk_2, test_blk_3, test_blk_4);
    // If the falling piece can be moved left, moves it left
    task move_left;
        begin
            if (cur_pos_x > 0 && !test_intersects) begin
                cur_pos_x <= cur_pos_x - 1;
            end
        end
    endtask

    // If the falling piece can be moved right, moves it right
    task move_right;
        begin
            if (cur_pos_x + cur_width < BLOCK_WIDE && !test_intersects) begin
                cur_pos_x <= cur_pos_x + 1;
            end
        end
    endtask

    // Rotates the current block if it would not cause any part of the
    // block to go off screen and would not intersect with any fallen blocks.
    task rotate;
        begin
            if (cur_pos_x + test_width <= BLOCK_WIDE &&
                cur_pos_y + test_height <= BLOCK_HEIGHT &&
                !test_intersects) begin
                cur_rot <= cur_rot + 1;
            end
        end
    endtask

    // Adds the current block to fallen_pieces
    task add_to_fallen_pieces;
        begin
            fallen_pieces[cur_blk_1] <= 1;
            fallen_pieces[cur_blk_2] <= 1;
            fallen_pieces[cur_blk_3] <= 1;
            fallen_pieces[cur_blk_4] <= 1;
				
            red_fallen_pieces[cur_blk_1] <= cur_color_piece[2];
            red_fallen_pieces[cur_blk_2] <= cur_color_piece[2];
            red_fallen_pieces[cur_blk_3] <= cur_color_piece[2];
            red_fallen_pieces[cur_blk_4] <= cur_color_piece[2];
				
            green_fallen_pieces[cur_blk_1] <= cur_color_piece[1];
            green_fallen_pieces[cur_blk_2] <= cur_color_piece[1];
            green_fallen_pieces[cur_blk_3] <= cur_color_piece[1];
            green_fallen_pieces[cur_blk_4] <= cur_color_piece[1];
				
            blue_fallen_pieces[cur_blk_1] <= cur_color_piece[0];
            blue_fallen_pieces[cur_blk_2] <= cur_color_piece[0];
            blue_fallen_pieces[cur_blk_3] <= cur_color_piece[0];
            blue_fallen_pieces[cur_blk_4] <= cur_color_piece[0];
				
        end
    endtask

    // Adds the given blocks to fallen_pieces, and
    // chooses a new block for the user that appears
    // at the top of the screen.
    task get_new_block;
        begin
            // Reset the drop timer, can't drop until this is high enough
            //drop_timer <= 0;
            // Choose a new block for the user
            cur_piece <= next_piece;
				next_piece <= random_piece;
				
            cur_pos_x <= (BLOCK_WIDE / 2) - 1;
            cur_pos_y <= 0;
            cur_rot <= 0;
            // reset the game timer so the user has a full
            // cycle before the block falls
            //game_clk_rst <= 1;
        end
    endtask

    // Moves the current piece down one, getting a new block if
    // the piece would go off the board or intersect with another block.
    task move_down;
        begin
            if (cur_pos_y + cur_height < BLOCK_HEIGHT && !test_intersects) begin
                cur_pos_y <= cur_pos_y + 1;

            end else begin
                add_to_fallen_pieces();
						get_new_block();
            end
        end
    endtask
	 
	 task start_game;
		begin
			mode <= MODE_PLAY;
			fallen_pieces <= 0;
			red_fallen_pieces <= 0;
			green_fallen_pieces <= 0;
			blue_fallen_pieces <= 0;
			tmp_LED <= 8'b10000000;
			digit0_2 <= 0;
			digit1_2 <= 0;
			digit2_2 <= 0;
			get_new_block();
		end
	endtask
	wire game_over = cur_pos_y == 0 && intersects_fallen_pieces(cur_blk_1, cur_blk_2, cur_blk_3, cur_blk_4);
	wire enabled;
	shift_register shift_bit (.clk(osc), .ce((mode == MODE_PLAY) || (mode == MODE_PAUSE)), .game_clk(enabled));
	// Main Logic
	integer i;
	integer j;
	always @(posedge osc) begin
		// Reset
		
		if(counter_400hz >= 6000) begin
			tmp_common <= 4'b0111;
			tmp_segment <= seg_fourth_digit;
		end else if(counter_400hz >= 4000) begin
			tmp_common <= 4'b1011;
			tmp_segment <= seg_third_digit;
		end else if(counter_400hz >= 2000) begin
			tmp_common <= 4'b1101;
			tmp_segment <= seg_second_digit;
		end else if(counter_400hz >= 0) begin
			tmp_common <= 4'b1110;
			tmp_segment <= seg_first_digit;
		end 
		counter_400hz <= (counter_400hz == 8000)? 0:counter_400hz +1;
		if (sw_reset) begin 
			cur_piece <= 0;
			cur_pos_x <= 0;
			cur_pos_y <= 0;
			cur_rot <= 0;
			fallen_pieces <= 0;
			red_fallen_pieces <= 0;
			green_fallen_pieces <= 0;
			blue_fallen_pieces <= 0;
			tmp_LED <= 8'b10000000;
			digit0_2 <=0;
			digit1_2 <=0;
			digit2_2 <=0;
			mode <= MODE_IDLE;
			
		end else begin
			
			for(i = 0; i < 20; i=i+1) begin
				if(&fallen_pieces[(i*BLOCK_WIDE)+:BLOCK_WIDE]) begin
					fallen_pieces[0+:BLOCK_WIDE] <= 0;
					red_fallen_pieces[0+:BLOCK_WIDE] <= 0;
					green_fallen_pieces[0+:BLOCK_WIDE] <= 0;
					green_fallen_pieces[0+:BLOCK_WIDE] <= 0;
					
					for(j = i; j > 0; j = j -1) begin
						fallen_pieces[(j*BLOCK_WIDE)+:BLOCK_WIDE] <= fallen_pieces[((j-1)*BLOCK_WIDE)+:BLOCK_WIDE];
						red_fallen_pieces[(j*BLOCK_WIDE)+:BLOCK_WIDE] <= red_fallen_pieces[((j-1)*BLOCK_WIDE)+:BLOCK_WIDE];
						green_fallen_pieces[(j*BLOCK_WIDE)+:BLOCK_WIDE] <= green_fallen_pieces[((j-1)*BLOCK_WIDE)+:BLOCK_WIDE];
						blue_fallen_pieces[(j*BLOCK_WIDE)+:BLOCK_WIDE] <= blue_fallen_pieces[((j-1)*BLOCK_WIDE)+:BLOCK_WIDE];

					end
					

					// Increment value, rolling over digits at 9 digit1_2
					if (digit0_2 != 4'd9) begin
					  // Regular increment digit 0
					  digit0_2 <= digit0_2 + 1'b1;
					end else begin
					  // Carry from digit 0
					  digit0_2 <= 4'd0;
					  if (digit1_2 != 4'd9) begin
						 // Regular increment digit 1
							digit1_2 <= digit1_2 + 1'b1;
					  end else begin
						 // Carry from digit 1
						 digit1_2 <= 4'd0;
						 digit2_2 <= digit2_2 + 1'b1;
					  end
					end

					
				 end					
					
				
			end
			if(enabled) begin
				tmp_LED <= (tmp_LED == 1) ? 8'b10000000 : (tmp_LED >> 1);
			end
			if((mode == MODE_PLAY) || (mode == MODE_PAUSE)) begin
				tmp_MN <= 8'b11111111;
			end else begin
				tmp_MN <= 8'b00000000;
			end
			
			if((mode == MODE_IDLE || mode == MODE_GAMEOVER) && btn_play_pause_en) begin
				start_game();
			end else if((mode == MODE_PLAY) && (btn_play_pause_en)) begin
				mode <= MODE_PAUSE;
			end else if((mode == MODE_PAUSE) &&(btn_play_pause_en)) begin
				mode <= MODE_PLAY;
			end else if(mode == MODE_PLAY) begin
            if (game_clk) begin
                move_down();
            end if (btn_left_en) begin
                move_left();
            end else if (btn_right_en) begin
                move_right();
            end else if (btn_rotate_en) begin
                rotate();
            end else if (btn_down_en) begin
                move_down();
            end else if (game_over) begin
					
					add_to_fallen_pieces();
					mode <= MODE_GAMEOVER;
					tmp_LED <= 8'b10000000;
				
				end
			end
		  
		end
	end
	
	 
	// Loop Display
	always @(posedge osc) begin
		if (is_display_active) begin
				

			//Draw Border
			/*if (((next_x >= 10'd_356) && (next_x < 10'd_357)) || ((next_x >= 10'd507) && (next_x < 10'd_508)) || ((next_x >= 10'd_3) && (next_x < 10'd_4)) 
					|| ((next_x >= 10'd_154) && (next_x < 10'd_155)) || ((next_x >= 10'd_356) && (next_x < 10'd_507) && (next_y >= 10'd_479)) 
					|| ((next_x >= 10'd_3) && (next_x < 10'd_155) && (next_y >= 10'd_479)) || ((next_x >= 10'd356) && (next_x < 508) &&(next_y >= 178) &&(next_y <179))
					|| ((next_x >= 10'd3) && (next_x < 357) &&(next_y >= 178) &&(next_y <179))) vga_rgb <= 3'b111;
			else
				vga_rgb <= 3'b000;*/
				
				
			if( (next_x >= SECOND_BOARD_X-1 && next_x < SECOND_BOARD_X&& next_y >= 0 && next_y <480) ||
				(next_x >= SECOND_BOARD_X+150 && next_x < SECOND_BOARD_X+151 && next_y >= 0 && next_y <480) ||
				(next_x >= SECOND_BOARD_X-1 && next_x < SECOND_BOARD_X+152 && next_y >= 178 && next_y <179) ||
				(next_x >= SECOND_BOARD_X-1 && next_x < SECOND_BOARD_X+152 && next_y >= 479 && next_y <480)
				
			)
				vga_rgb <= 3'b111;
			else
				 vga_rgb <= 3'b000;

			if((next_x >= SECOND_BOARD_X) && (next_x < SECOND_BOARD_X + (BLOCK_SIZE*BLOCK_WIDE)) && (next_y >= SECOND_BOARD_Y) && (next_y < SECOND_BOARD_Y + (BLOCK_SIZE*BLOCK_HEIGHT))) begin
				if(fallen_pieces[(((next_y-SECOND_BOARD_Y)/BLOCK_SIZE)*BLOCK_WIDE)+((next_x-SECOND_BOARD_X)/BLOCK_SIZE)] == 1) begin
					//vga_rgb <= 3'b001;
					vga_rgb <= {red_fallen_pieces[(((next_y-SECOND_BOARD_Y)/BLOCK_SIZE)*BLOCK_WIDE)+((next_x-SECOND_BOARD_X)/BLOCK_SIZE)],
									green_fallen_pieces[(((next_y-SECOND_BOARD_Y)/BLOCK_SIZE)*BLOCK_WIDE)+((next_x-SECOND_BOARD_X)/BLOCK_SIZE)],
									blue_fallen_pieces[(((next_y-SECOND_BOARD_Y)/BLOCK_SIZE)*BLOCK_WIDE)+((next_x-SECOND_BOARD_X)/BLOCK_SIZE)]
									};
		
				end
				else if(mode != MODE_IDLE && mode != MODE_GAMEOVER) begin
					if((next_x >= (SECOND_BOARD_X+(cur_blk_1%BLOCK_WIDE)*BLOCK_SIZE) && next_x <(SECOND_BOARD_X+(cur_blk_1%BLOCK_WIDE)*BLOCK_SIZE) + BLOCK_SIZE)&&(next_y >= (SECOND_BOARD_Y+(cur_blk_1/BLOCK_WIDE)*BLOCK_SIZE) && next_y <(SECOND_BOARD_Y+(cur_blk_1/BLOCK_WIDE)*BLOCK_SIZE) + BLOCK_SIZE))
						vga_rgb <= cur_color_piece;
					if((next_x >= (SECOND_BOARD_X+(cur_blk_2%BLOCK_WIDE)*BLOCK_SIZE) && next_x <(SECOND_BOARD_X+(cur_blk_2%BLOCK_WIDE)*BLOCK_SIZE) + BLOCK_SIZE)&&(next_y >= (SECOND_BOARD_Y+(cur_blk_2/BLOCK_WIDE)*BLOCK_SIZE) && next_y <(SECOND_BOARD_Y+(cur_blk_2/BLOCK_WIDE)*BLOCK_SIZE) + BLOCK_SIZE))
						vga_rgb <= cur_color_piece;
					if((next_x >= (SECOND_BOARD_X+(cur_blk_3%BLOCK_WIDE)*BLOCK_SIZE) && next_x <(SECOND_BOARD_X+(cur_blk_3%BLOCK_WIDE)*BLOCK_SIZE) + BLOCK_SIZE)&&(next_y >= (SECOND_BOARD_Y+(cur_blk_3/BLOCK_WIDE)*BLOCK_SIZE) && next_y <(SECOND_BOARD_Y+(cur_blk_3/BLOCK_WIDE)*BLOCK_SIZE) + BLOCK_SIZE))
						vga_rgb <= cur_color_piece;
					if((next_x >= (SECOND_BOARD_X+(cur_blk_4%BLOCK_WIDE)*BLOCK_SIZE) && next_x <(SECOND_BOARD_X+(cur_blk_4%BLOCK_WIDE)*BLOCK_SIZE) + BLOCK_SIZE)&&(next_y >= (SECOND_BOARD_Y+(cur_blk_4/BLOCK_WIDE)*BLOCK_SIZE) && next_y <(SECOND_BOARD_Y+(cur_blk_4/BLOCK_WIDE)*BLOCK_SIZE) + BLOCK_SIZE))
						vga_rgb <= cur_color_piece;
				end
			end

			if(mode != MODE_IDLE && mode != MODE_GAMEOVER) begin
					if((next_x >= (NEXT_BLK_X+(next_blk_1%4)*10) && next_x <(NEXT_BLK_X+(next_blk_1%4)*10) + 10)&&(next_y >= (NEXT_BLK_Y+(next_blk_1/4)*10) && next_y <(NEXT_BLK_Y+(next_blk_1/4)*10) + 10))
						vga_rgb <= next_color_piece;
					if((next_x >= (NEXT_BLK_X+(next_blk_2%4)*10) && next_x <(NEXT_BLK_X+(next_blk_2%4)*10) + 10)&&(next_y >= (NEXT_BLK_Y+(next_blk_2/4)*10) && next_y <(NEXT_BLK_Y+(next_blk_2/4)*10) + 10))
						vga_rgb <= next_color_piece;
					if((next_x >= (NEXT_BLK_X+(next_blk_3%4)*10) && next_x <(NEXT_BLK_X+(next_blk_3%4)*10) + 10)&&(next_y >= (NEXT_BLK_Y+(next_blk_3/4)*10) && next_y <(NEXT_BLK_Y+(next_blk_3/4)*10) + 10))
						vga_rgb <= next_color_piece;
					if((next_x >= (NEXT_BLK_X+(next_blk_4%4)*10) && next_x <(NEXT_BLK_X+(next_blk_4%4)*10) + 10)&&(next_y >= (NEXT_BLK_Y+(next_blk_4/4)*10) && next_y <(NEXT_BLK_Y+(next_blk_4/4)*10) + 10))
						vga_rgb <= next_color_piece;
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
	assign common = tmp_common;
	assign segment = tmp_segment;
	assign LED = tmp_LED;
	assign MN = tmp_MN;
endmodule


