module ALU_tb;

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



endmodule