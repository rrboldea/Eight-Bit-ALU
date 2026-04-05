module counter_tb;

reg clk,rst_b,c_up,c_down;
wire [2:0] q;

counter #(.size(3)) test
(
	.clk(clk),
	.rst_b(rst_b),
	.c_up(c_up),
	.c_down(c_down),
	.q(q)
);

initial begin
	{clk,rst_b,c_up,c_down}=4'b0100;
	forever #50 clk=~clk;
end

initial begin
	repeat(2) #10 rst_b=~rst_b;
	repeat(3) @(posedge clk);
	#10 c_up=1;
	repeat(7) @(posedge clk);
	#10 c_up=1;
	c_down=1;
	repeat(3) @(posedge clk);
	#10 c_up=0;
	repeat(7) @(posedge clk);
	#10 c_down=0;
	repeat(3) @(posedge clk);
	repeat(2) #10 rst_b=~rst_b;
end

endmodule