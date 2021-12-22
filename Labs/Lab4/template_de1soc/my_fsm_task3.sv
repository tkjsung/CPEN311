`default_nettype none

// CPEN 311 Lab 4 Code: my_fsm_task3.sv
// Author: Tom Sung
// Date: October 30, 2021
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
// Purpose: Task 3 Implementation (Check Valid Data)
module my_fsm_task3(
	input logic inclk, reset_n,
	input logic flag_start,
	output logic flag_finish,
	output logic [4:0] decrypt_mem_address,
	input logic [7:0] decrypt_mem_q,
	output logic [5:0] valid_counter
);

logic [7:0] i, decrypt_data;
logic [1:0] counter;
logic flag_invalid;
logic flag_task_finish;

// State Encoding
logic [4:0] state;
parameter idle = 5'b0000_0;
parameter init = 5'b0001_0;
parameter i_counter_check = 5'b0010_0;
parameter decrypt_get_data_1 = 5'b0011_0;
parameter decrypt_wait = 5'b0100_0;
parameter decrypt_get_data_2 = 5'b0101_0;
parameter decrypt_check_data = 5'b0110_0;
parameter i_increment = 5'b0111_0;
parameter finish = 5'b1000_1;

// Output assignments
assign flag_finish = state[0];

// FSM
always_ff @ (posedge inclk, negedge reset_n) begin
	if(~reset_n)
		state <= idle;
	else begin
		case(state)
			idle: begin
				if(flag_start) state <= init;
				else state <= idle;
			end
			
			init: state <= i_counter_check;
			
			i_counter_check: begin
				if(flag_task_finish | flag_invalid) state <= finish;
				else state <= decrypt_get_data_1;
			end
			
			decrypt_get_data_1: state <= decrypt_wait;
			decrypt_wait: state <= decrypt_get_data_2;
			decrypt_get_data_2: state <= decrypt_check_data;

			decrypt_check_data: state <= i_increment;
			
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
			i <= 8'h00;
			flag_task_finish <= 1'b0;
			counter <= 2'h0;
			valid_counter <= 6'h00;
			flag_invalid <= 1'b0;
		end
		
		decrypt_get_data_1: begin
			decrypt_mem_address <= i;
			if(i == 5'h1F) flag_task_finish <= 1'b1;
			else flag_task_finish <= 1'b0;
		end
		
		decrypt_get_data_2: decrypt_data <= decrypt_mem_q;
		
		decrypt_check_data: begin
			if((decrypt_data >= 8'd97) && (decrypt_data <= 8'd122)) valid_counter <= valid_counter + 1'd1;
			else if(decrypt_data == 8'd32) valid_counter <= valid_counter + 1'd1;
			else flag_invalid <= 1'b1;
		end
		
		i_increment: i <= i + 1'd1;
		
		finish: counter <= counter + 1'd1;
		
	endcase
end


endmodule
