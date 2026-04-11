module nrd8bits (
    input clk, rst_b, start,
    input [15:0] inbus,
    output [16:0] outbus,
    output done
);
    wire [7:0] dividend = inbus[15:8];
    wire [7:0] divisor  = inbus[7:0];
    wire [6:0] c;
    wire [3:0] cnt;
    wire [8:0] A_q, A_d;
    wire [7:0] Q_q, Q_d;
    wire [7:0] M_q;
    wire sign_A = A_q[8];
    nrd8bits_CU CU (
        .clk(clk),
        .rst_b(rst_b),
        .start(start),
        .sign_A(sign_A),
        .cnt(cnt),
        .done(done),
        .c(c)
    );
    counter #(.size(4)) CNT (
        .clk(clk),
        .rst_b(rst_b),
        .c_up(c[1]),
        .c_down(1'b0),
        .q(cnt)
    );
    register #(.size(8)) M_reg (
        .clk(clk),
        .rst_b(rst_b),
        .load(c[0]),
        .data(divisor),
        .q(M_q)
    );
    wire [8:0] A_shift = {A_q[7:0], Q_q[7]};
    wire [7:0] Q_shift = {Q_q[6:0], 1'b0};
    wire [8:0] M_ext = {1'b0, M_q};
    wire [8:0] add_out, sub_out;
    adder #(.size(9)) ADD (
        .cin(0),
        .x(A_q),
        .y(M_ext),
        .z(add_out)
    );
    adder #(.size(9)) SUB (
        .cin(1),
        .x(A_q),
        .y(~M_ext),
        .z(sub_out)
    );
    assign A_d =
        c[0] ? 9'b0 :
        c[1] ? A_shift :
        c[2] ? sub_out :
        c[3] ? add_out :
        c[6] ? add_out :
        A_q;
    wire [7:0] Q_set1 = Q_q | 8'b00000001;
    wire [7:0] Q_set0 = Q_q & 8'b11111110;
    assign Q_d =
        c[0] ? dividend :
        c[1] ? Q_shift :
        c[4] ? Q_set1 :
        c[5] ? Q_set0 :
        Q_q;
    register #(.size(9)) A_reg (
        .clk(clk),
        .rst_b(rst_b),
        .load(c[0] | c[1] | c[2] | c[3] | c[6]),
        .data(A_d),
        .q(A_q)
    );
    register #(.size(8)) Q_reg (
        .clk(clk),
        .rst_b(rst_b),
        .load(c[0] | c[1] | c[4] | c[5]),
        .data(Q_d),
        .q(Q_q)
    );
    assign outbus = {A_q, Q_q};
endmodule
