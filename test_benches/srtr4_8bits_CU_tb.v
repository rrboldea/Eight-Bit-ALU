module srtr4_8bits_CU_tb;

reg clk,rst_b,BEGIN;
reg [1:0] cnt;
reg [2:0] k;
reg [3:0] b;
reg [5:0] p;

wire [13:0] c;
wire [16:0] state;
wire END;

srtr4_8bits_CU test
(
	.clk(clk),
	.rst_b(rst_b),
	.BEGIN(BEGIN),
	.cnt(cnt),
	.k(k),
	.b(b),
	.p(p),
	.c(c),
	.state(state),
	.END(END)
);

initial begin
	clk=0;
	rst_b=1;
	BEGIN=0;
	cnt=2'b00;
	k=3'b000;
	b=4'b0000;
	p=6'b000000;
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
	k=3'b000;
	b[3]=0;
	//state 2
	@(negedge clk);
	b[3]=0;
	k=k+1;
	//state 2
	@(negedge clk);
	b[3]=0;
	k=k+1;
	//state 2
	@(negedge clk);
	b[3]=0;
	k=k+1;
	//state 2
	@(negedge clk);
	b=4'b1101;
	k=k+1;
	p=6'b000011;
	//state 11
	@(negedge clk);
	p=6'b001101;
	//state 12
	@(negedge clk) cnt=cnt+1;
	//state 9
	@(negedge clk);
	//state 10
	@(negedge clk);
	p=6'b000001;
	//state 12
	@(negedge clk) cnt=cnt+1;
	//state 11
	@(negedge clk);
	p=6'b000110;
	//state 12
	@(negedge clk) cnt=cnt+1;
	//state 7
	@(negedge clk);
	//state 8
	@(negedge clk);
	p=6'b000000;
	//state 14
	@(negedge clk) k=k-1;
	//state 14
	@(negedge clk) k=k-1;
	//state 14
	@(negedge clk) k=k-1;
	//state 14
	@(negedge clk) k=k-1;
	//state 15
	@(negedge clk);
	//state 16
	@(negedge clk);
	//state 0
end

endmodule




