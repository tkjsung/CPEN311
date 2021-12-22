// CPEN 311 Practice Assignment 1 Question 1: a1q1.sv
// Author: Tom Sung
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
module a1q1(
	input logic [1:0] a,b,c,d,e,f,g,h,
	input logic [2:0] sel,
	output logic [1:0] outm
);

always_comb begin
	case(sel)
		3'b000: outm <= a;
		3'b001: outm <= b;
		3'b010: outm <= c;
		3'b011: outm <= d;
		3'b100: outm <= e;
		3'b101: outm <= f;
		3'b110: outm <= g;
		3'b111: outm <= h;
	endcase
end

endmodule

`timescale 1ns/1ns
module tb_a1q1();
	logic [1:0] a,b,c,d,e,f,g,h;
	logic [2:0] sel;
	logic [1:0] outm;

	a1q1 assignment1q1(.a(a),.b(b),.c(c),.d(d),.e(e),.f(f),.g(g),.h(h),.sel(sel),.outm(outm));

	initial begin
		a=0; b=1; c=2; d=3; e=0; f=1; g=2; h=3;
	end

	initial begin
		sel=3'b0; #2;
		sel=3'b1; #2;
		sel=3'b10; #2;
		sel=3'b11; #2;
		sel=3'b100; #2;
		sel=3'b101; #2;
		sel=3'b110; #2;
		sel=3'b111; #2;
	end

endmodule
