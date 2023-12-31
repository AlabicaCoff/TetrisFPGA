`timescale 1ns / 1ps
// Formatting Block Shape
// 0: T, 1: I, 2: O, 3: L, 4: J, 5: S, 6: Z
module blocks_module(
	input [2:0] type,
    input [2:0] rot,
    output reg [3:0] pixels0,
	output reg [3:0] pixels1,
	output reg [3:0] pixels2,
	output reg [3:0] pixels3,
	output reg [9:0] width,
	output reg [9:0] height
    );
	
	always @ (*) begin
        case (type)
            0: begin
                case (rot)
					0: begin
						pixels0 = 4'b0111;
						pixels1 = 4'b0010;
						pixels2 = 4'b0000;
						pixels3 = 4'b0000;
						width = 10'd_3;
						height = 10'd_2;
					end
					1: begin
						pixels0 = 4'b0010;
						pixels1 = 4'b0011;
						pixels2 = 4'b0010;
						pixels3 = 4'b0000;
						width = 10'd_2;
						height = 10'd_3;
					end
					2: begin
						pixels0 = 4'b0010;
						pixels1 = 4'b0111;
						pixels2 = 4'b0000;
						pixels3 = 4'b0000;
						width = 10'd_3;
						height = 10'd_2;
					end
					3: begin
						pixels0 = 4'b0001;
						pixels1 = 4'b0011;
						pixels2 = 4'b0001;
						pixels3 = 4'b0000;
						width = 10'd_2;
						height = 10'd_3;
					end
				endcase
            end

			1: begin
				case (rot)
					1: begin
						pixels0 = 4'b0010;
						pixels1 = 4'b0010;
						pixels2 = 4'b0010;
						pixels3 = 4'b0010;
						width = 10'd_1;
						height = 10'd_4;
						end
					2: begin
						pixels0 = 4'b0000;
						pixels1 = 4'b0000;
						pixels2 = 4'b1111;
						pixels3 = 4'b0000;
						width = 10'd_4;
						height = 10'd_1;
					end
					3: begin
						pixels0 = 4'b0100;
						pixels1 = 4'b0100;
						pixels2 = 4'b0100;
						pixels3 = 4'b0100;
						width = 10'd_1;
						height = 10'd_4;
					end
					0: begin
						pixels0 = 4'b0000;
						pixels1 = 4'b1111;
						pixels2 = 4'b0000;
						pixels3 = 4'b0000;
						width = 10'd_4;
						height = 10'd_1;
					end
				endcase
			end

			2: begin
				pixels0 = 4'b0011;
				pixels1 = 4'b0011;
				pixels2 = 4'b0000;
				pixels3 = 4'b0000;
				width = 10'd_2;
				height = 10'd_2;
			end

			3: begin
				case (rot)
					0: begin
						pixels0 = 4'b0001;
						pixels1 = 4'b0001;
						pixels2 = 4'b0011;
						pixels3 = 4'b0000;
						width = 10'd_2;
						height = 10'd_3;
					end
					1: begin
						pixels0 = 4'b0111;
						pixels1 = 4'b0001;
						pixels2 = 4'b0000;
						pixels3 = 4'b0000;
						width = 10'd_3;
						height = 10'd_2;
					end
					2: begin
						pixels0 = 4'b0011;
						pixels1 = 4'b0010;
						pixels2 = 4'b0010;
						pixels3 = 4'b0000;
						width = 10'd_2;
						height = 10'd_3;
					end
					3: begin
						pixels0 = 4'b0100;
						pixels1 = 4'b0111;
						pixels2 = 4'b0000;
						pixels3 = 4'b0000;
						width = 10'd_3;
						height = 10'd_2;
					end
				endcase
			end

			4: begin
				case (rot)
					0: begin
						pixels0 = 4'b0010;
						pixels1 = 4'b0010;
						pixels2 = 4'b0011;
						pixels3 = 4'b0000;
						width = 10'd_2;
						height = 10'd_3;
					end
					1: begin
						pixels0 = 4'b0001;
						pixels1 = 4'b0111;
						pixels2 = 4'b0000;
						pixels3 = 4'b0000;
						width = 10'd_3;
						height = 10'd_2;
					end
					2: begin
						pixels0 = 4'b0011;
						pixels1 = 4'b0001;
						pixels2 = 4'b0001;
						pixels3 = 4'b0000;
						width = 10'd_2;
						height = 10'd_3;
					end
					3: begin
						pixels0 = 4'b0111;
						pixels1 = 4'b0100;
						pixels2 = 4'b0000;
						pixels3 = 4'b0000;
						width = 10'd_3;
						height = 10'd_2;
					end
				endcase
			end

			5: begin
				case (rot)
					0: begin
						pixels0 = 4'b0110;
						pixels1 = 4'b0011;
						pixels2 = 4'b0000;
						pixels3 = 4'b0000;
						width = 10'd_3;
						height = 10'd_2;
					end
					1: begin
						pixels0 = 4'b0001;
						pixels1 = 4'b0011;
						pixels2 = 4'b0010;
						pixels3 = 4'b0000;
						width = 10'd_2;
						height = 10'd_3;
					end
					2: begin
						pixels0 = 4'b0110;
						pixels1 = 4'b0011;
						pixels2 = 4'b0000;
						pixels3 = 4'b0000;
						width = 10'd_3;
						height = 10'd_2;
					end
					3: begin
						pixels0 = 4'b0001;
						pixels1 = 4'b0011;
						pixels2 = 4'b0010;
						pixels3 = 4'b0000;
						width = 10'd_2;
						height = 10'd_3;
					end
				endcase
			end

			6: begin
				case (rot)
					0: begin
						pixels0 = 4'b0011;
						pixels1 = 4'b0110;
						pixels2 = 4'b0000;
						pixels3 = 4'b0000;
						width = 10'd_3;
						height = 10'd_2;
					end
					1: begin
						pixels0 = 4'b0010;
						pixels1 = 4'b0011;
						pixels2 = 4'b0001;
						pixels3 = 4'b0000;
						width = 10'd_2;
						height = 10'd_3;
					end
					2: begin
						pixels0 = 4'b0011;
						pixels1 = 4'b0110;
						pixels2 = 4'b0000;
						pixels3 = 4'b0000;
						width = 10'd_3;
						height = 10'd_2;
					end
					3: begin
						pixels0 = 4'b0010;
						pixels1 = 4'b0011;
						pixels2 = 4'b0001;
						pixels3 = 4'b0000;
						width = 10'd_2;
						height = 10'd_3;
					end
				endcase
			end	
		endcase
	end
endmodule
