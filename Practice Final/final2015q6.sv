// CPEN 311 Practice Final 2015 Question 6: final2015q6.sv
// Author: Tom Sung
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
module final2015q6(
	input logic clk, resetb,
	input logic [7:0] n,
	input logic [15:0] b,
	output logic [15:0] result,
	output logic done,
	// The signals below are used for testbench purposes.
	output logic [3:0] state,
	output logic [15:0] xn, temp2,
	output logic [31:0] temp1, temp2_32, xn_32
);

//logic [31:0] temp1, temp2_32, xn_32;
//logic [15:0] temp2, xn;
logic [7:0] count_n;
//logic [3:0] state;

localparam idle = 4'b0000;
localparam check_n = 4'b0001;
localparam calc_temp1 = 4'b0010;
localparam calc_temp2_1 = 4'b0011;
localparam calc_temp2_2 = 4'b0100;
localparam calc_xn_1 = 4'b0101;
localparam calc_xn_2 = 4'b0110;
localparam finish = 4'b1111;

assign done = state[3];

always_ff @ (posedge clk) begin
	if(~resetb) state <= idle;
	else begin
		case(state)
			idle: state <= check_n;
			check_n: begin
				if(count_n > 0) state <= calc_temp1;
				else state <= finish;
			end
			calc_temp1: state <= calc_temp2_1;
			calc_temp2_1: state <= calc_temp2_2;
			calc_temp2_2: state <= calc_xn_1;
			calc_xn_1: state <= calc_xn_2;
			calc_xn_2: state <= check_n;
			finish: state <= finish;
			default: state <= idle;
		endcase
	end
end

always_ff @ (posedge clk) begin
	case(state)
		idle: begin
			count_n <= n-1'b1;
			temp1 <= 0;
			temp2 <= 0;
			xn <= 16'h0020;
		end
		check_n: count_n <= count_n - 1'b1;
		calc_temp1: temp1 <= b * xn;
		calc_temp2_1: temp2_32 <= 32'h0002_0000-temp1;
		calc_temp2_2: temp2 <= temp2_32[23:8];
		calc_xn_1: xn_32 <= xn*temp2;
		calc_xn_2: xn <= xn_32[23:8];
		finish: result <= xn;
	endcase
end

endmodule



`timescale 1ns/1ns
module tb_final2015q6(output logic [15:0] test);

assign test = 8'h40 * 8'h32;

logic clk, resetb, done;
logic [7:0] n;
logic [15:0] b, result, xn;
logic [3:0] state;
logic [15:0] temp2;
logic [31:0] temp1, temp2_32, xn_32;

final2015q6 final2015q6_inst(.clk(clk),.resetb(resetb),.done(done),.n(n),.b(b),.result(result),.state(state),
.xn(xn), .temp2(temp2),.temp1(temp1),.temp2_32(temp2_32),.xn_32(xn_32));


always begin
	clk = 0; #1; clk = 1; #1;
end

initial begin
	resetb=1; #2; resetb=0; #3; resetb=1; b=16'h0500; n=10;

end

endmodule
