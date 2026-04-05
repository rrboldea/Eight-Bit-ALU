module add_sub_1 #(parameter size=8)
(
	input add_sub,
	input [size-1:0] x,
	output cout,
	output [size-1:0] z
);

assign z[0]= ~x[0];

wire [size-1:0] carry;
assign carry[0]=x[0];
assign cout=carry[size-1];

wire [size-1:1] y;

genvar i;

generate 
	for(i=1;i<size;i=i+1) begin
		mux_1sel mux_i
		(
			.sel(add_sub),
			.value1(1'b0),
			.value0(1'b1),
			.q(y[i])
		);
	end
endgenerate

generate
	for(i=1;i<size;i=i+1) begin
		fac fac_i
		(
			.x(x[i]),
			.y(y[i]),
			.cin(carry[i-1]),
			.z(z[i]),
			.cout(carry[i])
		);
	end
endgenerate

endmodule