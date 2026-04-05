module RCA_adder_tb;

reg cin;
reg [3:0] x,y;

wire cout;
wire [3:0] z;

RCA_adder #(.size(4)) test
(
	.x(x),
	.y(y),
	.cin(cin),
	.z(z),
	.cout(cout)
);

initial begin
	{x,y,cin}=9'b000000000;
	#50 {x,y,cin}=9'b100100110;
	#50 {x,y,cin}=9'b110001001;
	#50 {x,y,cin}=9'b011001111;
	#50 {x,y,cin}=9'b111100001;
end

endmodule