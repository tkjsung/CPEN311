`default_nettype none
`timescale 1ns/1ns

// CPEN 311 Lab 5 Code: my_clockDomain_slow2fast.sv
// Author: Tom Sung
// Date: November 11, 2021
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
// Purpose: Handles data from slow to fast clock domain
module my_clockDomain_slow2fast #(parameter N=1) (
  input logic fast_clk,
  input logic slow_clk,
  input logic [(N-1):0] async_in,
  output logic [(N-1):0] sync_out
);

// Registers for async
logic [(N-1):0] reg1, reg3;

// Registers for enable signal for reg3
logic q1, enable;

always_ff @ (posedge slow_clk) begin
  reg1 <= async_in;
end

always_ff @ (posedge fast_clk) begin
  if(enable) reg3 <= reg1;
end

always_ff @ (posedge fast_clk) begin
  sync_out <= reg3;
end

always_ff @ (negedge fast_clk) begin
  q1 <= slow_clk;
end

always_ff @ (negedge fast_clk) begin
  enable <= q1;
end


endmodule


// Testbench
module tb_my_clockDomain_slow2fast();

logic slow_clk, fast_clk, enable;
logic [11:0] sync_out, async_in, reg3;
my_clockDomain_slow2fast #(.N(12)) slow2fast (
	.slow_clk(slow_clk),
	.fast_clk(fast_clk),
	.sync_out(sync_out),
	.async_in(async_in)
	//.enable(enable),
	//.reg3(reg3)
);

always begin
	fast_clk = 0; #1; fast_clk = 1; #1;
end

always begin
	slow_clk = 0; #6; slow_clk = 1; #6;
end

initial begin
	async_in = 12'h00; #6;
	async_in = 12'hD9; #12;
	async_in = 12'hA7; #12; 
	async_in = 12'h4D; #12;
	async_in = 12'h63; #12;
	async_in = 12'hA0; #12;
	async_in = 12'h00;
end


endmodule
