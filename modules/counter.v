
//counter cell, capable of counting up or down by 1

module counter #(parameter size=8)
(
	input clk,rst_b,c_up,c_down,
	output [size-1:0] q
);

wire [size-1:0] data;

wire add_sub;
assign add_sub=c_up;

wire load;
assign load=c_up ^ c_down;

add_sub_1 #(.size(size)) add_sub_1
(
	.add_sub(add_sub),
	.x(q),
	.z(data),
	.cout()
);

register #(.size(size)) register
(	
	.clk(clk),
	.rst_b(rst_b),
	.load(load),
	.data(data),
	.q(q)
);

endmodule
