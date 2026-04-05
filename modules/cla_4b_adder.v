
//carry lookahead adder cell on 4 bits

module cla_4b_adder
(
	input cin,
	input [3:0] x,y,
	output cout,
	output [3:0] z
);

wire carry[4:0];
assign carry[0]=cin;
assign cout=carry[4];


wire [3:0] g,p;

genvar i;
generate
	for(i=0;i<4;i=i+1) begin
		ac ac_i
		(
			.x(x[i]),
			.y(y[i]),
			.cin(carry[i]),
			.g(g[i]),
			.p(p[i]),
			.z(z[i])
		);
	end
endgenerate

cla_4b_carry cla_4b_carry
(
	.cin(carry[0]),
	.g(g),
	.p(p),
	.carry({carry[4:1]})
);

endmodule
