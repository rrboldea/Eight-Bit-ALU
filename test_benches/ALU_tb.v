module ALU_tb;

reg clk,rst_b;
reg ADD,SUB,MULT,DIV;
reg [7:0] w,x,y;
wire [15:0] q;
wire DONE;

   //SRTR4 division test bench
   
ALU test
(
	.clk(clk),
	.rst_b(rst_b),
	.ADD(ADD),
	.SUB(SUB),
	.MULT(MULT),
	.DIV(DIV),
	.w(w),
	.x(x),
	.y(y),
	.DONE(DONE),
	.q(q)
);

initial begin
	clk=0;
	rst_b=1;
	{ADD,SUB,MULT,DIV}=0;
	w=8'b00000000;
	forever #50 clk=~clk;
end

initial begin
        repeat(2) #10 rst_b=~rst_b;
	@(negedge clk); x=77; y=-102; ADD=1;
	@(negedge clk) ADD=0;
	@(negedge clk); x=99; y=102; ADD=1;
	@(negedge clk) ADD=0;

	@(negedge clk); x=77; y=-102; SUB=1;
	@(negedge clk) SUB=0;
	@(negedge clk); x=99; y=102; SUB=1;
	@(negedge clk) SUB=0;
   
	@(negedge clk); x=77; y=-102; MULT=1;
	@(negedge clk) MULT=0;
	repeat(15) @(negedge clk);
	@(negedge clk); x=99; y=102; MULT=1;
	@(negedge clk) MULT=0;
	repeat(15) @(negedge clk);

	@(negedge clk); {w,x}=4672; y=93; DIV=1;
	@(negedge clk) DIV=0;
	repeat(25) @(negedge clk);
	@(negedge clk); {w,x}=-2113; y=100; DIV=1;
	@(negedge clk) DIV=0;
end

   //Nrd division test bench
/*
  reg clk, rst_b;
  reg ADD, SUB, MULT, DIV;
  reg [7:0] x, y;
  wire [15:0] q;
  wire DONE;

ALU test(

  .clk(clk),
  .rst_b(rst_b),
  .ADD(ADD),
  .SUB(SUB),
  .MULT(MULT),
  .DIV(DIV),
  .x(x),
  .y(y),
  .DONE(DONE),
  .q(q)
);

initial begin

clk = 0;

forever #50 clk = ~clk;

end

initial begin

rst_b = 0;

{ADD, SUB, MULT, DIV} = 0;

x = 0; y = 0;

#100 rst_b = 1;
end

initial begin
  
@(posedge rst_b);

@(negedge clk);

x = 77; y = 10; ADD = 1; @(negedge clk) ADD = 0;
x = 120; y = 10; ADD = 1; @(negedge clk) ADD = 0;
x = 50; y = 20; SUB = 1; @(negedge clk) SUB = 0;
x = 20; y = 50; SUB = 1; @(negedge clk) SUB = 0;
x = 12; y = -5; MULT = 1; @(negedge clk) MULT = 0;
#500
wait(DONE); 
x=73; y = 21; MULT = 1; @(negedge clk) MULT = 0;
#500
wait(DONE);
x = 255; y = 10; DIV = 1; @(negedge clk) DIV = 0;
#500
wait(DONE);
end
*/



endmodule
