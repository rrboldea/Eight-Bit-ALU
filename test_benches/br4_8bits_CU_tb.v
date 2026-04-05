module br4_8bits_CU_tb;

reg clk,rst_b,BEGIN;
reg [1:-1] q;
reg [1:0] cnt;
//wire [10:0] state;
wire [7:0] c;
wire END;

br4_8bits_CU test
(
	.clk(clk),
	.rst_b(rst_b),
	.BEGIN(BEGIN),
	.q(q),
	.cnt(cnt),
	//.state(state),
	.c(c),
	.END(END)
);

initial begin
	clk=0;
	rst_b=1;
	BEGIN=0;
	q=3'b0;
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
	//state 2
	@(negedge clk) q[1:0]=2'b11;
	//state 5
	@(negedge clk);
	//state 7
	@(negedge clk) q=3'b011;
	//state 8
	@(negedge clk) cnt=cnt+1;
	//state 4
	@(negedge clk);
	//state 7
	@(negedge clk) q=3'b100;
	//state 8
	@(negedge clk) cnt=cnt+1;
	//state 6
	@(negedge clk);
	//state 7
	@(negedge clk) q=3'b111;
	//state 8
	@(negedge clk) cnt=cnt+1;
	//state 7
	@(negedge clk) q=3'b111;
	//state 9
	@(negedge clk);
	//state 10
	@(negedge clk);
	//state 0
end

endmodule





