module br8_8bits_CU_tb;

reg clk,rst_b,BEGIN;
reg [2:-1] q;
reg [1:0] cnt;
wire [8:0] c;
wire END;

br8_8bits_CU test
(
	.clk(clk),
	.rst_b(rst_b),
	.BEGIN(BEGIN),
	.q(q),
	.cnt(cnt),
	.c(c),
	.END(END)
);

initial begin
	clk=0;
	rst_b=1;
	BEGIN=0;
	q=4'b0;
	cnt=2'b0;
	forever #50 clk=~clk;
end

initial begin
	repeat(2) #10 rst_b=~rst_b;
	//state 0
	@(negedge clk) BEGIN=1;
	//state 1
	@(negedge clk);
	BEGIN=0;
	cnt=2'b00;
	q[-1]=0;
	q[2:0]=3'b110;
	//state 6 (-M)
	@(negedge clk);
	//state 10 (shift)
	@(negedge clk) q=4'b1110;
	//state 11 (check)
	@(negedge clk) cnt=2'b01;
	//state 6 (-M)
	@(negedge clk);
	//state 10
	@(negedge clk) q=4'b0000;
	//state 11
	@(negedge clk) cnt=2'b10;
	//state 12
	@(negedge clk);
	//state 0
end

endmodule