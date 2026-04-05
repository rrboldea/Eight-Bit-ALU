
//Adder cell, providing generate and propagate signals fo the CLA adder

module ac 
(
	input x,y,cin,
	output g,p,z
);

assign z=x ^ y ^ cin;
assign g=x & y;
assign p=x | y;

endmodule
