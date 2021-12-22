// CPEN 311 Lab 1 Code: tone_freq.sv
// Author: Tom Sung
// Date: September 18, 2021
// Copyright (c) 2021 by Ke-Jun (Tom) Sung

// This module selects the correct tone divisor for the frequency divider.
module tone_freq(input logic [3:1] switches, output logic [31:0] note);
	
	// All the notes in parameter/Define all audio signals to be used.
	parameter note_do1 = 32'hBAB9; //(25*10^6)/523 = 47801
	parameter note_re = 32'hA65D; //(25*10^6)/587 = 42589
	parameter note_mi = 32'h9430; //(25*10^6)/659 = 37936
	parameter note_fa = 32'h8BE9; //(25*10^6)/698 = 35817
	parameter note_so = 32'h7CB8; //(25*10^6)/783 = 31928
	parameter note_la = 32'h6EF9; //(25*10^6)/880 = 28409
	parameter note_si = 32'h62F1; //(25*10^6)/987 = 25329
	parameter note_do2 = 32'h5D5D; //(25*10^6)/1046 = 23901
	
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
