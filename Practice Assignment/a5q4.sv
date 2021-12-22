// CPEN 311 Practice Assignment 5 Question 4: a5q4.sv
// Author: Tom Sung
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
module a5q4(
	input logic clk, reset, data,
	output logic [7:0] zeros, ones
);

always_ff @ (posedge clk) begin
	if(reset) begin
		zeros <= 8'd1;
		ones <= 8'd0;
	end
	else begin
		if(data) ones <= ones + 1'b1;
		else zeros <= zeros + 1'b1;
	end
end


endmodule


`timescale 1ns/1ns
module tb_a5q4();

logic clk, reset, data;
logic [7:0] zeros, ones;

a5q4 assignment5q4(.clk(clk),.reset(reset),.data(data),.zeros(zeros),.ones(ones));

always begin
	clk=0; #2; clk=1; #2;
end

initial begin
	reset=0; #6; reset=1; #3; reset=0;
end

initial begin
	data=0; #8; data=1; #5; data = 0; #8; data=1;

end

endmodule
