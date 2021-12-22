`default_nettype none

// CPEN 311 Lab 2 Code: my_fsm_keyboard.sv
// Author: Tom Sung
// Date: October 8, 2021
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
module my_fsm_keyboard(
	input logic inclk, flag_ready,
	input logic [7:0] keyboard_ascii,
	output logic [2:0] key_ctrl_sig
);

logic [3:0] state;
logic key_b, key_d, key_e, key_f, key_r;
logic [3:0] count = 0;

// Keyboard Ascii Definitions
parameter character_B =8'h42;
parameter character_D =8'h44;
parameter character_E =8'h45;
parameter character_F =8'h46;
parameter character_R =8'h52;
parameter character_lowercase_b= 8'h62;
parameter character_lowercase_d= 8'h64;
parameter character_lowercase_e= 8'h65;
parameter character_lowercase_f= 8'h66;
parameter character_lowercase_r= 8'h72;

assign key_b = (keyboard_ascii == character_B) | (keyboard_ascii == character_lowercase_b);
assign key_d = (keyboard_ascii == character_D) | (keyboard_ascii == character_lowercase_d);
assign key_e = (keyboard_ascii == character_E) | (keyboard_ascii == character_lowercase_e);
assign key_f = (keyboard_ascii == character_F) | (keyboard_ascii == character_lowercase_f);
assign key_r = (keyboard_ascii == character_R) | (keyboard_ascii == character_lowercase_r);

// States
parameter idle = 4'b0000;
parameter idle_delay = 4'b0001;
parameter check_key = 4'b0010;
parameter play = 4'b0011;
parameter pause = 4'b0100;
parameter dir_f = 4'b0101;
parameter dir_b = 4'b0110;
parameter rst = 4'b0111;
parameter rst_restore = 4'b1000;

always_ff @ (posedge inclk)
begin
	case(state)			
		idle: begin
			if(flag_ready) state <= idle_delay;
			else state <= idle;
		end
		
		idle_delay: begin
			if(count < 4'b0110) state <= idle_delay;
			else state <= check_key;
		end
		
		check_key: begin
			if(key_r) state <= rst;
			else if(key_e) state <= play;
			else if(key_d) state <= pause;
			else if(key_f) state <= dir_f;
			else if(key_b) state <= dir_b;
			else state <= idle;
		end
		
		play: state <= idle;
			
		pause: state <= idle;
			
		dir_f: state <= idle;
			
		dir_b: state <= idle;
			
		rst: state <= rst_restore;
		
		rst_restore: state <= idle;
		
		default: state <= idle;
			
	endcase
end

// Output
always_ff @ (posedge inclk)
begin
	case(state)
		idle_delay: count <= count + 1;
		check_key: count <= 0;
		play: key_ctrl_sig[0] <= 1;
		pause: key_ctrl_sig[0] <= 0;
		dir_f: key_ctrl_sig[1] <= 0;
		dir_b: key_ctrl_sig[1] <= 1;
		rst: key_ctrl_sig[2] <= 1;
		rst_restore: key_ctrl_sig[2] <= 0;
	endcase

end

endmodule
