// CPEN 311 Practice Assignment 2 Question 3: a2q3.sv
// Author: Tom Sung
// Copyright (c) 2021 by Ke-Jun (Tom) Sung

// My solution
/*
module a2q3(
	input logic CLK, STB,
	output logic TS, TL
);

logic [3:0] counter;
logic flag;

always_ff @ (posedge CLK, negedge STB) begin
	if(~STB) begin
		counter <= 4'd0;
		flag <= 1'b1;
	end
	else if(counter < 4'b1000) begin
		counter <= counter + 1'b1;
		flag <= 1'b0;
	end
end

always_ff @ (posedge CLK) begin
	if((counter > 0 & counter < 4) | flag) TS <= 1'b0;
	else TS <= 1'b1;

	if((counter > 0 & counter < 7) | flag) TL <= 1'b0;
	else TL <= 1'b1;
end

endmodule
*/

// Answer Key Solution (Translated from VHDL)
module a2q3(
	input logic CLK, STB,
	output logic TS, TL,
	output logic [3:0] counter
);


always_ff @ (posedge CLK, negedge STB) begin
	if(~STB) counter <= 4'd7;
	else if(counter > 0) counter <= counter - 1'b1;
end

always_ff @ (posedge CLK) begin
	if(counter > 0 && counter < 8) TL <= 0;
	else TL <= 1;
	if(counter > 3 && counter < 8) TS <= 0;
	else TS <= 1;

end

endmodule


`timescale 1ns/1ns
module tb_a2q3();
	logic clk, stb;
	logic ts, tl;
	logic [3:0] counter;

	a2q3 assignment2q3(.CLK(clk),.STB(stb),.TS(ts),.TL(tl),.counter(counter));

	always begin
		clk = 0; #1; clk = 1; #1;
	end

	initial begin
		stb = 1; #4;
		stb = 0; #1;
		stb = 1; #4;
//		stb = 0; #2;
//		stb = 1;
	end

endmodule
