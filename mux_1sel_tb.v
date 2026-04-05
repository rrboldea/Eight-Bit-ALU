module mux_1sel_tb;

reg sel,value1,value0;
wire q;

mux_1sel test
(
	.sel(sel),
	.value1(value1),
	.value0(value0),
	.q(q)
);

initial begin
	{sel,value1,value0}=3'b0;
end

always 
begin
	#50;
	{sel,value1,value0}={sel,value1,value0}+1;
end

endmodule