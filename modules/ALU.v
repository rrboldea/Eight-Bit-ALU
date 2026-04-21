module ALU
(
	input clk, rst_b,
	input ADD, SUB, MULT, DIV,
	input [7:0] x, y,
	output DONE,
	output [15:0] q
);

// wires needed for ADDER
wire [7:0] y_ADD;
wire [7:0] z_ADD;
wire cout;
wire ovrflow;

assign ovrflow = (x[7] ^ z_ADD[7]) & (y_ADD[7] ^ z_ADD[7]);

genvar i;
generate
	for(i=0; i<8; i=i+1) begin: loop
		assign y_ADD[i] = y[i] ^ SUB;	
	end
endgenerate

//wires needed for the MULTIPLIER
wire ready_MULT;
wire end_MULT;
wire [15:0] z_MULT;

// wires needed for the DIVIDER
wire ready_DIV;
wire [16:0] z_DIV_raw;
wire [15:0] z_DIV = {z_DIV_raw[15:8], z_DIV_raw[7:0]}; // Rest LSB din A + Cat

// wires for structural MUX cascade
wire [15:0] z_ADD_ext = {{8{z_ADD[7] ^ ovrflow}}, z_ADD};
wire [15:0] d_OUT_inter; 
wire [15:0] d_OUT;       


wire load = ADD | SUB | ready_MULT | ready_DIV;

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

nrd8bits DIVIDER
(
    .clk(clk),
    .rst_b(rst_b),
    .start(DIV),
    .inbus({x, y}),
    .outbus(z_DIV_raw),
    .done(ready_DIV)
);



// MUX 1: Chooses between ADD/SUB and MULT
mux_1sel #(.size(16)) MUX_ADD_MULT
(
	.sel(ready_MULT),
	.value0(z_ADD_ext),
	.value1(z_MULT),
	.q(d_OUT_inter)
);

// MUX 2: Chooses between previous result and DIV
mux_1sel #(.size(16)) MUX_FINAL
(
	.sel(ready_DIV),
	.value0(d_OUT_inter),
	.value1(z_DIV),
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

assign DONE = end_MULT | ready_DIV;

endmodule