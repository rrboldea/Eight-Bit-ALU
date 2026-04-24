//multiplier cell based on booth radix 8 algorithm

module br8_8bits 
(
	input clk,rst_b,
	input BEGIN,
	input [15:0] inbus,
	output READY,END,
	output [15:0] obus
);

//Control unit needs to run on negedge of clk
wire clk_b;
assign clk_b=~clk;

//Control signals
wire [8:0] c;

//wires needed for A register
wire rst_b_init=rst_b & (~c[0]);
wire [10:0] d_A_reg; 
wire [10:0] q_A_reg;

//wires needed for Q register
wire [8:0] d_Q_reg; 
wire [8:0] q_Q_reg;
wire q_Q_reg_minus_1;

assign d_Q_reg={inbus[15], inbus[15:8]};

//wires needed for M register
wire [10:0] d_M_reg; 
wire [10:0] q_M_reg;

assign d_M_reg={{3{inbus[7]}}, inbus[7:0]};

//wires needed for CNT register 
wire [1:0] q_CNT_reg;

//wires needed for ADD adder
wire [10:0] y;

//wires needed for MUX multiplexor cascade
wire [10:0] q_MUX1;
wire [10:0] q_MUX2;
wire [10:0] q_MUX;

rshiftReg #(.bits_shift(3),.size(11)) A_reg
(
	.clk(clk),
	.rst_b(rst_b_init),
	.load(c[1]),
	.rshift(c[6]),
	.in({q_A_reg[10],q_A_reg[10],q_A_reg[10]}),
	.d(d_A_reg),
	.q(q_A_reg)
);

rshiftReg #(.bits_shift(3),.size(9)) Q_reg
(
	.clk(clk),
	.rst_b(rst_b),
	.load(c[0]),
	.rshift(c[6]),
	.in(q_A_reg[2:0]),
	.d(d_Q_reg),
	.q(q_Q_reg)
);

register #(.size(1)) Q_1_reg
(
	.clk(clk),
	.rst_b(rst_b_init),
	.load(c[6]),
	.data(q_Q_reg[2]),
	.q(q_Q_reg_minus_1)
);

register #(.size(11)) M_reg
(
	.clk(clk),
	.rst_b(rst_b),
	.load(c[0]),
	.data(d_M_reg),
	.q(q_M_reg)
);

counter #(.size(2)) CNT
(
	.clk(clk),
	.rst_b(rst_b_init),
	.c_up(c[7]),
	.c_down(1'b0),
	.q(q_CNT_reg)
);

// Combinatorial evaluation of M multiples
wire [10:0] val_1M = q_M_reg;
wire [10:0] val_2M = {q_M_reg[9:0], 1'b0};
wire [10:0] val_3M;
wire [10:0] val_4M = {q_M_reg[8:0], 2'b00};

adder #(.size(11)) ADD_3M
(
	.cin(1'b0),
	.x(val_1M),
	.y(val_2M),
	.cout(),
	.z(val_3M)
);

// MUX 1: selects 3M or 4M
mux_1sel #(.size(11)) MUX1
(
	.sel(c[4]),
	.value0(val_3M),
	.value1(val_4M),
	.q(q_MUX1)
);

// MUX 2: selects M or 2M
mux_1sel #(.size(11)) MUX2
(
	.sel(c[3]),
	.value0(val_1M),
	.value1(val_2M),
	.q(q_MUX2)
);

// MUX 3: selects between MUX2 or MUX1
mux_1sel #(.size(11)) MUX3
(
	.sel(c[5]),
	.value0(q_MUX2),
	.value1(q_MUX1),
	.q(q_MUX)
);

genvar i;
generate
	for(i=0;i<11;i=i+1) begin: loop
		assign y[i]=q_MUX[i] ^ c[2];
	end
endgenerate

adder #(.size(11)) ADD
(
	.cin(c[2]),
	.x(q_A_reg),
	.y(y),
	.cout(),
	.z(d_A_reg)
);

br8_8bits_CU CU
(
	.clk(clk_b),
	.rst_b(rst_b),
	.BEGIN(BEGIN),
	.q({q_Q_reg[2:0], q_Q_reg_minus_1}),
	.cnt(q_CNT_reg),
	.END(END),
	.c(c)
);

assign READY=c[8];

mux_1sel #(.size(16)) MUX_obus
(
	.sel(READY),
	.value0(16'b0000000000000000),
	.value1({q_A_reg[6:0],q_Q_reg[8:0]}),
	.q(obus)
);

endmodule