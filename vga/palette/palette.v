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
 *Module - Palette
 *Author - Zach Walden
 *Created - 05/19/24
 *Last Changed - 05/19/24
 *Description - 256 entry memory mapped IO unit used as a color palette for cetain vga modes.modes CPU only has write access.
 *Parameters -
====================================================================================*/

module palette
#(
	parameter DATA_WIDTH=8,
	parameter ADDR_BUS_WIDTH=19,
	parameter NUM_COLORS=256,
	parameter PIXEL_WIDTH=12,
	parameter PIXEL_ADDR_WIDTH=8
)
(
	input cpu_clock,
	input vga_clock,
	input reset,
	input [DATA_WIDTH - 1:0] data_bus,
	input [PIXEL_ADDR_WIDTH - 1:0] pixel_addr_in,
	output reg [PIXEL_WIDTH - 1:0] pixel_out,
	input [ADDR_BUS_WIDTH - 1:0] addr_bus,
	input data_wen,
);

	reg [3:0] red [NUM_COLORS - 1:0];
	reg [3:0] green [NUM_COLORS - 1:0];
	reg [3:0] blue [NUM_COLORS - 1:0];

	//Write
	always @ (posedge cpu_clock)
	begin
		if(reset == 1'b1)
		begin
			red <= 0;
			green <= 0;
			blue <= 0;
		end
		else
		begin
			if(data_wen == 1'b1 && addr_bus[ADDR_BUS_WIDTH - 1:0] == 11'b10000000000)
			begin
				red[addr_bus[7:0]] <= data_bus[3:0];
			end
			else if(data_wen == 1'b1 && addr_bus[ADDR_BUS_WIDTH - 1:0] == 11'b10000000001)
			begin
				green[addr_bus[7:0]] <= data_bus[3:0];
			end
			else if(data_wen == 1'b1 && addr_bus[ADDR_BUS_WIDTH - 1:0] == 11'b10000000010)
			begin
				blue[addr_bus[7:0]] <= data_bus[3:0];
			end
		end
	end
	//read port for vga unit
	always @ (posedge vga_clock)
	begin
		if(data_wen == 1'b0)
		begin
			pixel_out[11:8] <= red[pixel_addr_in];
			pixel_out[7:4] <= green[pixel_addr_in];
			pixel_out[3:0] <= blue[pixel_addr_in];
		end
	end

// the "macro" to dump signals
`ifdef COCOTB_SIM
initial begin
  $dumpfile ("palette.vcd");
  $dumpvars (0, palette);
  #1;
end
`endif
endmodule
