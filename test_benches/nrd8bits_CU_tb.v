`timescale 1ns/1ps

module nrd8bits_CU_tb;

reg clk;
reg rst_b;
reg start;
reg sign_A;
reg [3:0] cnt;

wire done;
wire [5:0] c;

nrd8bits_CU uut (
    .clk(clk),
    .rst_b(rst_b),
    .start(start),
    .sign_A(sign_A),
    .cnt(cnt),
    .done(done),
    .c(c)
);

always #5 clk = ~clk;

always @(posedge clk or negedge rst_b)
begin
    if (!rst_b)
        cnt <= 0;
    else if (c[0])
        cnt <= cnt + 1;
end

always @(posedge clk or negedge rst_b)
begin
    if (!rst_b)
        sign_A <= 0;
    else if (c[1] || c[2])
        sign_A <= ~sign_A;
end

initial begin
    clk = 0;
    rst_b = 0;
    start = 0;
    cnt = 0;
    sign_A = 0;

    #20 rst_b = 1;

    @(posedge clk);
    start = 1;

    

    wait(done);

    #20;

    $display("SIMULATION DONE - NRD OK");
    
end

always @(posedge clk) begin
    $display("t=%0t cnt=%0d c=%b done=%b sign_A=%b",
        $time, cnt, c, done, sign_A);
end

endmodule