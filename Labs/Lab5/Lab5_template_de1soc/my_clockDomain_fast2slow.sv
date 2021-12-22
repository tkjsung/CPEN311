`default_nettype none
`timescale 1ns/1ns

// CPEN 311 Lab 5 Code: my_clockDomain_fast2slow.sv
// Author: Tom Sung
// Date: November 11, 2021
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
// Purpose: Handles data from fast to slow clock domain
module my_clockDomain_fast2slow #(parameter N=12) (
  input logic fast_clk,
  input logic slow_clk,
  input logic [(N-1):0] async_in,
  output logic [(N-1):0] sync_out
);

// Registers for async
logic [(N-1):0] reg1, reg3;

// Registers for enable signal for reg3
logic q1, enable;

always_ff @ (posedge fast_clk) begin
  reg1 <= async_in;
end

always_ff @ (posedge fast_clk) begin
  if(enable) reg3 <= reg1;
end

always_ff @ (posedge slow_clk) begin
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
module tb_my_clockDomain_fast2slow();

logic slow_clk, fast_clk, enable;
logic [11:0] sync_out, async_in, reg3;
my_clockDomain_fast2slow #(.N(12)) fast2slow (
	.slow_clk(slow_clk), 
	.fast_clk(fast_clk),
	.sync_out(sync_out),
	.async_in(async_in)
	//.reg3(reg3),
	//.enable(enable)
);

always begin
	fast_clk = 1; #1000; fast_clk = 0; #1000;
end

always begin
	slow_clk = 0; #5500; slow_clk = 1; #5500;
end

initial begin
	async_in = 12'hF2; #2000;
	async_in = 12'hB5; #2000;
	async_in = 12'h23; #2000;
	async_in = 12'h53; #2000;
	async_in = 12'hAF; #2000;
	async_in = 12'hC4; #2000;
	async_in = 12'hA4; #2000;
	async_in = 12'h21; #2000;
	async_in = 12'h10; #2000;
	async_in = 12'h4A; #2000;
	async_in = 12'h57; #2000;
	async_in = 12'h25; #2000;
	async_in = 12'h22; #2000;
	async_in = 12'h78; #2000;
	async_in = 12'hD6; #2000;
	async_in = 12'h00; #2000;
	async_in = 12'h3B; #2000;
	async_in = 12'h8D; #2000;
	async_in = 12'h95; #2000;
	async_in = 12'h2A; #2000;
	async_in = 12'h3B; #2000;
	async_in = 12'hD9;

end


endmodule
