/*==================================================================================
 *Module - Vertical Counter & Sync Generator
 *Author - Zach Walden
 *Created - 7/21/22
 *Last Changed - 7/21/22
 *Description - Counts the Rows and generates VGA Synchronization signals based off of that count.
 *Parameters -
====================================================================================*/

/*
 * This program source code file is part of Banff
 *
 * Copyright (C) 2022 Zachary Walden zachary.walden@eagles.oc.edu
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
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
 * or you may search the http://www.gnu.org website for the version 2 license,
 * or you may write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
 */

module vert_cntr
(
	input row_done,
	input reset,
	input [36:0] vert_cont_registers,
	output reg vsync = 1,
	output reg vblank = 0,
	output frm_done
);
	wire [8:0] visible_area;
	wire [8:0] front_porch;
	wire [8:0] sync_pulse;
	wire [9:0] whole_frame;

	reg [9:0] value = 0;

	wire [9:0] value_inc;

	wire set_vblank;
	wire set_vsync;
	wire clear_vsync;
	wire frame_done;

	always @ (negedge row_done)
	begin
		if(nreset == 1'b0)
		begin
			value <= 0;
			vblank <= 0;
			vsync <= 1;
		end
		else
		begin
			if(frame_done == 1'b1)
			begin
				vblank <= 0;
				value <= 0;
			end
			else
			begin
				value <= value_inc;
			end
			if(set_vblank == 1'b1)
			begin
				vblank <= 1;
			end
			else
			begin

			end
			if(set_vsync == 1'b1)
			begin
				vsync <= 0;
			end
			else
			begin

			end
			if(clear_vsync == 1'b1)
			begin
				vsync <= 1;
			end
		end
	end

	assign frm_done = frame_done;

	assign value_inc = value + 1;

	assign set_vblank = (value == visible_area) ? 1'b1 : 0'b1;
	assign set_vsync = (value == front_porch) ? 1'b1 : 1'b0;
	assign clear_vsync = (value == sync_pulse) ? 1'b1 : 1'b0;
	assign frame_done = (value == whole_frame) ? 1'b1 : 1'b0;

// the "macro" to dump signals
`ifdef COCOTB_SIM
initial begin
  $dumpfile ("vert_cntr.vcd");
  $dumpvars (0, vert_cntr);
  #1;
end
`endif
endmodule
