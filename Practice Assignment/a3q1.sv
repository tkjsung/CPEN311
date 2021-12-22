// CPEN 311 Practice Assignment 3 Question 1: a3q1.sv
// Author: Tom Sung
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
`default_nettype none
module a3q1(
	input logic clk, w,
	output logic z
);

logic y0, y1;
assign z = y1 & ~y0;

always_ff @ (posedge clk) begin
	y1 <= (w&y1) | (~w & y0);
	y0 <= (~w&y0) | (~y1&w);
end

endmodule
