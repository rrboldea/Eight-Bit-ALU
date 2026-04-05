module adder #(parameter size=9)
(
	input cin,
	input [size-1:0] x,y,
	output cout,
	output [size-1:0] z
);

wire [size/4+1:0] carry;
assign carry[0]=cin;
assign cout=carry[size/4+1];

genvar i;
generate
	for(i=0;i<size/4;i=i+1) begin
		cla_4b_adder cla_4b_adder_i
		(
			.cin(carry[i]),
			.x({x[(i+1)*4-1:i*4]}),
			.y({y[(i+1)*4-1:i*4]}),
			.cout(carry[i+1]),
			.z({z[(i+1)*4-1:i*4]})
		);
	end
endgenerate

generate
	if(size%4!=0) begin
		RCA_adder #(.size(size%4)) RCA_adder
		(
			.cin(carry[size/4]),
			.x({x[size-1:(size/4)*4]}),
			.y({y[size-1:(size/4)*4]}),
			.cout(carry[size/4+1]),
			.z({z[size-1:(size/4)*4]})
		);
	end
	else begin
		assign carry[size/4+1]=carry[size/4];
	end
endgenerate

endmodule