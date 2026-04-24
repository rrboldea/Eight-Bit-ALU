
//used for synchronizing button signals for the test module for de10-lite

module synchronizer
(
    input signal_in,clk,
    output signal_out
);
  
reg signal_latched0,signal_latched1;
assign signal_out=signal_latched1;  

always @(posedge clk)
begin
	signal_latched0<=signal_in;
	signal_latched1<=signal_latched0;
end

  
endmodule