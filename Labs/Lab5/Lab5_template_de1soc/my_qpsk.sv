`default_nettype none
`timescale 1ns/1ns

// CPEN 311 Lab 5 Code: my_qpsk.sv
// Author: Tom Sung
// Date: November 11, 2021
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
// Purpose: QPSK Bonus Task Algorithm
// 			From mathematical derivations, signals start at a...
//				... different phase angle than 0: x(t) = I(t)cos(t)-Q(t)sin(t).
// 			Use another DDS. Start signal from 45 deg by accounting for the phase accumulator.
module my_qpsk(
	input logic clk, clk_1Hz, reset,
	input logic [1:0] lfsr_sync_sig,
	output logic [11:0] qpsk_sin_out, qpsk_cos_out, qpsk_saw_out, qpsk_squ_out,
	output logic [11:0] dds_qpsk
);

logic [11:0] qpsk_sin_invert, qpsk_cos_invert;
logic [11:0] qpsk_address;
reg [11:0] dds_word = 32'd258;
reg [31:0] qpsk_address_init = 32'h1FF00000; // Required for mimicking the DDS Core "waveform_gen.vhd".

assign qpsk_address = qpsk_address_init[31:20];
assign qpsk_sin_invert = ~qpsk_sin_out + 1'b1;
assign qpsk_cos_invert = ~qpsk_cos_out + 1'b1;
assign qpsk_saw_out = qpsk_address;
assign qpsk_squ_out = qpsk_address[11] ? 12'h7FF : 12'h800;

// Call the Look-Up Table directly. DDS logic will be handled via this module.
sincos_lut qpsk_signal_module (
	.clk(clk),
	.en(1'b1),
	.addr(qpsk_address),
	.sin_out(qpsk_sin_out),
	.cos_out(qpsk_cos_out)
);

// QPSK Message Data Select. To make sure LFSR values are not re-used, a counter is needed (adds delay to VGA out)
reg counter = 0;
reg counter_sync = 0;
always_ff @ (posedge clk_1Hz) begin
	if(counter) counter <= 0;
	else counter <= 1;
end

// Sync counter variable properly across clock domains (for QPSK)
my_clockDomain_slow2fast #(.N(1)) clockDomain_counterSync(
	.fast_clk(clk),
	.slow_clk(clk_1Hz),
	.async_in(counter),
	.sync_out(counter_sync)
);

// Select the correct QPSK modulation signal
logic [1:0] current_lfsr;
always_ff @ (posedge clk) begin
	if(~reset) qpsk_address_init <= 32'h1FF00000;
	else begin
		qpsk_address_init <= qpsk_address_init + dds_word;
		if(counter_sync) begin
			current_lfsr <= lfsr_sync_sig;
			case(lfsr_sync_sig)
				2'b00: dds_qpsk <= qpsk_cos_invert;
				2'b01: dds_qpsk <= qpsk_sin_out;
				2'b10: dds_qpsk <= qpsk_sin_invert;
				2'b11: dds_qpsk <= qpsk_cos_out;
			endcase
		end
		else begin
			case(current_lfsr)
				2'b00: dds_qpsk <= qpsk_cos_invert;
				2'b01: dds_qpsk <= qpsk_sin_out;
				2'b10: dds_qpsk <= qpsk_sin_invert;
				2'b11: dds_qpsk <= qpsk_cos_out;
			endcase
		end
	end
end

endmodule
