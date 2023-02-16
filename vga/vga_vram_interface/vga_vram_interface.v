/*==================================================================================
 *Module - Vga Vram Interface.
 *Author - Zach Walden
 *Created - 10/5/22
 *Last Changed - 10/6/22
 *Description - Interfaces with vga half of the memory bus 16-bits wide. It also reads control registers in order to properly read and display memory based on the current video mode.
 *Parameters -
====================================================================================*/

/*
 * This program source code file is part of BANFF
 *
 * Copyright (C) 2022 Zachary Walden zachary.walden@eagles.oc.edu
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
 * or you may search the http://www.gnu.org website for the version 2 license,
 * or you may write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
 */

module vga_vram_interface
#(
	parameter PIXEL_WIDTH=12,
	parameter VRAM_DATA_WIDTH=16,
	parameter VRAM_ADDR_WIDTH=17,
)
(
	input clock,
	input reset,

	input [7:0] vgacr0;

	input row_done;
	input frm_done;

	input hblank;
	input vblank;

	output [VRAM_DATA_WIDTH - 1:0] vram_data,
	output [VRAM_ADDR_WIDTH - 1:0] vram_addr,

	output reg new_pixel = 0;

	output [PIXEL_WIDTH - 1:0] pixel
);

	reg [3:0] clk_div_cnt = 0;
	wire [3:0] clk_div_cnt_inc;
	//Clock Divider Logic
	always @ (posedge clock)
	begin
		if (reset == 1'b1)
		begin
			clk_div_cnt <= 4'h0;
		end
		else
		begin
			clk_div_cnt <= clk_div_cnt_inc;
			//If VGACR0 <6:5>
			//640x480, 640x350
			if(vgacr0[6:5] == 2'b00)
			begin
				if(clk_div_cnt == 4'b0001)
				begin
					clk_div_cnt <= 0;
					new_pixel <= 1;
				end
				else
				begin
					new_pixel <= 0;
				end
			end
			//320x175, 320x240
			else if(vgacr0[6:5] == 2'b01)
			begin
				if(clk_div_cnt == 4'b0010)
				begin
					clk_div_cnt <= 0;
					new_pixel <= 1;
				end
				else
				begin
					new_pixel <= 0;
				end

			end
			//160x120
			else if(vgacr0[6:5] == 2'b10)
			begin
				if(clk_div_cnt == 4'b0100)
				begin
					clk_div_cnt <= 0;
					new_pixel <= 1;
				end
				else
				begin
					new_pixel <= 0;
				end
			end
			//80x60
			else
			begin
				if(clk_div_cnt == 4'b1000)
				begin
					clk_div_cnt <= 0;
					new_pixel <= 1;
				end
				else
				begin
					new_pixel <= 0;
				end
			end

		end
	end

	assign clk_div_cnt_inc = clk_div_cnt + 1;

	reg next_row = 0;

	reg half_used = 0, used = 0;

	reg [5:0] pix_pointer_cache = 0;
	reg [5:0] pix_pointer = 0;

	reg [5:0] pix_pointer_h = 0;
	reg [5:0] pix_pointer_h_cache = 0;

	reg [VRAM_ADDR_WIDTH - 1:0] mem_addr = 0;
	reg [VRAM_ADDR_WIDTH - 1:0] row_addr_cache = 0;

	reg [2:0] state = 0, next_state = 0;

	//State Machine for controlling pixel data.
	always @ (posedge clock)
	begin
		if(reset == 1'b1)
		begin
			state <= 3'h0;
		end
		else
		begin
			state <= next_state;
		end
	end
	reg fetch_mem = 0;
	always @ (*)
	begin
		case(state)
		begin
			//No Output
			3'h0 :
			begin

			end
			//1bpp
			3'h1 :
			begin
				//Inc ptr, next_state <= 4'h1;
			end
			//4bpp grayscale
			3'h2 :
			begin

			end
			//8bpp color
			3'h3 :
			begin

			end
			//12bpp un-packed
			3'h4 :
			begin
				//Always trigger
			end
			//default
			default
			begin

			end
		endcase
	end

	reg [3:0] row_cntr = 0;
	wire [3:0] row_cntr_inc;

	//logic to handle row reapeats
	always @ (posedge clock)
	begin
		if(reset == 1'b1)
		begin
			row_cntr <= 0;
		end
		else
		begin
			if(row_done == 1'b1 && vblank == 1'b0)
			begin
				row_cntr <= row_cntr_inc;
				if(vgacr0[6:5] == 2'b00 && row_cntr == 4'b0001)
				begin
					next_row <= 1;
					row_cntr <= 0;
					//save row address and offset pointer
					row_addr_cache <= mem_addr;
					pix_pointer_cache <= pix_pointer;
				end
				else if(vgacr0[6:5] == 2'b01 && row_cntr == 4'b0100)
				begin
					next_row <= 1;
					row_cntr <= 0;
					//save row address and offset pointer
					row_addr_cache <= mem_addr;
					pix_pointer_cache <= pix_pointer;
				end
				else if(vgacr0[6:5] == 2'b10 && row_cntr == 4'b1000)
				begin
					next_row <= 1;
					row_cntr <= 0;
					//save row address and offset pointer
					row_addr_cache <= mem_addr;
					pix_pointer_cache <= pix_pointer;
				end
				else if(vgacr0[6:5] == 2'b11 && row_cntr == 4'b1000)
				begin
					next_row <= 1;
					row_cntr <= 0;
					//save row address and offset pointer
					row_addr_cache <= mem_addr;
					pix_pointer_cache <= pix_pointer;
				end
				else
				begin
					next_row <= 0;
				end
			end
			if(vblank == 1'b1 || frm_done == 1'b1)
			begin
				row_addr_cache <= 0;
				pix_pointer_cache <= 0;
				pix_pointer_h_cache <= 0;
			end
		end
	end

	assign row_cntr_inc = row_cntr + 1;

	//Logic to take memory data and convert it to pixel output
	//Upon assertion of new_pixel, this logic.
	//4 modes 1bpp monochrome, 4bpp grayscale, 8bpp color, 12bpp color
	reg [31:0] data_buffer = 0;

	always @ (*)
	begin
		//1bpp
		if(vgacr0[3:2] == 2'b00)
		begin
			if(data_buffer[pix_pointer] == 1'b1)
			begin
				pixel <= 12'hFFF;
			end
			else
			begin
				pixel <= 12'h000;
			end
		end
		//4bpp
		else if(vgacr0[3:2] == 2'b01)
		begin

		end
		//8bpp
		else if(vgacr0[3:2] == 2'b10)
		begin

		end
		//12bpp
		else
		begin

		end
	end



// the "macro" to dump signals
`ifdef COCOTB_SIM
initial begin
  $dumpfile ("vga_vram_interface.vcd");
  $dumpvars (0, vga_vram_interface);
  #1;
end
`endif
endmodule
