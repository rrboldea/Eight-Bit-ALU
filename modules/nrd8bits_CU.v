module nrd8bits_CU (
    input clk, rst_b, start,
    input sign_A,
    input [3:0] cnt,
    output done,
    output [6:0] c
);
    wire [7:0] state, next;
    wire cnt8 = (cnt == 4'd8);
    wire s0 = state[0];
    wire s1 = state[1];
    wire s2 = state[2];
    wire s3 = state[3];
    wire s4 = state[4];
    wire s5 = state[5];
    wire s6 = state[6];
    wire s7 = state[7];
    assign next[0] = (s0 & ~start) | (s6 & ~start);
    assign next[1] = s0 & start;
    assign next[2] = s1 | (s4 & ~cnt8 & ~sign_A) | (s5 & ~cnt8);
    assign next[3] = s2;
    assign next[4] = s3;
    assign next[5] = s4 & sign_A & ~cnt8;
    assign next[6] = s7;
    assign next[7] = (s4 & cnt8) | (s5 & cnt8);
    assign c[0] = s1;
    assign c[1] = s2;
    assign c[2] = s3 & ~sign_A;
    assign c[3] = s3 & sign_A;
    assign c[4] = s4 & ~sign_A;
    assign c[5] = s4 & sign_A;
    assign c[6] = s5 | (s7 & sign_A);
    assign done = s6;
    d_ff ff0 (
        .clk(clk),
        .rst_b(rst_b),
        .set_b(1'b0),
        .load(1'b1),
        .data(next[0]),
        .q(state[0]),
        .q_b()
    );
    genvar i;
    generate
        for(i=1;i<=7;i=i+1) begin: FF
            d_ff ff (
                .clk(clk),
                .rst_b(rst_b),
                .set_b(1'b1),
                .load(1'b1),
                .data(next[i]),
                .q(state[i]),
                .q_b()
            );
        end
    endgenerate
endmodule