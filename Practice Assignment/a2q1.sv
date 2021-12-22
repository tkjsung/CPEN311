// CPEN 311 Practice Assignment 2 Question 1: a2q1.sv
// Author: Tom Sung
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
module a2q1(
	input logic clk, reset,
	output logic outs,
	output logic q1, q2, q3, q4, d // for modelsim
);

always_ff @ (posedge clk, posedge reset) begin
	if(reset) begin
		d <= 1'b1;
		q1 <= 1'b0;
		q2 <= 1'b0;
		q3 <= 1'b0;
		q4 <= 1'b0;
		outs <= 1'b0;
	end
	else begin
		d <= q4 ^ outs;
		q1 <= d;
		q2 <= q1;
		q3 <= q2;
		q4 <= q3;
		outs <= q4;
	end
end

endmodule

`timescale 1ns/1ns
module tb_a2q1();

logic clk, reset, outs;
logic q1, q2, q3, q4, d;
a2q1 assignment2q1(.clk(clk), .reset(reset),.outs(outs),.q1(q1),.q2(q2),.q3(q3),.q4(q4),.d(d));

always begin
	clk = 0; #1; clk = 1; #1;
end

initial begin
	reset = 1; #4; reset = 0;
end


endmodule
