`default_nettype none

// CPEN 311 Lab 4 Code: my_task2a_algo.sv
// Author: Tom Sung
// Date: October 24, 2021
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
// Purpose: This file is the algorithm that implements swapping capabilities of S-Memory
module my_task2a_algo(
	input logic inclk,
	input logic [3:0] key,
	input logic [9:0] switch,
	output logic [1:0] led
);

// === Memory Signals ===
logic s_mem_wren;
logic [7:0] s_mem_q, s_mem_data, s_mem_address;

// === S-Memory Signals for each task ===
logic [7:0] s_mem_data_1, s_mem_address_1;
logic s_mem_write_enable_1;
logic [7:0] s_mem_data_2, s_mem_address_2;
logic s_mem_write_enable_2;

// === Secret Key Hard-Coding
logic [23:0] secret_key;
assign secret_key = {{14{1'h0}},{switch[9:0]}};

// === Finish flags for FSMs ===
reg flag_task1_finish = 1'b0;
reg flag_task2a_finish = 1'b0;
assign led[0] = flag_task1_finish;
assign led[1] = flag_task2a_finish;

always_ff @ (posedge inclk) begin
	if(flag_task1_finish) begin
		s_mem_address <= s_mem_address_2;
		s_mem_data <= s_mem_data_2;
		s_mem_wren <= s_mem_write_enable_2;
	end
	else begin
		s_mem_address <= s_mem_address_1;
		s_mem_data <= s_mem_data_1;
		s_mem_wren <= s_mem_write_enable_1;
	end
end

// Task 1: S-Memory
my_fsm_task1 fsm_task1(
	.inclk(inclk),
	.s_mem_address(s_mem_address_1),
	.s_mem_data(s_mem_data_1),
	.s_mem_wren(s_mem_write_enable_1),
	.flag_task1_finish(flag_task1_finish),
	.flag_start(~key[0]) // start flag
);

// Task 2a: Shuffle/Swap
my_fsm_task2a fsm_task2(
	.inclk(inclk),
	.secret_key(secret_key),
	.flag_start(~key[1]), // start flag
	.s_mem_address(s_mem_address_2),
	.s_mem_data(s_mem_data_2),
	.s_mem_wren(s_mem_write_enable_2),
	.s_mem_q(s_mem_q),
	.flag_task2a_finish(flag_task2a_finish)
);

s_memory working_mem(
	.clock(inclk),
	.address(s_mem_address),
	.data(s_mem_data),
	.wren(s_mem_wren),
	.q(s_mem_q) // The only output. Everything else is input
);

endmodule
