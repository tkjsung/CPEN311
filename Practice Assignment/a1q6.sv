// CPEN 311 Practice Assignment 1 Question 6: a1q6.sv
// Author: Tom Sung
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
module a1q6(
	input logic A, B,
	input logic CLK,
	output logic Z
);

logic D, Q;

always_ff @ (posedge CLK) Q <= D;

always_comb begin
	D = A&B;
	Z = A^Q;
end

endmodule
