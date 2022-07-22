

module top(
	input clk100M
);

	wire ila_clk;
	wire sys_clk;

	//Instantiate Clock Generator
	sys_clk_gen clk_gen(
    		// Clock out ports
    		.ila_clk(ila_clk),     // output ila_clk
    		.sys_clk(sys_clk),     // output sys_clk
   		// Clock in ports
    		.clk_in1(clk100M)
	);      // input clk_in1

	wire [3:0] addra;
	wire [3:0] douta;

	//instantiate Program Memory
	program_memory prog_mem(
  		.clka(sys_clk),    // input wire clka
  		.addra(addra),  // input wire [14 : 0] addradina
  		.douta(douta)  // output wire [31 : 0] douta
	);
	
	wire reset = 0;

	reg [3:0] addr;
	reg [3:0] stg_one;
	reg [3:0] stg_two;

	always @ (posedge sys_clk)
	begin
	    if(reset == 1'b1)
	    begin
	       addr <= 0;
	       stg_one <= 0;
	       stg_two <= 0;
	    end
	    else
	    begin
		  addr <= addr + 1;
		  stg_one <= douta;
		  stg_two <= stg_one;
	   end
	end

	assign addra = addr;

	//Instantiate ILA
	ila sys_ila(
		.clk(ila_clk), // input wire clk
		.probe0(addr), // input wire [3:0]  probe0
		.probe1(douta), // input wire [3:0]  probe1
		.probe2(stg_one), // input wire [3:0]  probe2
		.probe3(stg_two),
		.probe4(sys_clk)
	);
endmodule
