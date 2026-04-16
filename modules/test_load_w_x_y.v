
//used for loading x and y in a test module only using 8 switches
//on the intel de10-lite

module test_load_w_x_y
(
	input clk,rst_b,ld_w_x_y,
	input [7:0] data,
	output [7:0] w,x,y
);

wire [1:0] state;
wire [1:0] next;

assign next[1]=state[0];
assign next[0]=~(state[1] | state[0]);

register #(.size(2)) state_reg
(
	.clk(clk),
	.rst_b(rst_b),
	.load(ld_w_x_y),
	.data(next),
	.q(state)
);

register #(.size(8)) W
(
	.clk(clk),
	.rst_b(rst_b),

	//we load only in the first state
	.load(ld_w_x_y & next[0]),
	.data(data),
	.q(w)
);

register #(.size(8)) X
(
	.clk(clk),
	.rst_b(rst_b),

	//we load only in the second state
	.load(ld_w_x_y & state[0]),
	.data(data),
	.q(x)
);

register #(.size(8)) Y
(
	.clk(clk),
	.rst_b(rst_b),

	//we load only in the third state
	.load(ld_w_x_y & state[1]),
	.data(data),
	.q(y)
);

endmodule




