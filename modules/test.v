module test
(
	input clk,rst_b,ld_w_x_y_b,
	input ADD_b,SUB_b,MULT_b,DIV_b,
	input [7:0] data,
	output DONE,
	output [15:0] q
);

//buttons on de10-lite are pulled HIGH, so we have to reverse the logical value
wire ADD,SUB,MULT,DIV,ld_w_x_y;

assign ADD=~ADD_b;
assign SUB=~SUB_b;
assign MULT=~MULT_b;
assign DIV=~DIV_b;
assign ld_w_x_y=~ld_w_x_y_b;

wire ADD_sync,SUB_sync,MULT_sync,DIV_sync,ld_w_x_y_sync;

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

synchronizer syncMULT
(
	.clk(clk),
	.signal_in(MULT),	
	.signal_out(MULT_sync)
);

synchronizer syncDIV
(
	.clk(clk),
	.signal_in(DIV),	
	.signal_out(DIV_sync)
);

synchronizer sync_ld_w_x_y
(
	.clk(clk),
	.signal_in(ld_w_x_y),	
	.signal_out(ld_w_x_y_sync)
);

wire ADD_posedge,SUB_posedge,MULT_posedge,DIV_posedge,ld_w_x_y_posedge;

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

pos_edge posMULT
(
	.clk(clk),
	.signal_in(MULT_sync),	
	.signal_out(MULT_posedge)
);

pos_edge posDIV
(
	.clk(clk),
	.signal_in(DIV_sync),	
	.signal_out(DIV_posedge)
);

pos_edge pos_ld_w_x_y
(
	.clk(clk),
	.signal_in(ld_w_x_y_sync),	
	.signal_out(ld_w_x_y_posedge)
);

wire [7:0] w,x,y;

test_load_w_x_y load
(
	.clk(clk),
	.rst_b(rst_b),
	.ld_w_x_y(ld_w_x_y_posedge),
	.data(data),
	.w(w),
	.x(x),
	.y(y)
);

ALU alu
(
	.clk(clk),
	.rst_b(rst_b),
	.ADD(ADD_posedge),
	.SUB(SUB_posedge),
	.MULT(MULT_posedge),
	.DIV(DIV_posedge),
	.w(w),
	.x(x),
	.y(y),
	.DONE(DONE),
	.q(q)
);

endmodule


