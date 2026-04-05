module d_ff_tb;

reg clk,rst_b,load,data;
wire q,q_b;

d_ff test
(
	.clk(clk),
	.rst_b(1'b1),
	.set_b(rst_b),
	.load(load),
	.data(data),
	.q(q),
	.q_b(q_b)
);

initial begin
	clk=0;
	rst_b=1;	
	load=0;
	data=0;
	forever #50 clk=~clk;
end

initial begin
	#10 rst_b=0;
	#10 rst_b=1;
	@(posedge clk) load=1;
	data=1;
	@(posedge clk) data=0;
	load=0;
	@(posedge clk) load=1;
	@(posedge clk) load=0;
	repeat(3) @(posedge clk);
	load=1;
	#10 load=0;
end

endmodule