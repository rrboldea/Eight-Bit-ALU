`timescale 1ns/1ps

module nrd8bits_tb;

reg clk;
reg rst_b;


reg shift_AQ;
reg sub_M;
reg add_M;
reg set_Q0_1;
reg set_Q0_0;
reg restore;
reg load;


reg [7:0] dividend;
reg [7:0] divisor;


wire sign_A;
wire [7:0] Q_out;
wire [8:0] A_out;


nrd8bits uut (
    .clk(clk),
    .rst_b(rst_b),
    .shift_AQ(shift_AQ),
    .sub_M(sub_M),
    .add_M(add_M),
    .set_Q0_1(set_Q0_1),
    .set_Q0_0(set_Q0_0),
    .restore(restore),
    .load(load),
    .dividend(dividend),
    .divisor(divisor),
    .sign_A(sign_A),
    .Q_out(Q_out),
    .A_out(A_out)
);


always #5 clk = ~clk;


initial begin
    clk = 0;
    rst_b = 0;

    shift_AQ = 0;
    sub_M = 0;
    add_M = 0;
    set_Q0_1 = 0;
    set_Q0_0 = 0;
    restore = 0;
    load = 0;

    dividend = 109;
    divisor  = 12;

    #20 rst_b = 1;

    
    @(negedge clk);
    load = 1;
    @(negedge clk);
    load = 0;

    
    repeat (8) begin

        
        @(negedge clk);
        shift_AQ = 1;
        @(negedge clk);
        shift_AQ = 0;

        
        @(negedge clk);
        if (sign_A == 0)
            sub_M = 1;
        else
            add_M = 1;

        @(negedge clk);
        sub_M = 0;
        add_M = 0;

        
        @(negedge clk);
        if (sign_A == 0)
            set_Q0_1 = 1;
        else
            set_Q0_0 = 1;

        @(negedge clk);
        set_Q0_1 = 0;
        set_Q0_0 = 0;

    end

    
    @(negedge clk);
    if (sign_A == 1)
        restore = 1;

    @(negedge clk);
    restore = 0;

    
    #10;
    #20;
end

endmodule