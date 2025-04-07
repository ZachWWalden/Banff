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
 *Module - core_top
 *Author - Zach Walden
 *Created - 04/01/25
 *Last Changed - 04/01/25
 *Description -
 *Parameters -
====================================================================================*/

module core_top
#(

)
(
	input clock,
	input reset,
);

	always @ (posedge clock)
	begin

	end

// the "macro" to dump signals
`ifdef COCOTB_SIM
initial begin
  $dumpfile ("core_top.vcd");
  $dumpvars (0, core_top);
  #1;
end
`endif
endmodule
