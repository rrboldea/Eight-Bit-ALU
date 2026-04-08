module test
(
	input clk,rst_b,ld_x_y_b,
	input ADD_b,SUB_b,
	input [7:0] data,
	output DONE,
	output [7:0] q
);

//buttons on de10-lite are pulled HIGH, so we have to reverse the logical value
wire ADD,SUB,ld_x_y;

assign ADD=~ADD_b;
assign SUB=~SUB_b;
assign ld_x_y=~ld_x_y_b;

wire ADD_sync,SUB_sync,ld_x_y_sync;

synchronizer syncADD
(
	.clk(clk),
	.signal_in(ADD),	
	.signal_out(ADD_sync)
);

synchronizer syncSUB
(
	.clk(clk),
	.signal_in(SUB),	
	.signal_out(SUB_sync)
);

synchronizer sync_ld_x_y
(
	.clk(clk),
	.signal_in(ld_x_y),	
	.signal_out(ld_x_y_sync)
);

wire ADD_posedge,SUB_posedge,ld_x_y_posedge;

pos_edge posADD
(
	.clk(clk),
	.signal_in(ADD_sync),	
	.signal_out(ADD_posedge)
);

pos_edge posSUB
(
	.clk(clk),
	.signal_in(SUB_sync),	
	.signal_out(SUB_posedge)
);

pos_edge pos_ld_x_y
(
	.clk(clk),
	.signal_in(ld_x_y_sync),	
	.signal_out(ld_x_y_posedge)
);

wire [7:0] x,y;
wire [15:0] out;

assign q={out[7:0]};

test_load_x_y load
(
	.clk(clk),
	.rst_b(rst_b),
	.ld_x_y(ld_x_y_posedge),
	.data(data),
	.x(x),
	.y(y)
);

ALU alu
(
	.clk(clk),
	.rst_b(rst_b),
	.ADD(ADD_posedge),
	.SUB(SUB_posedge),
	.MULT(1'b0),
	.x(x),
	.y(y),
	.DONE(DONE),
	.q(out)
);

endmodule


