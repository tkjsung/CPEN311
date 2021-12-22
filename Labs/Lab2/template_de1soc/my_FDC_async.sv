`default_nettype none

// CPEN 311 Lab 2 Code: my_FDC_async.sv
// Author: Tom Sung
// Date: October 12, 2021
// Note: This code is taken from Homework 1, written by me.
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
module my_FDC_async(
	input logic async_sig,
	input logic outclk,
	output logic out_sync_sig);
	
	logic first_q, second_q, fdc1_q;
	
	my_FDC first_fdc(
		.d(1'b1),
		.c(async_sig),
		.clr(fdc1_q),
		.q(first_q));
		
	my_FDC second_fdc(
		.d(first_q),
		.c(outclk),
		.q(second_q),
		.clr(1'b0));
		
	my_FDC third_fdc(
		.d(second_q),
		.c(outclk),
		.clr(1'b0),
		.q(out_sync_sig));
	
	my_FDC FDC_1(
		.d(out_sync_sig),
		.c(~outclk),
		.clr(1'b0),
		.q(fdc1_q));
		
endmodule
