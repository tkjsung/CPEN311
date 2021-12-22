// CPEN 311 Practice Assignment 2 Question 4: a2q4.sv
// Author: Tom Sung
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
module a2q4 #(parameter N=1)(
	input logic clk, s,
	output logic done,
	input logic[N-1:0] A,B,
	output logic [N-1:0] Q,R
);

logic [1:0] state;
localparam idle = 2'b00;
localparam calculate = 2'b01;
localparam finish = 2'b10;
assign done = state[1];

always_ff @ (posedge clk) begin
	case(state)
		idle: if(s) state <= calculate;
		calculate: if(R<B) state <= finish;
		finish: state <= idle;
		default: state <= idle;
	endcase
end


always_ff @ (posedge clk) begin
	case(state)
		idle: begin
			Q <= 0;
			R <= A;
		end
		calculate: begin
			if(R>=B) begin
				R <= R-B;
				Q <= Q+1'b1;
			end
		end
	endcase
end
endmodule


`timescale 1ns/1ns
module tb_a2q4();

parameter N=6;

logic clk, s, done;
logic[N-1:0] A,B,Q,R;

a2q4 #(.N(N)) assignment2q4 (.clk(clk),.A(A),.B(B),.R(R),.Q(Q),.s(s),.done(done));

always begin
	clk=0; #1; clk=1; #1;
end

initial begin
	s=0; A=21; B=4; #3;
	s=1'b1; #1;
	s=1'b0;
end

endmodule
