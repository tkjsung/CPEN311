`default_nettype none

// CPEN 311 Lab 2 Code: my_fsm_read_flash.sv
// Author: Tom Sung
// Date: October 7, 2021
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
module my_fsm_read_flash(
	input logic inclk, reset,
	input logic flag_wait, flag_valid_data,  // from flash controller
	input logic flag_start,
	output logic flag_ready,
	output logic flag_read  // This makes read flag HIGH on the flash controller
);

logic [5:0] state;

parameter idle = 6'b00_0000;
parameter check_read = 6'b01_0001;
parameter check_waitrequest = 6'b01_0010;
parameter check_validdata = 6'b01_0011;
parameter finish = 6'b10_0100;

assign flag_read = state[4];
assign flag_ready = state[5];

// FSM
always_ff @ (posedge inclk, negedge reset)
	if(~reset) state <= idle;
	else
	begin
		case(state)
			idle: begin
				if(flag_start) state <= check_read;
				else state <= idle;
			end
				
			check_read: state <= check_waitrequest;
			
			check_waitrequest: begin
				if(!flag_wait) state <= check_validdata;
				else state <= check_waitrequest;
			end
				
			check_validdata: begin
				if(!flag_valid_data) state <= finish;
				else state <= check_validdata;
			end
			
			finish: state <= idle;
			
			default: state <= idle;	
		endcase
	end
	
endmodule
