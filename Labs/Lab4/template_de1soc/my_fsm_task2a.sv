`default_nettype none

// CPEN 311 Lab 4 Code: my_fsm_task2a.sv
// Author: Tom Sung
// Date: October 30, 2021
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
// Purpose: Task 2a Implementation (Swapping Elements)
module my_fsm_task2a(
	input logic inclk, reset_n,
	input logic flag_start,
	input logic [23:0] secret_key,
	output logic [7:0] s_mem_address,
	output logic [7:0] s_mem_data,
	output logic s_mem_wren,
	input logic [7:0] s_mem_q,
	output logic flag_task2a_finish
);

// Counter Signals
logic [7:0] i, j;
logic [1:0] counter;

// Define other signals
logic flag_task2_fin;
logic [7:0] i_data, j_data;

// State Encoding
logic [6:0] state;
parameter idle = 7'b00000_00;
parameter init = 7'b00001_00;
parameter i_counter_check = 7'b00010_00;
parameter i_get_data_1 = 7'b00011_00;
parameter i_get_data_2 = 7'b00100_00;
parameter i_get_data_3 = 7'b00101_00;
parameter j_calculate = 7'b00110_00;
parameter j_get_data_1 = 7'b00111_00;
parameter j_get_data_2 = 7'b01000_00;
parameter j_get_data_3 = 7'b01001_00;
parameter swap_1 = 7'b01010_00;
parameter swap_1_wait = 7'b01011_01;
parameter swap_2 = 7'b01100_00;
parameter swap_2_wait = 7'b01101_01;
parameter i_increment = 7'b01110_00;
parameter finish = 7'b01111_10;

// Output assignments
assign flag_task2a_finish = state[1];
assign s_mem_wren = state[0];

// Modulo and Secret Key
parameter keylength = 3;
logic [7:0] secret_key_byte [0:2];
assign secret_key_byte[0] = secret_key[23:16];
assign secret_key_byte[1] = secret_key[15:8];
assign secret_key_byte[2] = secret_key[7:0];

// FSM
always_ff @ (posedge inclk, negedge reset_n) begin
	if(~reset_n) state <= idle;
	else begin
		case(state)
			idle: begin
				if(flag_start) state <= init;
				else state <= idle;
			end
			
			init: state <= i_counter_check;
			
			i_counter_check: begin
				if(flag_task2_fin) state <= finish;
				else state <= i_get_data_1;
			end
			
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
			swap_2_wait: state <= i_increment;
			
			i_increment: state <= i_counter_check;
			
			finish: begin
				if(counter < 2'b10) state <= finish;
				else state <= idle;
			end
			
			default: state <= idle;
		endcase
	end
end

// Output for each state
always_ff @ (posedge inclk) begin
	case(state)
		init: begin
			i <= 8'd0;
			j <= 8'd0;
			flag_task2_fin <= 1'b0;
			counter <= 2'h0;
		end
		
		i_get_data_1: begin
			s_mem_address <= i;
			if(i == 8'hFF) flag_task2_fin <= 1'b1;
			else flag_task2_fin <= 1'b0;
		end
		i_get_data_3: i_data <= s_mem_q;
		
		j_calculate: j <= (j + i_data + secret_key_byte[i%keylength]);
		
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
		
		i_increment: i <= i + 8'd1;
		
		finish: counter <= counter + 1'd1;
		
	endcase
end


endmodule
