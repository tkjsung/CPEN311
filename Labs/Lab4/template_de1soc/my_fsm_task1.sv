`default_nettype none

// CPEN 311 Lab 4 Code: my_fsm_task1.sv
// Author: Tom Sung
// Date: October 28, 2021
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
// Purpose: Task 1 Implementation (Initialization)
module my_fsm_task1(
	input logic inclk, reset_n,
	input logic flag_start,
	output logic [7:0] s_mem_address,
	output logic [7:0] s_mem_data,
	output logic s_mem_wren,
	output logic flag_task1_finish
);

reg [7:0] i = 8'h00;
reg flag_smem_finish = 1'b0;
logic [1:0] counter;

// State Encoding
logic [4:0] state;
parameter idle = 5'b000_00;
parameter check_finish = 5'b001_00;
parameter smem_write = 5'b010_01;
parameter i_increment = 5'b011_00;
parameter finish = 5'b100_10;

// Output assignments
assign s_mem_wren = state[0];
assign flag_task1_finish = state[1];

// FSM
always_ff @ (posedge inclk, negedge reset_n) begin
	if(~reset_n)
		state <= idle;
	else begin
		case(state)
			idle: begin
				if(flag_start) state <= check_finish;
				else state <= idle;
			end
			
			check_finish: begin
				if(flag_smem_finish) state <= finish;
				else state <= smem_write;
			end
			
			smem_write: state <= i_increment;
			
			i_increment: state <= check_finish;
			
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
		idle: begin
			i <= 8'h00;
			flag_smem_finish <= 1'b0;
			counter <= 0;
		end

		smem_write: begin
			s_mem_data <= i;
			s_mem_address <= i;
			if(i == 8'hFF) flag_smem_finish <= 1'b1;
			else flag_smem_finish <= 1'b0;
		end
		
		i_increment: i <= i + 1'd1;
		
		finish: counter <= counter + 1'd1;
		
	endcase
end

endmodule
