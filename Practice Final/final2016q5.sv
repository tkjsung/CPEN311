// CPEN 311 Practice Final 2016 Question 5: final2016q5.sv
// Author: Tom Sung
// Copyright (c) 2021 by Ke-Jun (Tom) Sung
module final2016q5(
	input logic clk, resetb,
	output logic [8:0] count,
	output logic done
);

logic [7:0] address_a, address_b, data_a, data_b, q_a, q_b;
logic wren_a, wren_b;

logic [8:0] count_a, count_b;
logic [2:0] addr_count;
logic compare_a, compare_b;

logic [3:0] state;
localparam idle = 4'b000_0;
localparam count_ascii = 4'b001_0;
localparam update_addr = 4'b010_0;
localparam add_count = 4'b011_0;
localparam finish = 4'b100_1;

assign done = state[0];

assign compare_a = ((q_a[addr_count] > 96 && q_a[addr_count] < 123) | (q_a[addr_count] == 32));
assign compare_b = ((q_b[addr_count] > 96 && q_b[addr_count] < 123) | (q_b[addr_count] == 32));

always_ff @ (posedge clk, negedge resetb) begin
	if(~resetb) state <= idle;
	else begin
		case(state)
			idle: state <= count_ascii;
			count_ascii: if(addr_count == 0) state <= update_addr;
			update_addr: begin
				if(address_a >= 8'hFE | address_b >= 8'hFE) state <= add_count;
				else state <= count_ascii;
			end
			add_count: state <= finish;
			finish: state <= finish;
			default: state <= idle;
		endcase
	end
end

always_ff @ (posedge clk) begin
	case(state)
		idle: begin
			count <= 9'd0;
			address_a <= 8'd0;
			address_b <= 8'd1;
			addr_count <= 3'd7;
			count_a <= 9'd0;
			count_b <= 9'd0;
		end

		count_ascii: begin
			if(compare_a) count_a <= count_a + 1'b1;
			if(compare_b) count_b <= count_b + 1'b1;
			addr_count <= addr_count - 1'b1;
		end

		update_addr: begin
			address_a <= address_a + 2'd2;
			address_b <= address_b + 2'd2;
			addr_count <= 3'd7;
		end

		add_count: count <= count_a + count_b;

	endcase
end

endmodule
