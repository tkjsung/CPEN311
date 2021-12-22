// CPEN 311 Practice Final 2016 Question 2: final2016q2.sv
// Author: Tom Sung
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
module final2016q2(
	input logic clk,
	input logic [7:0] xn, a1, a2, b1, b2,
	output logic [7:0] yn
);

logic [7:0] b1_in, b1_out, b2_in, b2_out, a1_in, a1_out, a2_in, a2_out, one_out, two_out;

always_ff @ (posedge clk) begin
	b1_in <= xn;
	b2_in <= b1_in;
	a1_in <= yn;
	a2_in <= a1_in;
end

assign b1_out = b1*b1_in;
assign b2_out = b2*b2_in;
assign a1_out = a1*a1_in;
assign a2_out = a2*a2_in;
assign two_out = b2_out + b1_out;
assign one_out = a1_out + a2_out + two_out;
assign yn = xn + one_out;


endmodule
