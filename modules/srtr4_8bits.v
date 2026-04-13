
//division cell based on Sweeney, Robertson, and Tocher radix 4 algorithm

module srtr4_8bits
(
	input clk,rst_b,
	input BEGIN,
	input [23:0] inbus,
	output READY,END,
	output [15:0] obus 
);

//Control unit needs to run on negedge of clk
wire clk_b;
assign clk_b=~clk;

//Control signals
wire [13:0] c;

wire rst_b_init=rst_b & (~c[0]);

//Wires needed for A register
wire [8:0] d_A_reg; 
wire [8:0] q_A_reg;

//Wires needed for Q register
wire [7:0] d_Q_reg; 
wire [7:0] q_Q_reg;
wire [1:0] Q_right_in;

//Wires needed for Qp register
wire [7:0] q_Qp_reg;

//Wires needed for M register
wire [7:0] d_M_reg; 
wire [7:0] q_M_reg;
wire [8:0] m_mdouble;

assign d_M_reg={inbus[7],inbus[6],inbus[5],inbus[4],inbus[3],inbus[2],inbus[1],inbus[0]};

//Wires needed for ADD adder
wire [8:0] x,y,z;
wire [8:0] MUX_sub;

//Wires needed for CNT register
wire [1:0] q_CNT_reg;

//Wires needed for K register
wire [2:0] q_K_reg;

mux_1sel #(.size(9)) MUX_A
(
	.sel(c[0]),
	.value0(z),
	.value1({1'b0,inbus[23],inbus[22],inbus[21],inbus[20],inbus[19],inbus[18],inbus[17],inbus[16]}),
	.q(d_A_reg)
);


mux_1sel #(.size(8)) MUX_Q
(
	.sel(c[0]),
	.value0(z[7:0]),
	.value1({inbus[15],inbus[14],inbus[13],inbus[12],inbus[11],inbus[10],inbus[9],inbus[8]}),
	.q(d_Q_reg)
);


mux_1sel #(.size(9)) MUX_DOUBLE
(
	.sel(c[8]),
	.value0({1'b0,q_M_reg[7:0]}),
	.value1({q_M_reg[7:0],1'b0}),
	.q(m_mdouble)
);


mux_1sel #(.size(9)) MUX_X_ADD
(
	.sel(c[12]),
	.value0(q_A_reg),
	.value1({1'b0,q_Q_reg[7:0]}),
	.q(x)
);


mux_1sel #(.size(9)) MUX_Y_ADD
(
	.sel(c[12]),
	.value0(m_mdouble),
	.value1({1'b0,q_Qp_reg[7:0]}),
	.q(MUX_sub)
);


genvar i;
generate
	for(i=0;i<9;i=i+1) begin: loop1
		assign y[i]=MUX_sub[i] ^ (c[12] | c[7]);
	end
endgenerate


srtr4_reg #(.size(9)) A_reg
(
	.clk(clk),
	.rst_b(rst_b),
	.load(c[0] | c[6]),
	.c_down(1'b0),
	.rshift(c[11]),
	.lshift1(c[1]),
	.lshift2(c[2]),
	.left_in(1'b0),
	.right_in({q_Q_reg[7],q_Q_reg[6]}),
	.d(d_A_reg),
	.q(q_A_reg)
);


mux_1sel #(.size(2)) MUX_Q_IN
(
	.sel(c[1]),
	.value0({ (~c[3] & c[5]), (~c[3] & c[4]) }),
	.value1({q_M_reg[7],q_M_reg[6]}),
	.q(Q_right_in)
);

srtr4_reg #(.size(8)) Q_reg
(
	.clk(clk),
	.rst_b(rst_b),
	.load(c[0] | c[12]),
	.c_down(c[10]),
	.rshift(1'b0),
	.lshift1(c[1]),
	.lshift2(c[2]),
	.left_in(1'b0),
	.right_in(Q_right_in),
	.d(d_Q_reg),
	.q(q_Q_reg)
);


lshiftReg #(.bits_shift(2),.size(8)) Qp_reg
(
	.clk(clk),
	.rst_b(rst_b_init),
	.load(1'b0),
	.lshift(c[2]),
	.in({ (c[3] & c[5]) , (c[3] & c[4]) }),
	.d(8'b00000000),
	.q(q_Qp_reg)
);


lshiftReg #(.bits_shift(1),.size(8)) M_reg
(
	.clk(clk),
	.rst_b(rst_b),
	.load(c[0]),
	.lshift(c[1]),
	.in(1'b0),
	.d({inbus[7],inbus[6],inbus[5],inbus[4],inbus[3],inbus[2],inbus[1],inbus[0]}),
	.q(q_M_reg)
);


adder #(.size(9)) ADD
(
	.cin(c[7] | c[12]),
	.x(x),
	.y(y),
	.cout(),
	.z(z)
);


counter #(.size(2)) CNT
(
	.clk(clk),
	.rst_b(rst_b_init),
	.c_up(c[9]),
	.c_down(1'b0),
	.q(q_CNT_reg)
);


counter #(.size(3)) K
(
	.clk(clk),
	.rst_b(rst_b_init),
	.c_up(c[1]),
	.c_down(c[11]),
	.q(q_K_reg)
);


srtr4_8bits_CU test
(
	.clk(clk_b),
	.rst_b(rst_b),
	.BEGIN(BEGIN),
	.cnt(q_CNT_reg),
	.k(q_K_reg),
	.b({q_M_reg[7],q_M_reg[6],q_M_reg[5],q_M_reg[4]}),
	.p({q_A_reg[8],q_A_reg[7],q_A_reg[6],q_A_reg[5],q_A_reg[4],q_A_reg[3]}),
	.c(c),
	.END(END)
);


assign READY=c[13];

mux_1sel #(.size(16)) MUX_obus
(
	.sel(READY),
	.value0(16'b0000000000000000),
	.value1({q_A_reg[7:0],q_Q_reg[7:0]}),
	.q(obus)
);

endmodule












