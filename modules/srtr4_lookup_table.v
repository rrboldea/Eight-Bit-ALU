
//the combinational logic that determines the operation for the SRT R4 division

module srtr4_lookup_table
(
	input [5:0] p,
	input [3:0] b,
	
	//signals marking one redundant digit {-2,-1,0,1,2}
	output two_b,one_b,zero,one,two
);

//wires to shorten the writing
wire p5,p4,p3,p2,p1,p0;

assign p5=p[5];
assign p4=p[4];
assign p3=p[3];
assign p2=p[2];
assign p1=p[1];
assign p0=p[0];

wire p5_b,p4_b,p3_b,p2_b,p1_b,p0_b;

assign p5_b=(~p[5]);
assign p4_b=(~p[4]);
assign p3_b=(~p[3]);
assign p2_b=(~p[2]);
assign p1_b=(~p[1]);
assign p0_b=(~p[0]);



//auxiliary wires 
wire eight_2_b,nine_2_b,ten_2_b,twelve_2_b,fifteen_2_b;
wire eight_1_b,nine_1_b,ten_1_b,twelve_1_b,fifteen_1_b;
wire eight_0,nine_0,twelve_0,fifteen_0;
wire eight_1,nine_1,ten_1,twelve_1,fifteen_1;
wire eight_2,nine_2,ten_2,twelve_2,fifteen_2;

assign eight_2_b=p5 & p4 & ( (p3_b & p2) | (p3 & p2_b & p1_b) );
assign eight_1_b=p5 & p4 & p3 & (p2 ^ p1);
assign eight_0=(p5 & p4 & p3 & p2 & p1) | (p5_b & p4_b & p3_b & p2_b & p1_b);
assign eight_1=p5_b & p4_b & p3_b & (p2 ^ p1);
assign eight_2=p5_b & p4_b & ( (p3 & p2_b) | (p3_b & p2 & p1) );

assign nine_2_b=p5 & p4 & ( (p3_b & (p2 | p1)) | (p3 & p2_b & p1_b & p0_b) );
assign nine_1_b=p5 & p4 & p3 & (p2 ^ (p1 | p0));
assign nine_0=(p5 & p4 & p3 & p2 & (p1 | p0)) | (p5_b & p4_b & p3_b & p2_b & ( ~(p1 & p0) ));
assign nine_1=p5_b & p4_b & p3_b & (p2 ^ (p1 & p0));
assign nine_2=p5_b & p4_b & ( (p3 & ( ~(p2 & p1) )) | (p3_b & p2 & p1 & p0) );

assign ten_2_b=p5 & p4 & p3_b & (p2 | p1 | p0);
assign ten_1_b=p5 & p4 & p3 & ( ~((p2 & p1) | (p2 & p0)) );
assign ten_1=p5_b & p4_b & p3_b & (p2 | (p2_b & p1 & p0));
assign ten_2=p5_b & p4_b & p3 & ( ~(p2 & p1 & p0) );

assign twelve_2_b=p5 & ( (p4 & p3_b & ( ~(p2 & p1) )) | (p4_b & p3 & p2 & p1) );
assign twelve_1_b=p5 & p4 & ( (p3 & p2_b) | (p3_b & p2 & p1) );
assign twelve_0=(p5 & p4 & p3 & p2) | (p5_b & p4_b & p3_b & p2_b);
assign twelve_1=p5_b & p4_b & ( (p3_b & p2) | (p3 & p2_b & p1_b) );
assign twelve_2=p5_b & ( (p4_b & p3 & (p2 | p1)) | (p4 & p3_b & p2_b & p1_b) );

assign fifteen_2_b=p5 & ( (p4 & p3_b & p2_b) | (p4_b & p3 & (p2 | p1)) );
assign fifteen_1_b=p5 & p4 & ( (p3_b & p2) | (p3 & p2_b & ( ~(p1 & p0) )) );
assign fifteen_0=(p5 & p4 & p3 & (p2 | (p2_b & p1 & p0))) | (p5_b & p4_b & p3_b & ( ~( (p2 & p1) | (p2 & p0) ) ));
assign fifteen_1=p5_b & p4_b & ( (p3_b & p2 & (p1 | p0)) | (p3 & p2_b) );
assign fifteen_2=p5_b & ( (p4_b & p3 & p2) | (p4 & p3_b & ( ~(p2 & p1) )) );


//wires that signal the value of b
wire b8,b9,b10,b11,b12,b13,b14,b15;

assign b8=b[3] * (~b[2]) * (~b[1]) * (~b[0]);
assign b9=b[3] * (~b[2]) * (~b[1]) * b[0];
assign b10=b[3] * (~b[2]) * b[1] * (~b[0]);
assign b11=b[3] * (~b[2]) * b[1] * b[0];
assign b12=b[3] * b[2] * (~b[1]) * (~b[0]);
assign b13=b[3] * b[2] * (~b[1]) * b[0];
assign b14=b[3] * b[2] * b[1] * (~b[0]);
assign b15=b[3] * b[2] * b[1] * b[0];



//logic functions to determine the digit
assign two_b=(eight_2_b & b8) | (nine_2_b & b9) | (ten_2_b & (b10 | b11)) | ((p5 & p4 & p3_b & p2_b & p1_b & p0_b) & b11) | (twelve_2_b & (b12 | b13 | b14)) | ((p5 & p4_b & p3 & p2 & p1_b & p0) & (b13 | b14)) | ((p5 & p4_b & p3 & p2 & p1_b & p0_b) & b14) | (fifteen_2_b & b15);
assign one_b=(eight_1_b & b8) | (nine_1_b & b9) | (ten_1_b & (b10 | b11)) | (twelve_1_b & (b12 | b13 | b14)) | (fifteen_1_b & b15);
assign zero=(eight_0 & b8) | (nine_0 & (b9 | b10 | b11)) | (twelve_0 & (b12 | b13 | b14)) | (fifteen_0 & b15);
assign one=(eight_1 & b8) | (nine_1 & b9) | (ten_1 & (b10 | b11)) | (twelve_1 & (b12 | b13 | b14)) | (fifteen_1 & b15);
assign two=(eight_2 & b8) | (nine_2 & b9) | (ten_2 & (b10 | b11)) | ((p5_b & p4_b & p3 & p2 & p1 & p0) & b11) | (twelve_2 & (b12 | b13 | b14)) | ((p5_b & p4 & p3_b & p2_b & p1 & p0_b) & (b13 | b14)) | ((p5_b & p4 & p3_b & p2_b & p1 & p0) & b14) | (fifteen_2 & b15);

endmodule





