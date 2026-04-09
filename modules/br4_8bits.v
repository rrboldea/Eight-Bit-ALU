
//multiplier cell based on booth radix 4 algorithm

module br4_8bits 
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
wire [6:0] c;

//wires needed for A register
wire rst_b_init=rst_b & (~c[0]);
wire [8:0] d_A_reg; 
wire [8:0] q_A_reg;

//wires needed for Q register
wire [7:0] d_Q_reg; 
wire [7:-1] q_Q_reg;

assign d_Q_reg=inbus[15:8];

//wires needed for M register
wire [7:0] d_M_reg; 
wire [7:0] q_M_reg;

assign d_M_reg=inbus[7:0];

//wires needed for CNT register 
wire [1:0] q_CNT_reg;

//wires needed for ADD adder
wire [8:0] y;

//wires needed for MUX multiplexor 
wire [8:0] q_MUX;

rshiftReg #(.bits_shift(2),.size(9)) A_reg
(
	.clk(clk),
	.rst_b(rst_b_init),
	.load(c[1]),
	.rshift(c[4]),
	.in({q_A_reg[8],q_A_reg[8]}),
	.d(d_A_reg),
	.q(q_A_reg)
);

rshiftReg #(.bits_shift(2),.size(8)) Q_reg
(
	.clk(clk),
	.rst_b(rst_b),
	.load(c[0]),
	.rshift(c[4]),
	.in({q_A_reg[1:0]}),
	.d(d_Q_reg),
	.q({q_Q_reg[7:0]})
);

register #(.size(1)) Q_1_reg
(
	.clk(clk),
	.rst_b(rst_b_init),
	.load(c[4]),
	.data(q_Q_reg[1]),
	.q(q_Q_reg[-1])
);

register #(.size(8)) M_reg
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
	.c_up(c[5]),
	.c_down(1'b0),
	.q(q_CNT_reg)
);

mux_1sel #(.size(9)) MUX
(
	.sel(c[3]),
	.value0({q_M_reg[7],q_M_reg[7:0]}),
	.value1({q_M_reg[7:0],1'b0}),
	.q(q_MUX)
);

genvar i;
generate
	for(i=0;i<9;i=i+1) begin: loop
		assign y[i]=q_MUX[i] ^ c[2];
	end
endgenerate

adder #(.size(9)) ADD
(
	.cin(c[2]),
	.x(q_A_reg),
	.y(y),
	.cout(),
	.z(d_A_reg)
);

br4_8bits_CU CU
(
	.clk(clk_b),
	.rst_b(rst_b),
	.BEGIN(BEGIN),
	.q(q_Q_reg[1:-1]),
	.cnt(q_CNT_reg),
	.END(END),
	.c(c)
);

assign READY=c[6];

mux_1sel #(.size(16)) MUX_obus
(
	.sel(READY),
	.value0(16'b0000000000000000),
	.value1({q_A_reg[7:0],q_Q_reg[7:0]}),
	.q(obus)
);

endmodule










