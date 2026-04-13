module srtr4_8bits_tb;

reg clk,rst_b;
reg BEGIN;
reg [7:0] w,x,y;
wire READY,END;
wire [7:0] r,c;

srtr4_8bits test
(
	.clk(clk),
	.rst_b(rst_b),
	.BEGIN(BEGIN),
	.inbus({w,x,y}),
	.READY(READY),
	.END(END),
	.obus({r,c})
);

initial begin
	clk=0;
	rst_b=1;
	BEGIN=0;
	forever #50 clk=~clk;
end

initial begin
	repeat(2) #10 rst_b=~rst_b;
	{w,x}=3825;
	y=72;
	BEGIN=1;
	#100 BEGIN=0;
	repeat(20) @(posedge clk);
	#25 BEGIN=1;
	{w,x}=429;
	y=13;
	#100 BEGIN=0;
	repeat(20) @(posedge clk);
	/*#25 BEGIN=1;
	x=109;
	y=-67;
	#100 BEGIN=0;
	*/	
end

endmodule