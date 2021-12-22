// CPEN 311 Practice Assignment 1 Question 3: a1q3.sv
// Author: Tom Sung
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
module a1q3(
	input logic [2:0] in_data,
	output logic [3:0] out_data
);

always_comb begin
	if(in_data[2]) begin
		case(in_data[1:0])
			2'b00: out_data = 4'b0001;
			2'b01: out_data = 4'b0010;
			2'b10: out_data = 4'b0100;
			2'b11: out_data = 4'b1000;
		endcase
	end
	else out_data = 4'd0;
end

endmodule

`timescale 1ns/1ns
module tb_a1q3();
	logic [2:0] in_data;
	logic [3:0] out_data;
	a1q3 assignment1q3(.in_data(in_data),.out_data(out_data));

	initial begin
		in_data = 3'b000; #2;
		in_data = 3'b001; #2;
		in_data = 3'b010; #2;
		in_data = 3'b011; #2;
		in_data = 3'b100; #2;
		in_data = 3'b101; #2;
		in_data = 3'b110; #2;
		in_data = 3'b111; #2;
	end

endmodule
