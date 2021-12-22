`default_nettype none

// CPEN 311 Lab 1 Code: led_cycle.sv
// Author: Tom Sung
// Date: September 18, 2021
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
// Note: Module name has been modified for use in this lab.

// This module controls the LED cycle on the DE1-SoC board.
module my_led_cycle(input logic inclk, output logic [7:0] lights);
	
	logic [3:0] counter;
	// Alternatively, I could have done bit shift to potentially cut down on code lines.
	
	// Light States
	assign lights[0] = (counter == 4'b0001);
	assign lights[1] = (counter == 4'b0010) | (counter == 4'b1110);
	assign lights[2] = (counter == 4'b0011) | (counter == 4'b1101);
	assign lights[3] = (counter == 4'b0100) | (counter == 4'b1100);
	assign lights[4] = (counter == 4'b0101) | (counter == 4'b1011);
	assign lights[5] = (counter == 4'b0110) | (counter == 4'b1010);
	assign lights[6] = (counter == 4'b0111) | (counter == 4'b1001);
	assign lights[7] = (counter == 4'b1000);
	
	// Because of clock initialization when the system first runs, counter starts at 1 instead of 0.
	
	always_ff @ (posedge inclk)
		if(counter == 4'b1110) counter <= 4'b0001;
		else counter <= counter + 4'd1;
	
endmodule
