
//used for loading x and y in a test module only using 8 switches
//on the intel de10-lite

module test_load_x_y
(
	input clk,rst_b,ld_x_y,
	input [7:0] data,
	output [7:0] x,y
);

wire x_y;  //this signal tells in which register (x: 1 or y: 0) data will be loaded next

d_ff x_y_signal
(
	.clk(clk),
	.rst_b(1'b1),

	//upon reset, the x_y value should be 1, meaning we first load x
	.set_b(rst_b),
	.load(ld_x_y),
	
	//the next value needs to be the opposite
	.data(~x_y),
	.q(x_y),	
	.q_b()
);

register #(.size(8)) X
(
	.clk(clk),
	.rst_b(rst_b),

	//we load only when x_y has value 1
	.load(ld_x_y & x_y),
	.data(data),
	.q(x)
);

register #(.size(8)) Y
(
	.clk(clk),
	.rst_b(rst_b),

	//we load only when x_y has value 0
	.load(ld_x_y & (~x_y)),
	.data(data),
	.q(y)
);

endmodule




