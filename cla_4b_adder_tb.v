module cla_4b_adder_tb;

reg cin;
reg [3:0] x,y;
wire cout;
wire [3:0] z;

cla_4b_adder test
(
	.cin(cin),
	.x(x),
	.y(y),
	.cout(cout),
	.z(z)
);

initial begin
	{cin,x,y}=9'b011000100;
        #50 {cin,x,y}=9'b101101100;
        #50 {cin,x,y}=9'b111101001;
        #50 {cin,x,y}=9'b000111110;
        #50 {cin,x,y}=9'b001100011;
end

endmodule