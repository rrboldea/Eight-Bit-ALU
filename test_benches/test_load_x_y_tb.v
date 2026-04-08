module test_load_x_y_tb;

reg clk,rst_b,ld_x_y;
reg [7:0] data;
wire [7:0] x,y;

test_load_x_y test
(
	.clk(clk),
	.rst_b(rst_b),
	.ld_x_y(ld_x_y),
	.data(data),
	.x(x),
	.y(y)
);

initial begin
	clk=0;
	rst_b=1;
	ld_x_y=0;
	data=8'b00000000;
	forever #50 clk=~clk;
end

initial begin
	repeat(2) #10 rst_b=~rst_b;
	@(negedge clk) ld_x_y=1;
	data=24;
	@(negedge clk) ld_x_y=0;
	@(negedge clk) ld_x_y=1;
	data=57;
	@(negedge clk) ld_x_y=0;
	@(negedge clk) ld_x_y=1;
	data=99;
	@(negedge clk) ld_x_y=0;
	@(negedge clk) ld_x_y=1;
	data=71;
	@(negedge clk) ld_x_y=0;
end

endmodule






