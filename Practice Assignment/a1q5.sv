// CPEN 311 Practice Assignment 1 Question 5: a1q5.sv
// Author: Tom Sung
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
module a1q5(
	input logic J, K,
	output logic Q,
	input logic clk

);

always_ff @ (posedge clk) begin
	case({{J},{K}})
		2'b00: Q <= Q;
		2'b01: Q <= 1'b0;
		2'b10: Q <= 1'b1;
		2'b11: Q <= ~Q;
	endcase
end

endmodule


`timescale 1ns/1ns
module tb_a1q5();
	logic J, K, Q, clk;

	a1q5 assignment1q5(.J(J),.K(K),.Q(Q),.clk(clk));

	always begin
		clk = 0; #2; clk = 1; #2;
	end

	initial begin
		J=0; K=1; #4;
		J=0; K=0; #4;
		J=1; K=1; #4;
		J=1; K=0;
	end


endmodule
