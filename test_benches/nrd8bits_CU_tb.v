`timescale 1ns/1ps

module nrd8bits_CU_tb;

    
    reg clk;
    reg rst_b;
    reg start;
    reg sign_A;

    
    wire shift_AQ;
    wire sub_M;
    wire add_M;
    wire set_Q0_1;
    wire set_Q0_0;
    wire restore;
    wire done;

    
    nrd8bits_CU uut (
        .clk(clk),
        .rst_b(rst_b),
        .start(start),
        .sign_A(sign_A),
        .shift_AQ(shift_AQ),
        .sub_M(sub_M),
        .add_M(add_M),
        .set_Q0_1(set_Q0_1),
        .set_Q0_0(set_Q0_0),
        .restore(restore),
        .done(done)
    );

    
    always #5 clk = ~clk;

    initial begin
        
        clk = 0;
        rst_b = 1;
        start = 0;
        sign_A = 0;

        
        #10;
        rst_b = 0;

        
        #10;
        start = 1;

        #10;
        start = 0;

        
        repeat (20) begin
            #10 sign_A = $random % 2;
        end

        
        #200;

        
        start = 1;
        #10 start = 0;

        repeat (20) begin
            #10 sign_A = $random % 2;
        end

        #200;

        
    end
endmodule