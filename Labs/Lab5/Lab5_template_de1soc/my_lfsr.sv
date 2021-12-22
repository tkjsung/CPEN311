`default_nettype none
`timescale 1ns/1ns

// CPEN 311 Lab 5 Code: my_lfsr.sv
// Author: Tom Sung
// Date: November 11, 2021
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
// Purpose: Linear-Feedback Shift Register (5-bit)
module my_lfsr(
	input logic clk,
	input logic reset_n,
	output logic [4:0] lfsr
);

logic xor_calc;
assign xor_calc = lfsr[0] ^ lfsr[2];

always_ff @ (posedge clk, negedge reset_n) begin
	if(~reset_n) lfsr <= 5'b00001;
	else lfsr <= {{xor_calc},{lfsr[4:1]}};
end

endmodule


// Testbench
module tb_my_lfsr();

logic clk;
logic reset_n;
logic [4:0] lfsr;
//logic xor_calc;

my_lfsr lfsr_inst (
	.clk(clk),
	.reset_n(reset_n),
	.lfsr(lfsr),
	//.xor_calc(xor_calc)
);

// generate clock
always begin
clk = 0; #2;
clk = 1; #2;
end

// Set reset to HIGH. It is active LOW.
initial begin
reset_n = 0; #2;
reset_n = 1;
end

endmodule
