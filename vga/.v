/*
Module -
Author - Zach Walden
Last Changed -
Description -
Parameters -
*/

module CHANGE(

);

	always @ (posedge clock)
	begin

	end

// the "macro" to dump signals
`ifdef COCOTB_SIM
initial begin
  $dumpfile ("CHANGE.vcd");
  $dumpvars (0, CHANGE);
  #1;
end
`endif
endmodule
