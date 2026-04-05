module hac
(
	input x,y,
	output z,cout
);

assign z=x ^ y;
assign cout=x & y;

endmodule