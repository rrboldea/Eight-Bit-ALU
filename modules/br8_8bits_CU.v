//the control unit handling the execution of the booth radix 8 algorithm

module br8_8bits_CU
(
	input clk,rst_b,
	input BEGIN,
	input [2:-1] q,
	input [1:0] cnt,
	output END,
	output [8:0] c
);

//auxiliary wires
wire s1_11;
wire s_any_add;

wire v_is_pos1;
wire v_is_pos2;
wire v_is_pos3;
wire v_is_pos4;
wire v_is_neg1;
wire v_is_neg2;
wire v_is_neg3;
wire v_is_neg4;
wire v_is_zero;

//next value of the n-th state bit,
//n-th state bit
wire [12:0] next;
wire [12:0] state;

assign s1_11 = state[1] | state[11];

assign v_is_pos1 = (~q[2] & ~q[1] & ~q[0] & q[-1]) | (~q[2] & ~q[1] & q[0] & ~q[-1]);
assign v_is_pos2 = (~q[2] & ~q[1] & q[0] & q[-1]) | (~q[2] & q[1] & ~q[0] & ~q[-1]);
assign v_is_pos3 = (~q[2] & q[1] & ~q[0] & q[-1]) | (~q[2] & q[1] & q[0] & ~q[-1]);
assign v_is_pos4 = (~q[2] & q[1] & q[0] & q[-1]);
assign v_is_neg4 = (q[2] & ~q[1] & ~q[0] & ~q[-1]);
assign v_is_neg3 = (q[2] & ~q[1] & ~q[0] & q[-1]) | (q[2] & ~q[1] & q[0] & ~q[-1]);
assign v_is_neg2 = (q[2] & ~q[1] & q[0] & q[-1]) | (q[2] & q[1] & ~q[0] & ~q[-1]);
assign v_is_neg1 = (q[2] & q[1] & ~q[0] & q[-1]) | (q[2] & q[1] & q[0] & ~q[-1]);
assign v_is_zero = (~q[2] & ~q[1] & ~q[0] & ~q[-1]) | (q[2] & q[1] & q[0] & q[-1]);

assign s_any_add = state[2] | state[3] | state[4] | state[5] | state[6] | state[7] | state[8] | state[9];

wire cnt2 = cnt[1] & (~cnt[0]); // Check for 2 iterations (since it counts 0, 1, 2)

//Next values for the d-ffs
assign next[0] = (state[0] & (~BEGIN)) | state[12];
assign next[1] = state[0] & BEGIN;
assign next[2] = s1_11 & v_is_pos1;
assign next[3] = s1_11 & v_is_pos2;
assign next[4] = s1_11 & v_is_pos3;
assign next[5] = s1_11 & v_is_pos4;
assign next[6] = s1_11 & v_is_neg1;
assign next[7] = s1_11 & v_is_neg2;
assign next[8] = s1_11 & v_is_neg3;
assign next[9] = s1_11 & v_is_neg4;
assign next[10]= (s1_11 & v_is_zero) | s_any_add;
assign next[11]= state[10] & (~cnt2);
assign next[12]= state[10] & cnt2;

//Output assignments
assign END = state[0];
assign c[0] = state[1];
assign c[1] = s_any_add;
assign c[2] = state[6] | state[7] | state[8] | state[9]; // sub
assign c[3] = state[3] | state[7];                       // 2M
assign c[4] = state[5] | state[9];                       // 4M
assign c[5] = state[4] | state[8] | state[5] | state[9]; // 3M/4M selector
assign c[6] = state[10];                                 // shift
assign c[7] = state[11];                                 // check (increment cnt)
assign c[8] = state[12];                                 // ready

//d-ffs representing one state in the one-hot hardware design
d_ff d_ff_0
(
	.clk(clk),
	.rst_b(1'b1),
	.set_b(rst_b),   
	.load(1'b1),
	.data(next[0]),
	.q(state[0]),
	.q_b()
);
genvar i;
generate
	for(i=1;i<=12;i=i+1) begin: loop
		d_ff d_ff_i
		(
			.clk(clk),
			.rst_b(rst_b),
			.set_b(1'b1),
			.load(1'b1),
			.data(next[i]),
			.q(state[i]),
			.q_b()
		);
	end
endgenerate

endmodule