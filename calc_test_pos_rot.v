`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:31:19 11/11/2023 
// Design Name: 
// Module Name:    calc_test_pos_rot 
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
module calc_test_pos_rot(
    input wire [2:0]  mode,
    input wire                   game_clk,
    input wire                   btn_left_en,
    input wire                   btn_right_en,
    input wire                   btn_rotate_en,
    input wire                   btn_down_en,
    input wire [3:0] cur_pos_x,
    input wire [4:0] cur_pos_y,
    input wire [1:0]   cur_rot,
    output reg [3:0] test_pos_x,
    output reg [4:0] test_pos_y,
    output reg [1:0]   test_rot
    );

    always @ (*) begin
        if (mode == 2'd1) begin
            if (game_clk) begin
                test_pos_x = cur_pos_x;
                test_pos_y = cur_pos_y + 1; // move down
                test_rot = cur_rot;
            end else if (btn_left_en) begin
                test_pos_x = cur_pos_x - 1; // move left
                test_pos_y = cur_pos_y;
                test_rot = cur_rot;
            end else if (btn_right_en) begin
                test_pos_x = cur_pos_x + 1; // move right
                test_pos_y = cur_pos_y;
                test_rot = cur_rot;
            end else if (btn_rotate_en) begin
                test_pos_x = cur_pos_x;
                test_pos_y = cur_pos_y;
                test_rot = cur_rot + 1; // rotate
            end else if (btn_down_en) begin
                test_pos_x = cur_pos_x;
                test_pos_y = cur_pos_y + 1; // move down
                test_rot = cur_rot;
            end else begin
                // do nothing, the block isn't moving this cycle
                test_pos_x = cur_pos_x;
                test_pos_y = cur_pos_y;
                test_rot = cur_rot;
            end
        end else begin
            // Other mode, do nothing
            test_pos_x = cur_pos_x;
            test_pos_y = cur_pos_y;
            test_rot = cur_rot;
        end
    end

endmodule
