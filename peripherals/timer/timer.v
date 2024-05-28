/*
 * This program source code file is part of Banff
 *
 * Copyright (C) 2024 Zachary Walden zachary.walden@eagles.oc.edu
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 3
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, you may find one here:
 * http://www.gnu.org/licenses/gpl-3.0.en.html
 * or you may search the http://www.gnu.org website for the version 3 license,
 * or you may write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
 */

/*==================================================================================
 *Module - Timer
 *Author - Zach Walden
 *Created - 05/23/24
 *Last Changed - 05/23/24
 *Description - Generic Memory Mapped 64-bit timer
 *Parameters -
 *Registers -
 *		TMRxCR0: 8-bit
 *				<0>: Enable Bit, Active High
 *				<1>: Clear, Active High.
 *				<2>: Count Up/Down, High Up, Low Down.
 *				<3>: Compare Match Interrupt Enable, Active High.
 *				<4>: PWM Enable, Active High.
 *				<7:5> Mode.
 *					000: reset at compare match and trigger interrupt if enabled
 *					001: Do not reset at compare match. Simply let
 *						 under/overflow happen.
 *					010:
 *					011:
 *					100:
 *					101:
 *					110:
 *					111:
====================================================================================*/

module timer
#(
	parameter TIMER_WIDTH=64,
	parameter IO_MEM_ADDR=13'b1000000000000,
	parameter NUM_REGS=32,
	parameter ADDRESS_WIDTH=19,
	parameter DATA_WIDTH=8
)
(
	input clock,
	input reset,
	input [DATA_WIDTH - 1:0] data_in,
	output reg [DATA_WIDTH - 1:0] data_out,
	output reg mux_sel,
	input [ADDRESS_WIDTH - 1:0] addr_in,
	input wen,
	output reg compare_match_interrupt,
	output reg pwm_out
);

	reg [7:0] control_regs [NUM_REGS - 1:0];

	wire [63:0] tmr_cnt, tmr_cmpr;
	wire [63:0] tmr_inc, tmr_dec;

	always @ (posedge clock)
	begin
		if(reset == 1'b1)
		begin
			data_out <= 0;
			mux_sel <= 0;
			compare_match_interrupt <= 0;
			pwm_out;
			control_regs <= 0;
		end
		else
		begin
			//read
			if()
			begin

			end
			//run
			if()
			begin

			end
			else
			begin

			end
			//output compare
		end
	end

	assign tmr_inc = tmr_cnt + 1;
	assign tmr_dec = tmr_cnt - 1;

// the "macro" to dump signals
`ifdef COCOTB_SIM
initial begin
  $dumpfile ("timer.vcd");
  $dumpvars (0, timer);
  #1;
end
`endif
endmodule
