`default_nettype none

// CPEN 311 Lab 4 Code (Main Module/Top Level Entity): ksa.sv
// Author: Tom Sung
// Date: October 30, 2021
// Notice: This module has been re-written into SystemVerilog from the template VHDL file for ease of implementation.
module ksa(
	input logic CLOCK_50,
	input logic [3:0] KEY,
	input logic [9:0] SW,
	output logic [9:0] LEDR,
	output logic [6:0] HEX0,
	output logic [6:0] HEX1,
	output logic [6:0] HEX2,
	output logic [6:0] HEX3,
	output logic [6:0] HEX4,
	output logic [6:0] HEX5
);

// === Given Signals from Template ===
logic clk, reset_n;
assign clk = CLOCK_50;
assign reset_n = KEY[3];

// === Challenge Task Required Signals ===
logic compare_fail, compare_finish;
logic core1_fail, core2_fail, core3_fail, core4_fail;
logic core1_finish, core2_finish, core3_finish, core4_finish;
assign compare_fail = core1_fail & core2_fail & core3_fail & core4_fail;
assign compare_finish = core1_finish | core2_finish | core3_finish | core4_finish;
assign LEDR[9] = compare_finish;
assign LEDR[8] = compare_fail;

logic [23:0] secret_key;
logic [23:0] secret_key_core1, secret_key_core2, secret_key_core3, secret_key_core4;

// === Challenge Task: Secret Key Selection for HEX Display
always_comb begin
	case({{core1_finish},{core2_finish},{core3_finish},{core4_finish}})
		4'b1000: secret_key <= secret_key_core1;
		4'b0100: secret_key <= secret_key_core2;
		4'b0010: secret_key <= secret_key_core3;
		4'b0001: secret_key <= secret_key_core4;
		default: secret_key <= secret_key_core1;
	endcase
end

// === Task 1 and 2a ===
//my_task2a_algo task2a(
//	.inclk(clk),
//	.switch(SW[9:0]),
//	.key(KEY[3:0]),
//	.led(LEDR[1:0])
//);

// === Task 2b ===
//my_task2b_algo task2b(
//	.inclk(clk),
//	.reset_n(reset_n),
//	.switch(SW[9:0]),
//	.key(KEY[3:0]),
//	.led(LEDR[9:0])
//);

// === Task 3 ===
//my_task3_algo task3(
//	.inclk(clk),
//	.reset_n(reset_n),
//	.key(KEY[3:0]),
//	.led(LEDR[9:0]),
//	.HEX0(HEX0),
//	.HEX1(HEX1),
//	.HEX2(HEX2),
//	.HEX3(HEX3),
//	.HEX4(HEX4),
//	.HEX5(HEX5)
//);

// === Challenge Task: 4-core implementation ===
my_taskChallenge_algo #(.N(4)) core1 
(
	.inclk(clk),
	.reset_n(reset_n),
	.key(KEY[3:0]),
	.flag_fail(core1_fail),
	.flag_finish(core1_finish),
	.secret_key(secret_key_core1),
	.secret_key_init(24'h000000),
	.flag_other_core_finish(compare_finish)
);

my_taskChallenge_algo #(.N(4)) core2
(
	.inclk(clk),
	.reset_n(reset_n),
	.key(KEY[3:0]),
	.flag_fail(core2_fail),
	.flag_finish(core2_finish),
	.secret_key(secret_key_core2),
	.secret_key_init(24'h000001),
	.flag_other_core_finish(compare_finish)
);

my_taskChallenge_algo #(.N(4)) core3
(
	.inclk(clk),
	.reset_n(reset_n),
	.key(KEY[3:0]),
	.flag_fail(core3_fail),
	.flag_finish(core3_finish),
	.secret_key(secret_key_core3),
	.secret_key_init(24'h000002),
	.flag_other_core_finish(compare_finish)
);


my_taskChallenge_algo #(.N(4)) core4
(
	.inclk(clk),
	.reset_n(reset_n),
	.key(KEY[3:0]),
	.flag_fail(core4_fail),
	.flag_finish(core4_finish),
	.secret_key(secret_key_core4),
	.secret_key_init(24'h000003),
	.flag_other_core_finish(compare_finish)
);

// === Challenge Task: 7-Segment Display (Comment if using other tasks) ===
SevenSegmentDisplayDecoder segment0(.ssOut(HEX0), .nIn(secret_key[3:0]));
SevenSegmentDisplayDecoder segment1(.ssOut(HEX1), .nIn(secret_key[7:4]));
SevenSegmentDisplayDecoder segment2(.ssOut(HEX2), .nIn(secret_key[11:8]));
SevenSegmentDisplayDecoder segment3(.ssOut(HEX3), .nIn(secret_key[15:12]));
SevenSegmentDisplayDecoder segment4(.ssOut(HEX4), .nIn(secret_key[19:16]));
SevenSegmentDisplayDecoder segment5(.ssOut(HEX5), .nIn(secret_key[23:20]));

endmodule

