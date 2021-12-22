`default_nettype none
// CPEN 311 Lab 1 Code: clk_divider.sv
// Author: Tom Sung
// Date: September 18, 2021
// Copyright (c) 2021 by Ke-Jun (Tom) Sung

// This module is the frequency divider used to time clock signals for various items, like LEDs.
module my_clk_divider(
	input logic inclk,
	input logic reset,
	input logic [31:0] clk_divisor,
	output logic outclk);

//clk_divisor: in_clk divided by (2*desired_frequency). The '2' accounts for 1 and 0 of the new clock.

// Counter referenced from example 5.5 DCCA pg.260)

	logic [31:0] counter;
	
	always_ff @ (posedge inclk, negedge reset)
	begin
		if(reset == 1'b0)
			counter <= 32'b0;
		else if(counter >= clk_divisor-1)
			counter <= 32'b0;
		else
			counter <= counter + 1;	
	end
	
	always_ff @ (posedge inclk, negedge reset) // This is asynchronous! Remember the sensitivity list
	begin
		if(reset == 1'b0)
			outclk <= 1'b0;
		else if(counter >= clk_divisor-1)
			outclk <= ~outclk;
		else
			outclk <= outclk;
	end	
endmodule
