module srtr4_reg_tb;

reg clk,rst_b;
reg load,c_down,rshift,lshift1,lshift2;
reg left_in;
reg [1:0] right_in;
reg [7:0] d;
wire [7:0] q;

srtr4_reg #(.size(8)) test
(
	.clk(clk),
	.rst_b(rst_b),
	.load(load),
	.c_down(c_down),
	.rshift(rshift),
	.lshift1(lshift1),
	.lshift2(lshift2),
	.left_in(left_in),
	.right_in(right_in),
	.d(d),
	.q(q)
);

initial begin
	{clk,rst_b,load,c_down,rshift,lshift1,lshift2}=7'b0100000;
	{left_in,right_in}=3'b000;
	d=6'b011001;
	forever #50 clk=~clk;
end

initial begin
	repeat(2) #10 rst_b=~rst_b;
	load=1;
	right_in=2'b10;
	@(posedge clk) #10 load=0;
	lshift1=1;
	repeat(2) @(posedge clk);
	lshift1=0;
	@(posedge clk);
	lshift2=1;
	right_in=2'b00;
	repeat(3) @(posedge clk);
	lshift2=0;
	@(posedge clk);
	rshift=1;
	repeat(2) @(posedge clk);
	rshift=0;
	@(posedge clk);
	c_down=1;
	@(posedge clk);
	c_down=0;
	@(posedge clk);
	rshift=1;
	
	
end

endmodule