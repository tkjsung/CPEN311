`default_nettype none

// CPEN 311 Lab 2 Code: my_fsm_addr_gen.sv
// Author: Tom Sung
// Date: October 13, 2021
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
module my_fsm_addr_gen #(parameter N = 2)(
	input logic inclk, audio_inclk, reset,
	input logic flag_play, flag_finishFlash, flag_direction,
	input logic [31:0] in_audio_data,
	output logic [(32/N)-1:0] out_audio_data,
	output logic [22:0] current_addr,
	output logic flag_readFlash
);

parameter max_addr = 23'h7FFFF;
logic [4:0] state;
logic [2:0] count;
logic count_compare;

parameter idle_reset = 5'b0_0000;
parameter idle = 5'b0_0001;
parameter start_flash = 5'b1_0010;
parameter get_data = 5'b0_0011;
parameter play_data = 5'b0_0100;
parameter addr_update = 5'b0_0101;
parameter increment = 5'b0_0110;
parameter decrement = 5'b0_0111;
parameter finish = 5'b0_1000;


assign flag_readFlash = state[4];
assign count_compare = count < N; // will be 1 when count is less than N.

always_ff @ (posedge inclk, negedge reset) begin
	if(~reset)
		state <= idle_reset;
	else begin
		case(state)
			idle_reset: state <= idle;
			
			idle: begin
				if(flag_play) state <= start_flash;
				else state <= idle;
			end
			
			start_flash: begin
				if(flag_finishFlash) state <= get_data;
				else state <= start_flash;
			end
			
			get_data: begin
				if(audio_inclk) state <= play_data;
				else state <= get_data;
			end
			
			play_data: begin
				// Wait until audio_inclk is LOW before going back to get_data. Otherwise, get_data may
				// immediately get next sample.
				if(~audio_inclk & count_compare) state <= get_data;
				else if(~audio_inclk & ~count_compare) state <= addr_update;
				else state <= play_data;
			end
			
			addr_update: begin
				if(~flag_direction) state <= increment;
				else state <= decrement;
			end
			
			increment: state <= finish;
			decrement: state <= finish;
			finish: state <= idle;
			
			default: state <= idle;
		endcase
	end
end

always_ff @ (posedge inclk) begin
	case(state)
		idle_reset: begin
			current_addr <= max_addr;
			out_audio_data <= 0;
			count <= 0;
		end
		
		get_data: begin
			if(audio_inclk) count <= count + 1;
			else count <= count;
		end
		
		play_data: begin
			if(N==4) begin
				if(~flag_direction) begin
					case(count)
						3'd1: out_audio_data <= in_audio_data[7:0];
						3'd2: out_audio_data <= in_audio_data[15:8];
						3'd3: out_audio_data <= in_audio_data[23:16];
						3'd4: out_audio_data <= in_audio_data[31:24];
						default: out_audio_data <= in_audio_data[7:0];
					endcase
				end
				else begin
				case(count)
						3'd1: out_audio_data <= in_audio_data[31:24];
						3'd2: out_audio_data <= in_audio_data[23:16];
						3'd3: out_audio_data <= in_audio_data[15:8];
						3'd4: out_audio_data <= in_audio_data[7:0];
						default: out_audio_data <= in_audio_data[31:24];
					endcase
				end
					
			end
			else begin
				if(~flag_direction) begin
					case(count)
						3'd1: out_audio_data <= in_audio_data[15:0];
						3'd2: out_audio_data <= in_audio_data[31:16];
					endcase
				end
				else begin
					case(count)
					3'd1: out_audio_data <= in_audio_data[31:16];
					3'd2: out_audio_data <= in_audio_data[15:0];
					endcase
				end
			end
		end
		
		addr_update: count <= 0;
		
		increment: begin
			if(current_addr >= max_addr) current_addr <= 0;
			else begin
				current_addr <= current_addr + 23'd1;
				end
			end
			
		decrement: begin
			if(current_addr == 0) current_addr <= max_addr;
			else begin
				current_addr <= current_addr - 23'd1;
				end
			end
	endcase

end

endmodule

