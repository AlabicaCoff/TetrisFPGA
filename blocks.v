`timescale 1ns / 1ps

module blocks(
	input [2:0] type,
   	input [1:0] rownum,
   	output reg [3:0] pixels [3:0]
    );
	
	always @ (*) begin
        case (type)
            0: begin
                case (rownum)
					1: begin
						pixels[0] = 4'b0111;
						pixels[1] = 4'b0010;
						pixels[2] = 4'b0000;
						pixels[3] = 4'b0000;
					end
					2: begin
						pixels[0] = 4'b0010;
						pixels[1] = 4'b0011;
						pixels[2] = 4'b0010;
						pixels[3] = 4'b0000;
					end
					3: begin
						pixels[0] = 4'b0010;
						pixels[1] = 4'b0111;
						pixels[2] = 4'b0000;
						pixels[3] = 4'b0000;
					end
					4: begin
						pixels[0] = 4'b0001;
						pixels[1] = 4'b0011;
						pixels[2] = 4'b0001;
						pixels[3] = 4'b0000;
					end
				endcase
            end
			1: begin
				case (rownum)
					1: begin
						pixels[0] = 4'b0010;
						pixels[1] = 4'b0010;
						pixels[2] = 4'b0010;
						pixels[3] = 4'b0010;
					end
					2: begin
						pixels[0] = 4'b0000;
						pixels[1] = 4'b0000;
						pixels[2] = 4'b1111;
						pixels[3] = 4'b0000;
					end
					3: begin
						pixels[0] = 4'b0100;
						pixels[1] = 4'b0100;
						pixels[2] = 4'b0100;
						pixels[3] = 4'b0100;
					end
					4: begin
						pixels[0] = 4'b0000;
						pixels[1] = 4'b1111;
						pixels[2] = 4'b0000;
						pixels[3] = 4'b0000;
					end
				endcase
			end
			2: begin
				pixels[0] = 4'b0110;
				pixels[1] = 4'b0110;
				pixels[2] = 4'b0000;
				pixels[3] = 4'b0000;
			end
			3: begin
				case (rownum)
					0: begin
						pixels[0] = 4'b0001;
						pixels[1] = 4'b0001;
						pixels[2] = 4'b0011;
						pixels[3] = 4'b0000;
					end
					1: begin
						pixels[0] = 4'b0111;
						pixels[1] = 4'b0001;
						pixels[2] = 4'b0000;
						pixels[3] = 4'b0000;
					end
					2: begin
						pixels[0] = 4'b0011;
						pixels[1] = 4'b0010;
						pixels[2] = 4'b0010;
						pixels[3] = 4'b0000;
					end
					3: begin
						pixels[0] = 4'b0100;
						pixels[1] = 4'b0111;
						pixels[2] = 4'b0000;
						pixels[3] = 4'b0000;
					end
				endcase
			end

			4: begin
				case (rownum)
					0: begin
						pixels[0] = 4'b0010;
						pixels[1] = 4'b0010;
						pixels[2] = 4'b0011;
						pixels[3] = 4'b0000;
					end
					1: begin
						pixels[0] = 4'b0001;
						pixels[1] = 4'b0111;
						pixels[2] = 4'b0000;
						pixels[3] = 4'b0000;
					end
					2: begin
						pixels[0] = 4'b0011;
						pixels[1] = 4'b0001;
						pixels[2] = 4'b0001;
						pixels[3] = 4'b0000;
					end
					3: begin
						pixels[0] = 4'b0111;
						pixels[1] = 4'b0100;
						pixels[2] = 4'b0000;
						pixels[3] = 4'b0000;
					end
				endcase
			end

			5: begin
				case (rownum)
					0: begin
						pixels[0] = 4'b0110;
						pixels[1] = 4'b0011;
						pixels[2] = 4'b0000;
						pixels[3] = 4'b0000;
					end
					1: begin
						pixels[0] = 4'b0001;
						pixels[1] = 4'b0011;
						pixels[2] = 4'b0010;
						pixels[3] = 4'b0000;
					end
				endcase
			end

			6: begin
				case (rownum)
					0: begin
						pixels[0] = 4'b0011;
						pixels[1] = 4'b0110;
						pixels[2] = 4'b0000;
						pixels[3] = 4'b0000;
					end
					1: begin
						pixels[0] = 4'b0010;
						pixels[1] = 4'b0011;
						pixels[2] = 4'b0001;
						pixels[3] = 4'b0000;
					end
				endcase
			end
		endcase
	end
endmodule
