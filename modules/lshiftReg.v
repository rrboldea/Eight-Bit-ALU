//general left shift register, capable of loading and shifting data any amount 
//of bits

module lshiftReg #(parameter bits_shift=2, parameter size=8)
(
	input clk,rst_b,load,lshift,
	input [bits_shift-1:0] in,
	input [size-1:0] d,
	output [size-1:0] q
);

wire ld;
assign ld=load | lshift;

wire w[size-1:0];

genvar i;
generate
	for(i=0;i<bits_shift;i=i+1) begin: loop1
		mux_1sel #(.size(1)) mux_in
		(
			.sel(load),
			.value1(d[i]),
			.value0(in[i]),
			.q(w[i])
		);
	end
endgenerate

generate
	for(i=bits_shift;i<size;i=i+1) begin: loop2
		mux_1sel #(.size(1)) mux_i
		(
			.sel(load),
			.value1(d[i]),
			.value0(q[i-bits_shift]),
			.q(w[i])
		);
	end
endgenerate

generate
	for(i=0;i<size;i=i+1) begin: loop3
		d_ff d_ff_i
		(
			.clk(clk),
			.rst_b(rst_b),
			.set_b(1'b1),
			.load(ld),
			.data(w[i]),
			.q(q[i]),
			.q_b()
		);
	end
endgenerate

endmodule
