module nrd8bits(
    input clk, rst_b,
    input shift_AQ,
    input sub_M,
    input add_M,
    input set_Q0_1,
    input set_Q0_0,
    input restore,
    input load,
    input [7:0] dividend,
    input [7:0] divisor,
    output sign_A,
    output [7:0] Q_out,
    output [8:0] A_out
);

wire [8:0] A_q;
wire [8:0] A_d;
wire [7:0] Q_q;
wire [7:0] Q_d;
wire [7:0] M_q;
assign sign_A = A_q[8];

register #(.size(8)) M_reg (
    .clk(clk),
    .rst_b(rst_b),
    .load(load),
    .data(divisor),
    .q(M_q)
);


wire [8:0] A_shift;
wire [7:0] Q_shift;

assign A_shift = {A_q[7:0], Q_q[7]};

assign Q_shift = {Q_q[6:0], 1'b0};

wire [8:0] M_ext = {1'b0, M_q};

wire [8:0] add_out;
wire [8:0] sub_out;

adder #(.size(9)) add_unit (
    .cin(1'b0),
    .x(A_q),
    .y(M_ext),
    .cout(),
    .z(add_out)
);

adder #(.size(9)) sub_unit (
    .cin(1'b1),
    .x(A_q),
    .y(~M_ext),
    .cout(),
    .z(sub_out)
);

reg [8:0] A_next;

always @(*) begin
    A_next = A_q;

    if (shift_AQ)
        A_next = A_shift;
    else if (add_M)
        A_next = add_out;
    else if (sub_M)
        A_next = sub_out;
    else if (restore)
        A_next = add_out;
end

reg [7:0] Q_next;

always @(*) begin
    Q_next = Q_q;

    if (shift_AQ)
        Q_next = Q_shift;

    if (set_Q0_1)
        Q_next[0] = 1'b1;
    else if (set_Q0_0)
        Q_next[0] = 1'b0;
end

register #(.size(9)) A_reg (
    .clk(clk),
    .rst_b(rst_b),
    .load(load | shift_AQ | add_M | sub_M | restore),
    .data(A_next),
    .q(A_q)
);

register #(.size(8)) Q_reg (
    .clk(clk),
    .rst_b(rst_b),
    .load(load | shift_AQ | set_Q0_1 | set_Q0_0),
    .data(Q_next),
    .q(Q_q)
);

always @(*) begin
    if (load) begin
        
        A_next = 9'b0;
        Q_next = dividend;
    end
end

assign Q_out = Q_q;
assign A_out = A_q;

endmodule