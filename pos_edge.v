
//used for detecting positive edge of the signals produced by the button on the
//de10-lite

module pos_edge
(
	input clk,signal_in,
	output signal_out
);

reg signal_latched;

assign signal_out=signal_in & (~signal_latched);

always @(posedge clk)
begin
	signal_latched<=signal_in;
end

endmodule
