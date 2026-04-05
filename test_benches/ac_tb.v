module ac_tb;

reg x,y,cin;
wire z,g,p;

ac test
(
	.x(x),
	.y(y),
	.cin(cin),
	.z(z),
	.g(g),
	.p(p)
);

initial begin
	{x,y,cin}=3'b000;
end

always 
begin
	#50 {x,y,cin}={x,y,cin}+1;
end

endmodule