
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

//Wires needed for Qp register
wire [7:0] q_Qp_reg;

//Wires needed for M register
wire [7:0] d_M_reg; 
wire [7:0] q_M_reg;
wire [8:0] m_mdouble;

assign d_M_reg={inbus[7],inbus[6],inbus[5],inbus[4],inbus[3],inbus[2],inbus[1],inbus[0]}

//Wires needed for ADD adder
wire [8:0] x,y,z;
wire [8:0] MUX_sub;

mux_1sel #(.size(9)) MUX_A
(
	.sel(c[0]),
	.value0(z),
	.value1({0,inbus[23],inbus[22],inbus[21],inbus[20],inbus[19],inbus[18],inbus[17],inbus[16]}),
	.q(d_A_reg)
);


mux_1sel #(.size(9)) MUX_Q
(
	.sel(c[0]),
	.value0(z),
	.value1({0,inbus[15],inbus[14],inbus[13],inbus[12],inbus[11],inbus[10],inbus[9],inbus[8]}),
	.q(d_Q_reg)
);


mux_1sel #(.size(9)) MUX_DOUBLE
(
	.sel(c[8]),
	.value0({0,q_M_reg[7:0]}),
	.value1({q_M_reg[7:0],0}),
	.q(m_mdouble)
);


mux_1sel #(.size(9)) MUX_X_ADD
(
	.sel(c[12]),
	.value0(q_A_reg),
	.value1({0,q_Q_reg[7:0]}),
	.q(x)
);


mux_1sel #(.size(9)) MUX_Y_ADD
(
	.sel(c[12]),
	.value0(m_mdouble),
	.value1({0,q_Qp_reg[7:0]}),
	.q(MUX_sub)
);


genvar i;
generate
	for(i=0;i<9;i=i+1) begin: loop1
		assign y[i]=MUX_sub[i] ^ (c[12] | c[7]);
	end
endgenerate


endmodule












