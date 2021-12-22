// CPEN 311 Practice Assignment 2 Question 2: a2q2.sv
// Author: Tom Sung
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
module a2q2(
	input logic [15:0] data,
	input logic valid, clk, reset,
	output logic [15:0] sum
);

always_ff @ (posedge clk) begin
	if(reset) sum <= 16'd0;
	else begin
		if(valid) sum <= sum + data;
		else sum <= sum;
	end
end

endmodule


`timescale 1ns/1ns
module tb_a2q2();

logic clk, reset, valid;
logic [15:0] data, sum;

a2q2 assignment2q2(.clk(clk),.valid(valid),.reset(reset),.data(data),.sum(sum));

always begin
	clk = 0; #2; clk = 1; #2;
end

initial begin
	valid=1; #16;
	valid=0; #4;
	valid=1;
end

initial begin
	#3;
	data=3; #4;
	data=2; #4;
	data=1; #4;
	data=7; #4;
	data=2; #4;
	data=3;
end

initial begin
	reset = 1; #4; reset = 0;
end

endmodule
