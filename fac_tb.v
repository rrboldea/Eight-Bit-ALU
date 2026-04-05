module fac_tb;

reg x,y,cin;
wire z,cout;

fac test
(
	.x(x),
	.y(y),
	.cin(cin),
	.z(z),
	.cout(cout)
);

initial begin
	{x,y,cin}=3'b000;
end

always 
begin
	#50 {x,y,cin}={x,y,cin}+1;
end

endmodule