`default_nettype none

// CPEN 311 Lab 4 Code: my_task2b_algo.sv
// Author: Tom Sung
// Date: October 24, 2021
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
// Purpose: This file is the algorithm that implements decryption capabilities
module my_task2b_algo(
	input logic inclk,
	input logic reset_n,
	input logic [3:0] key,
	input logic [9:0] switch,
	output logic [9:0] led
);

// === Memory Signals ===
logic [7:0] s_mem_q, s_mem_data, s_mem_address;
logic s_mem_wren;
logic [4:0] decrypt_mem_address;
logic [7:0] decrypt_mem_data, decrypt_mem_q;
logic decrypt_mem_wren;
logic [4:0] rom_mem_address;
logic [7:0] rom_mem_q;

// === S-Memory Signals for each task ===
logic [7:0] task1_data, task1_address;
logic task1_wren, task2a_wren, task2b_wren;
logic [7:0] task2a_data, task2a_address;
logic [7:0] task2b_data, task2b_address;

logic [4:0] task2b_decrypt_address;
logic [7:0] task2b_decrypt_data;
logic task2b_decrypt_wren;

// === Secret Key Hard-Coding
logic [23:0] secret_key;
assign secret_key = {{14{1'h0}},{switch[9:0]}};

// === Finish flags for FSMs ===
logic flag_task1_finish;
logic flag_task2a_finish;
logic flag_task2b_finish;
// Assign these to states later.
//assign led[0] = flag_task1_finish;
//assign led[1] = flag_task2a_finish;
//assign led[2] = flag_task2b_finish;

// === Start flags for FSMs ===
logic flag_task1_start, flag_task2a_start, flag_task2b_start;

// === State Encoding ===
logic [7:0] state;
parameter init = 8'b00000_000;
parameter idle = 8'b00001_000;
parameter task1_start = 8'b00010_000;
parameter task1_wait_1 = 8'b00011_001;
parameter task1_wait_2 = 8'b00100_000;
parameter task2a_start = 8'b00101_000;
parameter task2a_wait_1 = 8'b00110_010;
parameter task2a_wait_2 = 8'b00111_000;
parameter task2b_start = 8'b01000_000;
parameter task2b_wait_1 = 8'b01001_100;
parameter task2b_wait_2 = 8'b01010_000;
parameter finish = 8'b01011_000;

assign flag_task1_start = state[0];
assign flag_task2a_start = state[1];
assign flag_task2b_start = state[2];

// Other miscellaneous signals
logic [2:0] counter;

always_ff @ (posedge inclk, negedge reset_n) begin
	if(~reset_n) begin
		state <= init;
	end
	else begin
		case(state)
			init: state <= idle;
			
			idle: if(!key[0]) state <= task1_start;
			
			task1_start: state <= task1_wait_1;
			
			task1_wait_1: begin
				if(counter < 3'b101) state <= task1_wait_1;
				else state <= task1_wait_2;
			end
			
			task1_wait_2: begin
				if(flag_task1_finish) state <= task2a_start;
				else state <= task1_wait_2;
			end
			
			task2a_start: state <= task2a_wait_1;
			
			task2a_wait_1: begin
				if(counter < 3'b101) state <= task2a_wait_1;
				else state <= task2a_wait_2;
			end
			
			task2a_wait_2: begin
				if(flag_task2a_finish) state <= task2b_start;
				else state <= task2a_wait_2;
			end
			
			task2b_start: state <= task2b_wait_1;
			
			task2b_wait_1: begin
				if(counter < 3'b101) state <= task2b_wait_1;
				else state <= task2b_wait_2;
			end
			
			task2b_wait_2: begin
				if(flag_task2b_finish) state <= finish;
				else state <= task2b_wait_2;
			end
			
			finish: begin
				if(!key[1]) state <= init;
				else state <= finish;
				state <= init;
			end
			default: state <= init;
		endcase
	end
end

always_ff @ (posedge inclk) begin
	case(state)
		init: led[9:0] <= 0;
		
		task1_wait_1: begin
			counter <= counter + 1;
			s_mem_address <= task1_address;
			s_mem_data <= task1_data;
			s_mem_wren <= task1_wren;
		end
		
		task1_wait_2: begin
			counter <= 0;
			s_mem_address <= task1_address;
			s_mem_data <= task1_data;
			s_mem_wren <= task1_wren;
		end
		
		task2a_start: led[0] <= 1;
		
		task2a_wait_1: begin
			counter <= counter + 1;
			s_mem_address <= task2a_address;
			s_mem_data <= task2a_data;
			s_mem_wren <= task2a_wren;
		end
		
		task2a_wait_2: begin
			counter <= 0;
			s_mem_address <= task2a_address;
			s_mem_data <= task2a_data;
			s_mem_wren <= task2a_wren;
		end
		
		task2b_start: led[1] <= 1;
		
		task2b_wait_1: begin
			counter <= counter + 1;
			s_mem_address <= task2b_address;
			s_mem_data <= task2b_data;
			s_mem_wren <= task2b_wren;
			decrypt_mem_address <= task2b_decrypt_address;
			decrypt_mem_data <= task2b_decrypt_data;
			decrypt_mem_wren <= task2b_decrypt_wren;
		end
		
		task2b_wait_2: begin
			counter <= 0;
			s_mem_address <= task2b_address;
			s_mem_data <= task2b_data;
			s_mem_wren <= task2b_wren;
			decrypt_mem_address <= task2b_decrypt_address;
			decrypt_mem_data <= task2b_decrypt_data;
			decrypt_mem_wren <= task2b_decrypt_wren;
		end
		
		finish: led[2] <= 1;
		
	endcase
end

// Task 1: S-Memory
my_fsm_task1 fsm_task1(
	.inclk(inclk),
	.reset_n(reset_n),
	.s_mem_address(task1_address),
	.s_mem_data(task1_data),
	.s_mem_wren(task1_wren),
	.flag_task1_finish(flag_task1_finish),
	.flag_start(flag_task1_start) // start flag
);

// Task 2a: Shuffle/Swap
my_fsm_task2a fsm_task2a(
	.inclk(inclk),
	.reset_n(reset_n),
	.secret_key(secret_key),
	.s_mem_address(task2a_address),
	.s_mem_data(task2a_data),
	.s_mem_wren(task2a_wren),
	.s_mem_q(s_mem_q),
	.flag_task2a_finish(flag_task2a_finish),
	.flag_start(flag_task2a_start) // start flag
);

// Task 2b: Decrypt Message
my_fsm_task2b fsm_task2b(
	.inclk(inclk),
	.reset_n(reset_n),
	.s_mem_address(task2b_address),
	.s_mem_data(task2b_data),
	.s_mem_wren(task2b_wren),
	.s_mem_q(s_mem_q),
	.encrypt_mem_address(rom_mem_address),
	.encrypt_mem_q(rom_mem_q),
	.decrypt_mem_address(task2b_decrypt_address),
	.decrypt_mem_data(task2b_decrypt_data),
	.decrypt_mem_wren(task2b_decrypt_wren),
	.decrypt_mem_q(decrypt_mem_q),
	.flag_task2b_finish(flag_task2b_finish),
	.flag_start(flag_task2b_start) // start flag
);


s_memory working_mem(
	.clock(inclk),
	.address(s_mem_address),
	.data(s_mem_data),
	.wren(s_mem_wren),
	.q(s_mem_q) // The only output. Everything else is input
);

decrypt_memory out_result(
	.clock(inclk),
	.address(decrypt_mem_address),
	.data(decrypt_mem_data),
	.wren(decrypt_mem_wren),
	.q(decrypt_mem_q)
);

encrypt_memory rom_input(
	.address(rom_mem_address),
	.clock(inclk),
	.q(rom_mem_q)
);

endmodule
