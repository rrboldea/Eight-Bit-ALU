module br8_8bits_tb;

reg clk,rst_b;
reg BEGIN;
reg [7:0] x,y;
wire [15:0] obus;
wire READY,END;

br8_8bits test
(
	.clk(clk),
	.rst_b(rst_b),
	.BEGIN(BEGIN),
	.inbus({x,y}),
	.obus(obus),
	.READY(READY),
	.END(END)
);

initial begin
	$monitor($time, " x=%d y=%d obus=%d obus(hex)=%h READY=%b END=%b q_A=%h q_Q=%h cnt=%d q_{-1}=%b", $signed(x), $signed(y), $signed(obus), obus, READY, END, test.q_A_reg, test.q_Q_reg, test.q_CNT_reg, test.q_Q_reg_minus_1);
	clk=0;
	rst_b=1;
	BEGIN=0;
	forever #50 clk=~clk;
end

initial begin
	repeat(2) #10 rst_b=~rst_b;
	x=-25;
	y=113;
	BEGIN=1;
	#100 BEGIN=0;
	repeat(20) @(posedge clk);
	#25 BEGIN=1;
	x=44;
	y=62;
	#100 BEGIN=0;
	repeat(20) @(posedge clk);
	#25 BEGIN=1;
	x=109;
	y=-67;
	#100 BEGIN=0;
end

endmodule