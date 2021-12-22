`default_nettype none

// CPEN 311 Lab 2 Code: my_FDC.sv
// Author: Tom Sung
// Date: October 12, 2021
// Note: This code is taken from Homework 1, written by me.
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
module my_FDC(
	input logic d,
	input logic c,
	input logic clr,
	output logic q);
	
	always_ff @ (posedge c, posedge clr)
		if(clr) q <= 1'b0;
		else q <= d;
	
endmodule
