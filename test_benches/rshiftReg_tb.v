module rshiftReg_tb;

reg clk,rst_b,load,rshift;
reg [1:0] in;
reg [5:0] d;
wire [5:0] q;

rshiftReg #(.bits_shift(2),.size(6)) test
(
	.clk(clk),
	.rst_b(rst_b),
	.load(load),
	.rshift(rshift),
	.in(in),
	.d(d),
	.q(q)
);

initial begin
	{clk,rst_b,load,rshift,in}=6'b010000;
	d=6'b011001;
	forever #50 clk=~clk;
end

initial begin
	repeat(2) #10 rst_b=~rst_b;
	load=1;
	@(posedge clk) #10 load=0;
	rshift=1;
end

always 
begin
	@(posedge clk) in=in+1;
end

endmodule