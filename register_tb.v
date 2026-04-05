module register_tb;

reg clk,rst_b,load;
reg [3:0] data;
wire [3:0] q;

register #(.size(4))test
(
	.clk(clk),
	.rst_b(rst_b),
	.load(load),
	.data(data),
	.q(q)
);

initial begin
	{clk,rst_b,load}=3'b010;
	data=4'b0101;
	forever #50 clk=~clk;
end

initial begin
	repeat(2) #10 rst_b=~rst_b;
	load=1;
	@(posedge clk) data=4'b1011;
	load=0;
	@(posedge clk) data=4'b0001;
	load=1;
	repeat(2) @(posedge clk) data=data+2;
end

endmodule