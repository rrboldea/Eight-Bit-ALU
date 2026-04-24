//the control unit handling the execution of the non-restoring division algorithm

module nrd8bits_CU (
    input clk, rst_b, start,
    input sign_A,
    input [3:0] cnt,
    output done,
    output [6:0] c
);

    /// state register (one-hot FSM)
    wire [7:0] state, next;

    /// check if 8 iterations are done
    wire cnt8 = (cnt == 4'd8);

    /// individual state bits
    wire s0 = state[0];  ///idle
    wire s1 = state[1];  ///init
    wire s2 = state[2];  ///shift (A,Q left shift)
    wire s3 = state[3];  ///add/sub (A = A ± M)
    wire s4 = state[4];  /// decision (set Q[0] based on sign_A)
    wire s5 = state[5];  /// correction during loop (if A < 0)
    wire s6 = state[6];  /// done (operation finished)
    wire s7 = state[7];  /// final check (after last iteration)

    /// next state logic

    assign next[0] = (s0 & ~start) | (s6 & ~start); /// idle state
    assign next[1] = s0 & start;                    /// start -> init
    assign next[2] = s1 | (s4 & ~cnt8 & ~sign_A) | (s5 & ~cnt8); /// go to shift
    assign next[3] = s2;                            /// after shift -> add/sub
    assign next[4] = s3;                            /// after add/sub -> decision
    assign next[5] = s4 & sign_A & ~cnt8;           /// if A < 0 -> correction path
    assign next[6] = s7;                            /// done state
    assign next[7] = (s4 & cnt8) | (s5 & cnt8);     /// last iteration reached

    /// control signals output
    
    assign c[0] = s1;                               /// init (load registers)
    assign c[1] = s2;                               /// shift operation
    assign c[2] = s3 & ~sign_A;                     /// A = A - M
    assign c[3] = s3 & sign_A;                      /// A = A + M
    assign c[4] = s4 & ~sign_A;                     /// Q[0] = 1
    assign c[5] = s4 & sign_A;                      /// Q[0] = 0
    assign c[6] = s5 | (s7 & sign_A);               /// final correction (if needed)
    
    /// done signal
    assign done = s6;

    /// state flip-flops

    /// state[0] has async reset to 0
    d_ff ff0 (
        .clk(clk),
        .rst_b(rst_b),
        .set_b(1'b0),
        .load(1'b1),
        .data(next[0]),
        .q(state[0]),
        .q_b()
    );

    /// rest of states
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
