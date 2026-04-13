module srtr4_reg #(parameter size=8)
(
	input clk,rst_b,load,rshift,lshift1,lshift2,c_down,
	input left_in,
	input [1:0] right_in,
	input [size-1:0] d,
	output [size-1:0] q
);


//we store all bits, including the left_in and right_in for shifting 
wire [size:-2] data;

genvar i;
generate
	for(i=0;i<size;i=i+1) begin: loop0
		assign data[i]=q[i];
	end
endgenerate
assign data[size]=left_in;
assign data[-1:-2]={right_in[1],right_in[0]};



//combinational logic for finding the value minus 1
wire [size-1:0] cnt;
wire [size:1] carry;

assign cnt[0]=~q[0];
assign carry[1]=q[0];


generate
	for(i=1;i<size;i=i+1) begin: loop1
		fac fac_i
		(
			.x(q[i]),
			.y(1'b1),
			.cin(carry[i]),
			.z(cnt[i]),
			.cout(carry[i+1])
		);
	end
endgenerate


//wire for storing the multiplexed values
wire [size-1:0] w0,w1,w2,w3;

generate
	for(i=0;i<size;i=i+1) begin: loop2
		mux_1sel #(.size(1)) mux_0i
		(
			.sel(load),
			.value1(d[i]),
			.value0(w1[i]),
			.q(w0[i])
		);
	end
endgenerate

generate
	for(i=0;i<size;i=i+1) begin: loop3
		mux_1sel #(.size(1)) mux_1i
		(
			.sel(c_down),
			.value1(cnt[i]),
			.value0(w2[i]),
			.q(w1[i])
		);
	end
endgenerate

generate
	for(i=0;i<size;i=i+1) begin: loop4
		mux_1sel #(.size(1)) mux_2i
		(
			.sel(rshift),
			.value1(data[i+1]),
			.value0(w3[i]),
			.q(w2[i])
		);
	end
endgenerate

generate
	for(i=0;i<size;i=i+1) begin: loop5
		mux_1sel #(.size(1)) mux_3i
		(
			.sel(lshift1),
			.value1(data[i-1]),
			.value0(data[i-2]),
			.q(w3[i])
		);
	end
endgenerate


wire ld;
assign ld=load | c_down | rshift | lshift1 | lshift2;

register #(.size(size)) register
(
	.clk(clk),
	.rst_b(rst_b),
	.load(ld),
	.data(w0),
	.q(q)
);

endmodule
