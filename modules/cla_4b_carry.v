module cla_4b_carry
(
	input cin,
	input [3:0] g,p,
	output [4:1] carry
);

assign carry[1]=g[0] | ( p[0] & cin );
assign carry[2]=g[1] | ( g[0] & p[1] ) | ( p[0] & p[1] & cin );
assign carry[3]=g[2] | ( g[1] & p[2] ) | ( g[0] & p[1] & p[2] ) | ( p[0] & p[1] & p[2] & cin );
assign carry[4]=g[3] | ( g[2] & p[3] ) | ( g[1] & p[2] & p[3] ) | ( g[0] & p[1] & p[2] & p[3] ) | ( p[0] & p[1] & p[2] & p[3] & cin );

endmodule