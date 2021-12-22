// CPEN 311 Lab 1 Code: display_tone.sv
// Author: Tom Sung
// Date: September 18, 2021
// Copyright (c) 2021 by Ke-Jun (Tom) Sung

// This module is the same as tone_freq.sv but with parameters changed for LCD Scope.
module display_tone(input logic [3:1] switches, output logic [31:0] note);

// All the notes in parameter/Define all audio signals to be used.
	parameter note_do1 = {{8'h44},{8'h6F},{16'h20}};
	parameter note_re = {{8'h52},{8'h65},{16'h20}};
	parameter note_mi = {{8'h4D},{8'h69},{16'h20}};
	parameter note_fa = {{8'h46},{8'h61},{16'h20}};
	parameter note_so = {{8'h53},{8'h6F},{16'h20}};
	parameter note_la = {{8'h4C},{8'h61},{16'h20}};
	parameter note_si = {{8'h53},{8'h69},{16'h20}};
	parameter note_do2 = {{8'h44},{8'h6F},{8'h32},{8'h20}};
	
	always_comb
		case(switches)
			3'b000: note=note_do1;
			3'b001: note=note_re;
			3'b010: note=note_mi;
			3'b011: note=note_fa;
			3'b100: note=note_so;
			3'b101: note=note_la;
			3'b110: note=note_si;
			3'b111: note=note_do2;
			default: note=note_do1;
		endcase
endmodule
