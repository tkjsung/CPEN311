`default_nettype none

// CPEN 311 Lab 2 Code: my_speed_ctrl.sv
// Author: Tom Sung
// Date: October 13, 2021
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
module my_speed_ctrl(
	input logic inclk,
	input logic speed_up, speed_down, speed_rst,
	output logic [31:0] speed_clk_divisor
);

//parameter speed_default = 32'd614; // for 22-kHz clk. 27MHz/2/22000 = 614 (rounded)
parameter speed_default = 32'd307; // for 44-kHz clk.

logic [2:0] speed_ctrl;
assign speed_ctrl[0] = speed_down;
assign speed_ctrl[1] = speed_up;
assign speed_ctrl[2] = speed_rst;

reg [31:0] temp_speed = speed_default;
assign speed_clk_divisor = temp_speed;

always_ff @ (posedge inclk)
begin
	case(speed_ctrl)
		3'b001: temp_speed <= temp_speed - 32'h10;
		3'b010: temp_speed <= temp_speed + 32'h10;
		3'b100: temp_speed <= speed_default;
		default: temp_speed <= temp_speed;
	endcase
end

endmodule
