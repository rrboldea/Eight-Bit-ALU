
//simple register, capable of loading data

module register #(parameter size=1)
(
	input clk,rst_b,load,
	input [size-1:0] data,
	output [size-1:0] q
);

genvar i;
generate
	for(i=0;i<size;i=i+1) begin
		d_ff d_ff_i
		(
			.clk(clk),
			.rst_b(rst_b),
			.set_b(1'b1),
			.load(load),
			.data(data[i]),
			.q(q[i]),
			.q_b()
		);
	end
endgenerate

endmodule
