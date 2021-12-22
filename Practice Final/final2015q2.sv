// CPEN 311 Practice Final 2015 Question 2: final2015q2.sv
// Author: Tom Sung
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
module final2015q2(
	input logic shift, load, drive, clk,
	inout logic [7:0] bus
);

logic [7:0] reg_q;

always_ff @ (posedge clk) begin
	if(load) reg_q <= bus;
	if(shift) reg_q <= reg_q >> 1;
end

assign bus = drive ? reg_q : 1'bz;

endmodule
