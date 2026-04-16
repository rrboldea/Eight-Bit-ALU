module ALU
(
	input clk,rst_b,
	input ADD,SUB,MULT,DIV,
	input [7:0] w,x,y,
	output DONE,
	output [15:0] q
);

//wires needed for ADDER
wire [7:0] y_ADD;
wire [7:0] z_ADD;
wire cout;
wire ovrflow;

assign ovrflow=(x[7] ^ z_ADD[7]) & (y_ADD[7] ^ z_ADD[7]);

genvar i;
generate
	for(i=0;i<8;i=i+1) begin: loop
		assign y_ADD[i]=y[i] ^ SUB;	
	end
endgenerate

//wires needed for the MULTIPLIER
wire ready_MULT;
wire end_MULT;
wire [15:0] z_MULT;

//wires needed for the DIVIDER
wire ready_DIV;
wire end_DIV;
wire [15:0] z_DIV;

//wires needed for OUT register
wire [15:0] d_OUT;
wire load=ADD | SUB | ready_MULT | ready_DIV;

adder #(.size(8)) ADDER
(
	.x(x),
	.y(y_ADD),
	.cin(SUB),
	.z(z_ADD),
	.cout(cout)
);

br4_8bits MULTIPLIER
(
	.clk(clk),
	.rst_b(rst_b),
	.BEGIN(MULT),
	.inbus({x,y}),
	.READY(ready_MULT),
	.END(end_MULT),
	.obus(z_MULT)
);

srtr4_8bits DIVIDER
(
	.clk(clk),
	.rst_b(rst_b),
	.BEGIN(DIV),
	.inbus({w,x,y}),
	.READY(ready_DIV),
	.END(end_DIV),
	.obus(z_DIV)
);

wire [15:0] mult_div;

mux_1sel #(.size(16)) MUX_1
(
	.sel(ready_MULT),
	.value0(z_DIV), 
	.value1(z_MULT),
	.q(mult_div)
);

mux_1sel #(.size(16)) MUX_2
(
	.sel(ready_MULT | ready_DIV),

	//we complete the 8 MSB of the 16 bit value with the propper sign of the 8 bit result 
	.value0({{8{z_ADD[7] ^ ovrflow}},z_ADD}), 
	.value1(mult_div),
	.q(d_OUT)
);

register #(.size(16)) OUT
(
	.clk(clk),	
	.rst_b(rst_b),
	.load(load),
	.data(d_OUT),
	.q(q)
);

assign DONE=end_MULT & end_DIV;

endmodule














