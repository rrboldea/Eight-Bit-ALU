///division cell based on non-restoring division algorithm

module nrd8bits (
    input clk, rst_b, start,
    input [15:0] inbus,
    output [16:0] outbus,
    output done
);
    /// split input bus into dividend and divisor
    wire [7:0] dividend = inbus[15:8];
    wire [7:0] divisor  = inbus[7:0];

    /// control signals from CU
    wire [6:0] c;
    
    /// iteration counter
    wire [3:0] cnt;
    
    /// A register (partial remainder)
    wire [8:0] A_q, A_d;
    
    /// Q register (quotient)
    wire [7:0] Q_q, Q_d;

    /// M register (divisor)
    wire [7:0] M_q;

    /// sign of A (used by CU)
    wire sign_A = A_q[8];

    /// control unit for non-restoring division
    nrd8bits_CU CU (
        .clk(clk),
        .rst_b(rst_b),
        .start(start),
        .sign_A(sign_A),
        .cnt(cnt),
        .done(done),
        .c(c)
    );

    /// counter for division steps
    counter #(.size(4)) CNT (
        .clk(clk),
        .rst_b(rst_b),
        .c_up(c[1]),
        .c_down(1'b0),
        .q(cnt)
    );

    /// M register stores divisor
    register #(.size(8)) M_reg (
        .clk(clk),
        .rst_b(rst_b),
        .load(c[0]),
        .data(divisor),
        .q(M_q)
    );
    
    /// shift left A (brings MSB of Q)
    wire [8:0] A_shift = {A_q[7:0], Q_q[7]};
    
    /// shift left Q
    wire [7:0] Q_shift = {Q_q[6:0], 1'b0};
    
    /// extend M to 9 bits
    wire [8:0] M_ext = {1'b0, M_q};
    
    /// adder outputs
    wire [8:0] add_out, sub_out;

    /// A + M
    adder #(.size(9)) ADD (
        .cin(0),
        .x(A_q),
        .y(M_ext),
        .z(add_out)
    );

    /// A - M
    adder #(.size(9)) SUB (
        .cin(1),
        .x(A_q),
        .y(~M_ext),
        .z(sub_out)
    );

    /// A next-state logic
    assign A_d =
        c[0] ? 9'b0 :     /// init A = 0
        c[1] ? A_shift :  /// shift
        c[2] ? sub_out :  /// subtract M
        c[3] ? add_out :  /// add M
        c[6] ? add_out :  /// final correction
        A_q;

    /// set Q LSB = 1
    wire [7:0] Q_set1 = Q_q | 8'b00000001;

    /// set Q LSB = 0
    wire [7:0] Q_set0 = Q_q & 8'b11111110;

    /// Q next-state logic
    assign Q_d =
        c[0] ? dividend :   /// init Q
        c[1] ? Q_shift :    /// shift
        c[4] ? Q_set1 :     /// write 1
        c[5] ? Q_set0 :     /// write 0
        Q_q;

    /// A register
    register #(.size(9)) A_reg (
        .clk(clk),
        .rst_b(rst_b),
        .load(c[0] | c[1] | c[2] | c[3] | c[6]),
        .data(A_d),
        .q(A_q)
    );

    /// Q register
    register #(.size(8)) Q_reg (
        .clk(clk),
        .rst_b(rst_b),
        .load(c[0] | c[1] | c[4] | c[5]),
        .data(Q_d),
        .q(Q_q)
    );

    /// output = {remainder, quotient}
    assign outbus = {A_q, Q_q};
endmodule
