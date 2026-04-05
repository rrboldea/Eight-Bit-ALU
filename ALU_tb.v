module ALU_tb;

reg clk,rst_b;
reg ADD,SUB,MULT;
reg [7:0] x,y;
wire [15:0] q;
wire DONE;

ALU test
(
	.clk(clk),
	.rst_b(rst_b),
	.ADD(ADD),
	.SUB(SUB),
	.MULT(MULT),
	.x(x),
	.y(y),
	.DONE(DONE),
	.q(q)
);

initial begin
	clk=0;
	rst_b=1;
	{ADD,SUB,MULT}=0;
	forever #50 clk=~clk;
end

initial begin
	repeat(2) #10 rst_b=~rst_b;
	@(negedge clk); x=77; y=-102; ADD=1;
	@(negedge clk) ADD=0;
	@(negedge clk); x=99; y=102; ADD=1;
	@(negedge clk) ADD=0;

	@(negedge clk); x=77; y=-102; SUB=1;
	@(negedge clk) SUB=0;
	@(negedge clk); x=99; y=102; SUB=1;
	@(negedge clk) SUB=0;

	@(negedge clk); x=77; y=-102; MULT=1;
	@(negedge clk) MULT=0;
	repeat(15) @(negedge clk);
	@(negedge clk); x=99; y=102; MULT=1;
	@(negedge clk) MULT=0;
end

endmodule











