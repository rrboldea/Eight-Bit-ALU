module srtr4_reg_tb;

reg clk,rst_b;
reg load,c_down,rshift,lshift1,lshift2;
reg left_in;
reg [1:0] right_in;
reg [7:0] d;
wire q;

srtr4_reg #(.size(8)) test
(
	.clk(clk),
	.rst_b(rst_b),
	.load(load),
	.c_down(c_down),
	.rshift(rshift),
	.lshift1(lshift1),
	.lshift2(lshift2),
	.left_in(left_in),
	.right_in(right_in),
	.d(d),
	.q(q)
);

endmodule