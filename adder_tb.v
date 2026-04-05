module adder_tb;

reg cin;
reg [1:0] x,y;

wire cout;
wire [1:0] z;

adder #(.size(2)) test
(
	.x(x),
	.y(y),
	.cin(cin),
	.z(z),
	.cout(cout)
);

initial begin
	{x,y,cin}=5'b00000;
	#50 {x,y,cin}=5'b01110;
	#50 {x,y,cin}=5'b00001;
	#50 {x,y,cin}=5'b10111;
	#50 {x,y,cin}=5'b11001;
end

endmodule