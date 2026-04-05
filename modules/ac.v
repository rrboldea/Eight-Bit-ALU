module ac 
(
	input x,y,cin,
	output g,p,z
);

assign z=x ^ y ^ cin;
assign g=x & y;
assign p=x | y;

endmodule