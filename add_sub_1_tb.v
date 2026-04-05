module add_sub_1_tb;

reg add_sub;
reg [4:0] x;
wire cout;
wire [4:0] z;

add_sub_1 #(.size(5)) test
(
	.add_sub(add_sub),
	.x(x),
	.cout(cout),
	.z(z)
);

initial begin
	add_sub=1'b1;
	x=5'b00000;
end

always 
begin
	repeat(10) #50 x=x+1;
	add_sub=~add_sub;
end

endmodule