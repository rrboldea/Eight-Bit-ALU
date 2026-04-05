
//full adder cell, needed for implementing RCA adder and add_sub_1 cell

module fac 
(
	input x,y,cin,
	output z,cout
);

assign z=x ^ y ^ cin;
assign cout=(x & cin) | (y & cin) | (x & y);

endmodule
