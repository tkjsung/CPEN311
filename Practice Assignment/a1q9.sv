// CPEN 311 Practice Assignment 1 Question 9: a1q9.sv
// Author: Tom Sung
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
module a1q9(
	input logic clk, reset,
	output logic [7:0] counter
);

logic [3:0] tens, ones;
assign counter[3:0] = ones;
assign counter[7:4] = tens;

always_ff @ (posedge clk) begin
	if(reset) begin
		ones <= 0;
		tens <= 0;
	end
	else begin
		if(ones >= 4'b1001) begin
			ones <= 4'd0;
			if(tens >= 4'b1001) tens <= 4'd0;
			else tens <= tens + 1'b1;
		end
		else ones <= ones + 1'b1;
	end
end

endmodule

`timescale 1ns/1ns
module tb_a1q9();

logic clk, reset;
logic [7:0] counter;

a1q9 assignment1q9(.clk(clk), .reset(reset), .counter(counter));

always begin
	clk=0; #1; clk=1; #1;
end

initial begin
	reset=1; #2; reset=0; #20; reset = 1; #4; reset = 0;
end

endmodule
