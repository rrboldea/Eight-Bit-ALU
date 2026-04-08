
//the control unit handling the execution of the booth radix 4 algorithm

module br4_8bits_CU
(
	input clk,rst_b,
	input BEGIN,
	input [1:-1] q,
	input [1:0] cnt,
	output END,
	//output [10:0] state,
	output [7:0] c
);

//auxiliary wires
wire q0_exor_q_1;
wire q1_exor_q_1;
wire q1_b;
wire s28;
wire s56;
wire s456;
wire s3456;
wire cnt3;

//next value of the n-th state bit,
//n-th state bit
wire [9:0] next;
wire [9:0] state;

assign q0_exor_q_1=q[0] ^ q[-1];
assign q1_exor_q_1=q[1] ^ q[-1];
assign q1_b=~q[1];
assign s28=state[2] | state[8];
assign s56=state[5] | state[6];
assign s46=state[4] | state[6];
assign s3456=state[3] | state[4] | s56;
assign cnt3=cnt[1] & cnt[0];


//Next values for the d-ffs
assign next[0]=state[0] & (~BEGIN) | state[9];
assign next[1]=state[0] & BEGIN;
assign next[2]=state[1];
assign next[3]=s28 & q1_b & q0_exor_q_1;
assign next[4]=s28 & q1_b & q[0] & q[-1];
assign next[5]=s28 & q[1] & q0_exor_q_1;
assign next[6]=s28 & q[1] & (~q[0]) & (~q[-1]);
assign next[7]=(s28 & (~q1_exor_q_1) & (~q0_exor_q_1)) | s3456;
assign next[8]=state[7] & (~cnt3);
assign next[9]=state[7] & cnt3;

//Output assignents
assign END=state[0];
assign c[0]=state[1];
assign c[1]=state[2];
assign c[2]=s3456;
assign c[3]=s56;
assign c[4]=s46;
assign c[5]=state[7];
assign c[6]=state[8];
assign c[7]=state[9];

//d-ffs representing one state in the one-hot hardware design
d_ff d_ff_0
(
	.clk(clk),
	.rst_b(1'b1),

	//when reseting, we want to go to state 0, meaning state[0] needs to be
	//set to 1; the rest, states from 1-10 need to be reset to 0
	.set_b(rst_b),   
	.load(1'b1),
	.data(next[0]),
	.q(state[0]),
	.q_b()
);
genvar i;
generate
	for(i=1;i<=9;i=i+1) begin: loop
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










