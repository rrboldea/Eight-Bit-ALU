module srtr4_lookup_table_tb;

reg [5:0] p;
reg [3:0] b;
wire two_b,one_b,zero,one,two;

srtr4_lookup_table test
(
	.p(p),
	.b(b),
	.two_b(two_b),
	.one_b(one_b),
	.zero(zero),
	.one(one),
	.two(two)
);

initial begin
	b=8;
	p=-32;
end

integer i;
always begin
	for(i=0; i<64; i=i+1) begin
		#50 p=p+1;
	end
	b[2:0]=b[2:0]+1;
end

endmodule