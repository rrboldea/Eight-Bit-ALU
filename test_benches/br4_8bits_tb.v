module br4_8bits_tb;

reg clk,rst_b;
reg BEGIN;
reg [7:0] x,y;
wire [15:0] obus;
wire READY,END;

br4_8bits test
(
	.clk(clk),
	.rst_b(rst_b),
	.BEGIN(BEGIN),
	.inbus({x,y}),
	.obus(obus),
	.READY(READY),
	.END(END)
);

initial begin
	clk=0;
	rst_b=1;
	BEGIN=0;
	forever #50 clk=~clk;
end

initial begin
	repeat(2) #10 rst_b=~rst_b;
	x=-25;
	y=113;
	BEGIN=1;
	#100 BEGIN=0;
	repeat(20) @(posedge clk);
	#25 BEGIN=1;
	x=44;
	y=62;
	#100 BEGIN=0;
	repeat(20) @(posedge clk);
	#25 BEGIN=1;
	x=109;
	y=-67;
	#100 BEGIN=0;
end

endmodule





