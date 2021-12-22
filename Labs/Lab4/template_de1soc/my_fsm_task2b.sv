`default_nettype none

// CPEN 311 Lab 4 Code: my_fsm_task2b.sv
// Author: Tom Sung
// Date: October 30, 2021
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
// Purpose: Task 2b Implementation (Decryption)
module my_fsm_task2b(
	input logic inclk, reset_n,
	input logic flag_start,
	output logic flag_task2b_finish,
	output logic [7:0] s_mem_address, s_mem_data,
	output logic s_mem_wren,
	input logic [7:0] s_mem_q,
	output logic [4:0] encrypt_mem_address,
	input logic [7:0] encrypt_mem_q,
	output logic [4:0] decrypt_mem_address,
	output logic [7:0] decrypt_mem_data,
	output logic decrypt_mem_wren,
	input logic [7:0] decrypt_mem_q
);

// Counter Variables
logic [7:0] i, j;
logic [4:0] k; //2^5 = 32. Max value: 0x1F

// Define other variables
logic flag_task2b_fin;
logic [7:0] i_data, j_data, f_data, encrypt_data, decrypt_data;
logic [7:0] state;
logic [1:0] counter; // Acts as a delay for memory-write

// State Encoding
parameter idle = 8'b00000_000;
parameter init = 8'b00001_000;
parameter check_k = 8'b00010_000;
parameter i_increment = 8'b00011_000;
parameter i_get_data_1 = 8'b00100_000;
parameter i_get_data_2 = 8'b00101_000;
parameter i_get_data_3 = 8'b00110_000;
parameter j_calculate = 8'b00111_000;
parameter j_get_data_1 = 8'b01000_000;
parameter j_get_data_2 = 8'b01001_000;
parameter j_get_data_3 = 8'b01010_000;
parameter swap_1 = 8'b01011_000;
parameter swap_1_wait = 8'b01100_001;
parameter swap_2 = 8'b01101_000;
parameter swap_2_wait = 8'b01110_001;
parameter f_get_data_1 = 8'b01111_000;
parameter f_get_data_2 = 8'b10000_000;
parameter f_get_data_3 = 8'b10001_000;
parameter decrypt_calculate = 8'b10010_000;
parameter decrypt_write = 8'b10011_000;
parameter decrypt_write_wait = 8'b10100_010;
parameter k_increment = 8'b10101_000;
parameter finish = 8'b10110_100;

// Output assignments
assign flag_task2b_finish = state[2];
assign decrypt_mem_wren = state[1];
assign s_mem_wren = state[0];

// Output
always_ff @ (posedge inclk) begin
	case(state)
		init: begin
			i <= 8'h00;
			j <= 8'h00;
			i_data <= 8'h00;
			j_data <= 8'h00;
			f_data <= 8'h00;
			k <= 5'b00000;
			flag_task2b_fin <= 1'h0;
			counter <= 2'h0;
			encrypt_data <= 8'h00;
			decrypt_data <= 8'h00;
		end
		
		i_increment: begin
			i <= i + 1'd1;
			if(k == 5'h1F) flag_task2b_fin <= 1'b1;
			else flag_task2b_fin <= 1'b0;
		end
		
		i_get_data_1: s_mem_address <= i;
		i_get_data_3: i_data <= s_mem_q;
		
		j_calculate: j <= (j + i_data);
		
		j_get_data_1: s_mem_address <= j;
		j_get_data_3: j_data <= s_mem_q;
		
		swap_1: begin
			s_mem_address <= j;
			s_mem_data <= i_data;
		end
		
		swap_2: begin
			s_mem_address <= i;
			s_mem_data <= j_data;
		end
		
		// To save time, get f_data and ROM data at the same time.
		f_get_data_1: begin
			s_mem_address <= (i_data + j_data);
			encrypt_mem_address <= k;
		end
		f_get_data_3: begin
			f_data <= s_mem_q;
			encrypt_data <= encrypt_mem_q;
		end
		
		decrypt_calculate: decrypt_data <= (f_data ^ encrypt_data);
		
		decrypt_write: begin
			decrypt_mem_address <= k;
			decrypt_mem_data <= decrypt_data;
		end
		
		k_increment: k <= k + 1'd1;
		
		finish: counter <= counter + 1'd1;
	endcase
end

// FSM
always_ff @ (posedge inclk, negedge reset_n) begin
	if(~reset_n) state <= idle;
	else begin
		case(state)
			idle: if(flag_start) state <= init;
			
			init: state <= check_k;
			
			check_k: begin
				if(flag_task2b_fin) state <= finish;
				else state <= i_increment;
			end
			
			i_increment: state <= i_get_data_1;
			
			i_get_data_1: state <= i_get_data_2;
			i_get_data_2: state <= i_get_data_3;
			i_get_data_3: state <= j_calculate;
			
			j_calculate: state <= j_get_data_1;
			
			j_get_data_1: state <= j_get_data_2;
			j_get_data_2: state <= j_get_data_3;
			j_get_data_3: state <= swap_1;
			
			swap_1: state <= swap_1_wait;
			swap_1_wait: state <= swap_2;
			
			swap_2: state <= swap_2_wait;
			swap_2_wait: state <= f_get_data_1;
			
			f_get_data_1: state <= f_get_data_2;
			f_get_data_2: state <= f_get_data_3;
			f_get_data_3: state <= decrypt_calculate;
			
			decrypt_calculate: state <= decrypt_write;
			
			decrypt_write: state <= decrypt_write_wait;
			decrypt_write_wait: state <= k_increment;
			
			k_increment: state <= check_k;
			
			finish: begin
				if(counter < 2'b10) state <= finish;
				else state <= idle;
			end
			
			default: state <= idle;
		endcase
	end
end


endmodule
