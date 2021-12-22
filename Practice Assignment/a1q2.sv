// CPEN 311 Practice Assignment 1 Question 2: a1q2.sv
// Author: Tom Sung
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
module a1q2(
	input logic [2:0] in_data,
	output logic [7:0] out_data
);

always_comb begin
	case(in_data)
		3'b000: out_data = 8'b0000_0001;
		3'b001: out_data = 8'b0000_0010;
		3'b010: out_data = 8'b0000_0100;
		3'b011: out_data = 8'b0000_1000;
		3'b100: out_data = 8'b0001_0000;
		3'b101: out_data = 8'b0010_0000;
		3'b110: out_data = 8'b0100_0000;
		3'b111: out_data = 8'b1000_0000;
	endcase
end
endmodule
