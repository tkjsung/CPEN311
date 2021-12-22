// CPEN 311 Practice Assignment 6 Question 4: a6q4.sv
// Author: Tom Sung
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
module a6q4(
	input logic clk, start, reset,
	input logic [4:0] n,
	output logic done,
	output logic [31:0] F, f1, f2,
	output logic [2:0] state
);

//logic [31:0] f1, f2, temp;
logic [4:0] counter;
//logic [2:0] state;

parameter init = 3'b0_00;
parameter idle = 3'b0_01;
parameter add = 3'b0_10;
parameter fin = 3'b1_11;

assign done = state[2];

always_ff @ (posedge clk) begin
	case(state)
		init: begin
			f1 <= 1'b1;
			f2 <= 1'b1;
		end

		idle: counter <= n-1;

		add: begin
			f2 <= f1+f2;
			f1 <= f2;
			counter <= counter - 1;
		end

		fin: F <= f2;
	endcase
end

always_ff @ (posedge clk, posedge reset) begin
	if(reset) state <= init;
	else begin
	case(state)
		init: state <= idle;
		idle: if(start) state <= add;
		add: begin
			if(counter > 2) state <= add;
			else state <= fin;
		end
		fin: state <= init;

	endcase
end
end

endmodule


`timescale 1ns/1ns
module tb_a6q4();

logic clk, start, done, reset;
logic [4:0] n;
logic [31:0] F;
logic [31:0] f1, f2;
logic [2:0] state;

a6q4 assignment6q4(.clk(clk), .start(start), .n(n), .done(done),
	.F(F), .f1(f1), .f2(f2), .reset(reset), .state(state));


always begin
	clk = 0; #2; clk = 1; #2;
end

initial begin
	#1; reset = 1; #2; reset = 0; #6; n=5'd10; start = 1; #2; start = 0;
end


endmodule
