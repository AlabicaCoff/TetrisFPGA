`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:31:49 11/11/2023 
// Design Name: 
// Module Name:    calc_cur_blk 
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
module calc_cur_blk(
    input wire [2:0] piece,
    input wire [3:0] pos_x,
    input wire [4:0] pos_y,
    input wire [1:0] rot,
	 input wire [3:0] block_wide,
    output reg [7:0] blk_1,
    output reg [7:0] blk_2,
    output reg [7:0] blk_3,
    output reg [7:0] blk_4,
    output reg [2:0] width,
    output reg [2:0] height,
	 output reg [2:0] blk_color
    );
    
    always @ (*) begin
        case (piece)
            0: begin
                 if (rot == 1 || rot == 3) begin
                     blk_1 = (pos_y * block_wide) + pos_x;
                     blk_2 = ((pos_y + 1) * block_wide) + pos_x;
                     blk_3 = ((pos_y + 2) * block_wide) + pos_x;
                     blk_4 = ((pos_y + 3) * block_wide) + pos_x;
                     width = 1;
                     height = 4;

                 end else begin
                     blk_1 = (pos_y * block_wide) + pos_x;
                     blk_2 = (pos_y * block_wide) + pos_x + 1;
                     blk_3 = (pos_y * block_wide) + pos_x + 2;
                     blk_4 = (pos_y * block_wide) + pos_x + 3;
                     width = 4;
                     height = 1;
                 end
							blk_color = 3'b111;
            end
            1: begin
                 if (rot == 1 || rot == 3) begin
                     blk_1 = (pos_y * block_wide) + pos_x;
                     blk_2 = ((pos_y + 1) * block_wide) + pos_x;
                     blk_3 = ((pos_y + 2) * block_wide) + pos_x;
                     blk_4 = ((pos_y + 3) * block_wide) + pos_x;
                     width = 1;
                     height = 4;

                 end else begin
                     blk_1 = (pos_y * block_wide) + pos_x;
                     blk_2 = (pos_y * block_wide) + pos_x + 1;
                     blk_3 = (pos_y * block_wide) + pos_x + 2;
                     blk_4 = (pos_y * block_wide) + pos_x + 3;
                     width = 4;
                     height = 1;
                 end
							blk_color = 3'b111;
            end
            2: begin
                blk_1 = (pos_y * block_wide) + pos_x;
                blk_2 = (pos_y * block_wide) + pos_x + 1;
                blk_3 = ((pos_y + 1) * block_wide) + pos_x;
                blk_4 = ((pos_y + 1) * block_wide) + pos_x + 1;
                width = 2;
                height = 2;
					blk_color = 3'b101;
            end
            3: begin
                case (rot)
                    0: begin
                        blk_1 = (pos_y * block_wide) + pos_x + 1;
                        blk_2 = ((pos_y + 1) * block_wide) + pos_x;
                        blk_3 = ((pos_y + 1) * block_wide) + pos_x + 1;
                        blk_4 = ((pos_y + 1) * block_wide) + pos_x + 2;
                        width = 3;
                        height = 2;
                    end
                    1: begin
                        blk_1 = (pos_y * block_wide) + pos_x;
                        blk_2 = ((pos_y + 1) * block_wide) + pos_x;
                        blk_3 = ((pos_y + 2) * block_wide) + pos_x;
                        blk_4 = ((pos_y + 1) * block_wide) + pos_x + 1;
                        width = 2;
                        height = 3;
                    end
                    2: begin
                        blk_1 = (pos_y * block_wide) + pos_x;
                        blk_2 = (pos_y * block_wide) + pos_x + 1;
                        blk_3 = (pos_y * block_wide) + pos_x + 2;
                        blk_4 = ((pos_y + 1) * block_wide) + pos_x + 1;
                        width = 3;
                        height = 2;
                    end
                    3: begin
                        blk_1 = (pos_y * block_wide) + pos_x + 1;
                        blk_2 = ((pos_y + 1) * block_wide) + pos_x + 1;
                        blk_3 = ((pos_y + 2) * block_wide) + pos_x + 1;
                        blk_4 = ((pos_y + 1) * block_wide) + pos_x;
                        width = 2;
                        height = 3;
                    end

                endcase
							blk_color = 3'b100;
            end
            4: begin
                if (rot == 0 || rot == 2) begin
                    blk_1 = (pos_y * block_wide) + pos_x + 1;
                    blk_2 = (pos_y * block_wide) + pos_x + 2;
                    blk_3 = ((pos_y + 1) * block_wide) + pos_x;
                    blk_4 = ((pos_y + 1) * block_wide) + pos_x + 1;
                    width = 3;
                    height = 2;
                end else begin
                    blk_1 = (pos_y * block_wide) + pos_x;
                    blk_2 = ((pos_y + 1) * block_wide) + pos_x;
                    blk_3 = ((pos_y + 1) * block_wide) + pos_x + 1;
                    blk_4 = ((pos_y + 2) * block_wide) + pos_x + 1;
                    width = 2;
                    height = 3;
                end
					blk_color = 3'b011;						
            end
            5: begin
                if (rot == 0 || rot == 2) begin
                    blk_1 = (pos_y * block_wide) + pos_x;
                    blk_2 = (pos_y * block_wide) + pos_x + 1;
                    blk_3 = ((pos_y + 1) * block_wide) + pos_x + 1;
                    blk_4 = ((pos_y + 1) * block_wide) + pos_x + 2;
                    width = 3;
                    height = 2;
                end else begin
                    blk_1 = (pos_y * block_wide) + pos_x + 1;
                    blk_2 = ((pos_y + 1) * block_wide) + pos_x;
                    blk_3 = ((pos_y + 2) * block_wide) + pos_x;
                    blk_4 = ((pos_y + 1) * block_wide) + pos_x + 1;
                    width = 2;
                    height = 3;
                end
							blk_color = 3'b010;
            end
            6: begin
                case (rot)
                    0: begin
                        blk_1 = (pos_y * block_wide) + pos_x + 1;
                        blk_2 = ((pos_y + 1) * block_wide) + pos_x + 1;
                        blk_3 = ((pos_y + 2) * block_wide) + pos_x + 1;
                        blk_4 = ((pos_y + 2) * block_wide) + pos_x;
                        width = 2;
                        height = 3;
                    end
                    1: begin
                        blk_1 = (pos_y * block_wide) + pos_x;
                        blk_2 = ((pos_y + 1) * block_wide) + pos_x;
                        blk_3 = ((pos_y + 1) * block_wide) + pos_x + 1;
                        blk_4 = ((pos_y + 1) * block_wide) + pos_x + 2;
                        width = 3;
                        height = 2;
                    end
                    2: begin
                        blk_1 = (pos_y * block_wide) + pos_x;
                        blk_2 = ((pos_y + 1) * block_wide) + pos_x;
                        blk_3 = ((pos_y + 2) * block_wide) + pos_x;
                        blk_4 = (pos_y * block_wide) + pos_x + 1;
                        width = 2;
                        height = 3;
                    end
                    3: begin
                        blk_1 = (pos_y * block_wide) + pos_x;
                        blk_2 = (pos_y * block_wide) + pos_x + 1;
                        blk_3 = (pos_y * block_wide) + pos_x + 2;
                        blk_4 = ((pos_y + 1) * block_wide) + pos_x + 2;
                        width = 3;
                        height = 2;
                    end
							
                endcase
					 blk_color = 3'b001;
            end
            7: begin
                case (rot)
                    0: begin
                        blk_1 = (pos_y * block_wide) + pos_x;
                        blk_2 = ((pos_y + 1) * block_wide) + pos_x;
                        blk_3 = ((pos_y + 2) * block_wide) + pos_x;
                        blk_4 = ((pos_y + 2) * block_wide) + pos_x + 1;
                        width = 2;
                        height = 3;
                    end
                    1: begin
                        blk_1 = ((pos_y + 1) * block_wide) + pos_x;
                        blk_2 = (pos_y * block_wide) + pos_x;
                        blk_3 = (pos_y * block_wide) + pos_x + 1;
                        blk_4 = (pos_y * block_wide) + pos_x + 2;
                        width = 3;
                        height = 2;
                    end
                    2: begin
                        blk_1 = (pos_y * block_wide) + pos_x + 1;
                        blk_2 = ((pos_y + 1) * block_wide) + pos_x + 1;
                        blk_3 = ((pos_y + 2) * block_wide) + pos_x + 1;
                        blk_4 = (pos_y * block_wide) + pos_x;
                        width = 2;
                        height = 3;
                    end
                    3: begin
                        blk_1 = ((pos_y + 1) * block_wide) + pos_x;
                        blk_2 = ((pos_y + 1) * block_wide) + pos_x + 1;
                        blk_3 = ((pos_y + 1) * block_wide) + pos_x + 2;
                        blk_4 = (pos_y * block_wide) + pos_x + 2;
                        width = 3;
                        height = 2;
                    end
                endcase
							blk_color = 3'b110;
            end
        endcase
    end

endmodule
