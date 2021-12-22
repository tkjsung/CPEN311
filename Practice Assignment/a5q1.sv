// CPEN 311 Practice Assignment 5 Question 1: a5q1.sv
// Author: Tom Sung
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
module a5q1(
	input logic clk, sel, ina, inb, inc, drive,
	output logic y
);

logic q;

always_comb begin
	if(drive) y <= ina & q;
	else y <= 1'bz;
end

always_ff @ (posedge clk) begin
	if(sel) q <= inb;
	else q <= inc;
end

endmodule
