module RCA_adder #(parameter size=8)
(
	input cin,
	input [size-1:0] x,y,
	output cout,
	output [size-1:0] z
);

wire [size:0] carry;
assign carry[0]=cin;
assign cout=carry[size];

genvar i;
generate
	for(i=0;i<size;i=i+1) begin
		fac fac_i
		(
			.x(x[i]),
			.y(y[i]),
			.cin(carry[i]),
			.z(z[i]),
			.cout(carry[i+1])
		);
	end
endgenerate

endmodule