`timescale 1ns/1ps

module nrd8bits_tb;

    reg clk;
    reg rst_b;
    reg start;
    reg [15:0] inbus;

    wire [16:0] outbus;
    wire done;

    
    nrd8bits uut (
        .clk(clk),
        .rst_b(rst_b),
        .start(start),
        .inbus(inbus),
        .outbus(outbus),
        .done(done)
    );

    
    always #5 clk = ~clk;

    
    wire [8:0] A_out = outbus[16:8];
    wire [7:0] Q_out = outbus[7:0];

    
    initial begin
        clk = 0;
        rst_b = 0;
        start = 0;

        
        inbus = {8'd10, 8'd2};

        
        #20;
        rst_b = 1;

        
        @(posedge clk);
        start = 1;

        @(posedge clk);
        start = 0;

        
        wait(done);

        
        @(posedge clk);

        $display("\n=== FINAL RESULT ===");
        $display("A_out (remainder) = %d", A_out);
        $display("Q_out (quotient)  = %d", Q_out);
        $display("done              = %b", done);

        
    end

    
    always @(posedge clk) begin
        $display("t=%0t | A=%0d | Q=%0d | done=%b",
                 $time, A_out, Q_out, done);
    end

endmodule