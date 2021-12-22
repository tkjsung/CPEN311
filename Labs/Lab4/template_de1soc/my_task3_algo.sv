`default_nettype none

// CPEN 311 Lab 4 Code: my_task3_algo.sv
// Author: Tom Sung
// Date: October 28, 2021
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
// Purpose: This file is the algorithm that implements every task in this lab (the most complete functionality)
module my_task3_algo(
	input logic inclk,
	input logic reset_n,
	input logic [3:0] key,
	output logic [9:0] led,
	output logic [6:0] HEX0,
	output logic [6:0] HEX1,
	output logic [6:0] HEX2,
	output logic [6:0] HEX3,
	output logic [6:0] HEX4,
	output logic [6:0] HEX5
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

// === Decrypted Memory Signals for Task 2b and Task 3 ===
logic [4:0] task2b_decrypt_address, task3_decrypt_address;
logic [7:0] task2b_decrypt_data;
logic task2b_decrypt_wren;

// === Secret Key-Related Signals ===
logic [23:0] secret_key;
logic [5:0] decrypt_valid_data_counter;

// === Start/Finish flags for FSMs ===
logic flag_task1_finish, flag_task2a_finish, flag_task2b_finish, flag_task3_finish;
logic flag_task1_start, flag_task2a_start, flag_task2b_start, flag_task3_start;

// Other miscellaneous signals
logic [1:0] counter;

// === State Encoding ===
logic [10:0] state;
parameter init = 11'b00000_00_0000;
parameter idle = 11'b00001_00_0000;
parameter check_secret_key = 11'b00010_00_0000;
parameter task1_start = 11'b00011_00_0000;
parameter task1_wait_1 = 11'b00100_00_0001;
parameter task1_wait_2 = 11'b00101_00_0000;
parameter task2a_start = 11'b00110_00_0000;
parameter task2a_wait_1 = 11'b00111_00_0010;
parameter task2a_wait_2 = 11'b01000_00_0000;
parameter task2b_start = 11'b01001_00_0000;
parameter task2b_wait_1 = 11'b01010_00_0100;
parameter task2b_wait_2 = 11'b01011_00_0000;
parameter task3_start = 11'b01100_00_0000;
parameter task3_wait_1 = 11'b01101_00_1000;
parameter task3_wait_2 = 11'b01110_00_0000;
parameter check_valid_data_counter = 11'b01111_00_0000;
parameter secret_key_increment = 11'b10000_00_0000;
parameter finish = 11'b10001_01_0000;
parameter failed = 11'b10010_10_0000;

assign flag_task1_start = state[0];
assign flag_task2a_start = state[1];
assign flag_task2b_start = state[2];
assign flag_task3_start = state[3];
assign led[9] = state[4];
assign led[8] = state[5];

// FSM
always_ff @ (posedge inclk, negedge reset_n) begin
	if(~reset_n) begin
		state <= init;
	end
	else begin
		case(state)
			init: state <= idle;
			
			idle: if(!key[0]) state <= check_secret_key;
			
			check_secret_key: begin
				if(secret_key < 24'h400000) state <= task1_start;
				else state <= failed;
			end
			
			task1_start: state <= task1_wait_1;
			
			task1_wait_1: begin
				if(counter < 2'b10) state <= task1_wait_1;
				else state <= task1_wait_2;
			end
			
			task1_wait_2: begin
				if(flag_task1_finish) state <= task2a_start;
				else state <= task1_wait_2;
			end
			
			task2a_start: state <= task2a_wait_1;
			
			task2a_wait_1: begin
				if(counter < 2'b10) state <= task2a_wait_1;
				else state <= task2a_wait_2;
			end
			
			task2a_wait_2: begin
				if(flag_task2a_finish) state <= task2b_start;
				else state <= task2a_wait_2;
			end
			
			task2b_start: state <= task2b_wait_1;
			
			task2b_wait_1: begin
				if(counter < 2'b10) state <= task2b_wait_1;
				else state <= task2b_wait_2;
			end
			
			task2b_wait_2: begin
				if(flag_task2b_finish) state <= task3_start;
				else state <= task2b_wait_2;
			end
			
			task3_start: state <= task3_wait_1;
			
			task3_wait_1: begin
				if(counter < 2'b10) state <= task3_wait_1;
				else state <= task3_wait_2;
			end
			
			task3_wait_2: begin
				if(flag_task3_finish) state <= check_valid_data_counter;
				else state <= task3_wait_2;
			end
			
			check_valid_data_counter: begin
				if(decrypt_valid_data_counter >= 6'h20) state <= finish;
				else state <= secret_key_increment;
			end
			
			secret_key_increment: state <= check_secret_key;
			
			finish: state <= finish;
			failed: state <= failed;
			default: state <= init;
		endcase
	end
end

// Output
always_ff @ (negedge inclk) begin
	case(state)
		init: secret_key <= 24'h000000;
		
		task1_wait_1: begin
			counter <= counter + 1'd1;
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
		
		task2a_wait_1: begin
			counter <= counter + 1'd1;
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
		
		task2b_wait_1: begin
			counter <= counter + 1'd1;
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
		
		task3_wait_1: begin
			counter <= counter + 1'd1;
			decrypt_mem_address <= task3_decrypt_address;
			decrypt_mem_q <= decrypt_mem_q;
		end
		
		task3_wait_2: begin
			counter <= 0;
			decrypt_mem_address <= task3_decrypt_address;
			decrypt_mem_q <= decrypt_mem_q;
		end
		
		secret_key_increment: secret_key <= secret_key + 24'd1;	
		
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

// Task 3: Check valid data (lowercase letters + space)
my_fsm_task3 fsm_task3(
	.inclk(inclk),
	.reset_n(reset_n),
	.flag_start(flag_task3_start),
	.flag_finish(flag_task3_finish),
	.decrypt_mem_address(task3_decrypt_address),
	.decrypt_mem_q(decrypt_mem_q),
	.valid_counter(decrypt_valid_data_counter)
);

// 7-Segment Display
SevenSegmentDisplayDecoder segment0(.ssOut(HEX0), .nIn(secret_key[3:0]));
SevenSegmentDisplayDecoder segment1(.ssOut(HEX1), .nIn(secret_key[7:4]));
SevenSegmentDisplayDecoder segment2(.ssOut(HEX2), .nIn(secret_key[11:8]));
SevenSegmentDisplayDecoder segment3(.ssOut(HEX3), .nIn(secret_key[15:12]));
SevenSegmentDisplayDecoder segment4(.ssOut(HEX4), .nIn(secret_key[19:16]));
SevenSegmentDisplayDecoder segment5(.ssOut(HEX5), .nIn(secret_key[23:20]));

// Memory Units
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
