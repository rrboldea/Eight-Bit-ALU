module srtr4_8bits_CU
(
	input clk,rst_b,
	input BEGIN,
	input [1:0] cnt,
	input [2:0] k,
	input [3:0] b,
	input [5:0] p,
	output END,
	output [13:0] c 
);

//wire representing the state of the machine (only one bit can be of value 1, one hot),
//wire repreenting the next value each bit will take
wire [16:0] state
wire [16:0] next;


//wires signifying which redundant digit will be next, {-2,-1,0,1,2}
wire two_b,one_b,zero,one,two;

strr4_lookup_table lookup
(
	.b(b),
	.p(p),
	.two_b(two_b),
	.one_b(one_b),
	.zero(zero),
	.one(one),
	.two(two)
);


//auxiliary wires
wire s1_2_b3_s_12;
wire cnt3;
wire s4_6_8_10_11;
wire s4_6_8_10_11_cnt3;
wire s4_6_8_10_11_cnt3_p5_b;
wire k0;

assign s1_2_b3_s12=((state[1] | state[2]) & b[3]) | state[12];
assign cnt3=cnt[1] & cnt[0];
assign s4_6_8_10_11=state[4] | state[6] | state[8] | state[10] | state[11];
assign s4_6_8_10_11_cnt3=s4_6_8_10_11 & cnt3;
assign s4_6_8_10_11_cnt3_p5_b=s4_6_8_10_11_cnt3 & (~p[5]);
assign k0=(~k[1]) & (~k[0]);

assign next[0]=(state[0] & (~BEGIN)) | (s1_2_b3_s12 & (~two_b) & (~one_b) & (~zero) & (~one) & (~two)) | state[16];
assign next[1]=state[0] & BEGIN;
assign next[2]=(state[1] | state[2]) & (~b[3]);
assign next[3]=s1_2_b3_s12 & one_b;
assign next[4]=state[3];
assign next[5]=s1_2_b3_s12 & two_b;
assign next[6]=state[5];
assign next[7]=s1_2_b3_s12 & one;
assign next[8]=state[7];
assign next[9]=s1_2_b3_s12 & two;
assign next[10]=state[9];
assign next[11]=s1_2_b3_s12 & zero;
assign next[12]=s4_6_8_10_11 & (~cnt3);
assign next[13]=s4_6_8_10_11_cnt3 & p[5];
assign next[14]=(s4_6_8_10_11_cnt3_p5_b | state[13] | state[14]) & (~k0);
assign next[15]=(s4_6_8_10_11_cnt3_p5_b | state[13] | state[14]) & k0;
assign next[16]=state[15];


assign END=state[0];
assign c[0]=state[1];
assign c[1]=state[2];
assign c[2]=state[3] | state[5] | state[7] | state[9] | state[11];
assign c[3]=state[3] | state[5];
assign c[4]=state[3] | state[7];
assign c[5]=state[5] | state[9];
assign c[6]=state[4] | state[6] | state[8] | state[10] | state[13];
assign c[7]=state[8] | state[10] | state[15];
assign c[8]=state[6] | state[10];
assign c[9]=state[12];
assign c[10]=state[13];
assign c[11]=state[14];
assign c[12]=state[15];
assign c[13]=state[16];


//d-ffs representing one state in the one-hot hardware design
d_ff d_ff_0
(
	.clk(clk),
	.rst_b(1'b1),

	//when reseting, we want to go to state 0, meaning state[0] needs to be
	//set to 1; the rest, states from 1-16 need to be reset to 0
	.set_b(rst_b),   
	.load(1'b1),
	.data(next[0]),
	.q(state[0]),
	.q_b()
);
genvar i;
generate
	for(i=1;i<=16;i=i+1) begin: loop
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








