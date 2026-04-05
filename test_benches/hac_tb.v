module hac_tb;

reg x,y;
wire z,cout;

hac test
(
	.x(x),
	.y(y),
	.cout(cout),
	.z(z)
);

initial begin
	{x,y}=2'b00;
end

always begin
	#50 {x,y}={x,y}+1;
end

endmodule