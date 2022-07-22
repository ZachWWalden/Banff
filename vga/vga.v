/*==================================================================================
 *Module - VGA Controller Top Module.
 *Author - Zach Walden
 *Created - 7/20/22
 *Last Changed - 7/20/22
 *Description - VGA Controller for Banff uArchitecture. Contains Memory mapped control registers.
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
 * http://www.gnu.org/licenses/old-licenses/gpl-3.0.en.html
 * or you may search the http://www.gnu.org website for the version 2 license,
 * or you may write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
 */

module vga
#(
	parameter DATA_WIDTH=8,
	parameter ADDR_BUS_WIDTH=19,
	parameter PIXEL_WIDTH=12,
	parameter VRAM_DATA_WIDTH=16,
	parameter VRAM_ADDR_WIDTH=17,
	parameter  NUM_VGA_CONT_REG=11
)
(
	input clock,
	input reset,
	//Main Memory Bus (For I/O)
	input [DATA_WIDTH - 1:0] data_bus,
	output [DATA_WIDTH - 1:0] data_bus_out,
	input [ADDR_BUS_WIDTH - 1:0] addr_bus,
	input data_wen,
	//VRAM Interface
	output [VRAM_DATA_WIDTH - 1:0] vram_data,
	output [VRAM_ADDR_WIDTH - 1:0] vram_addr,
	//VGA Interface
	output vsync,
	output hsync,
	output int_hblank,
	output int_vblank,
	output [PIXEL_WIDTH - 1:0] pixel
);
	//Define Wires
	wire [(NUM_VGA_CONT_REG * DATA_WIDTH) - 1:0] control_reg_out; //Total Number of 8 bit control registers.

	wire hblank;
	wire vblank;

	//Instantiate Control Register module
	vga_control_registers vga_regs(
		.clock(clock),
		.reset(reset),
		.data_bus(data_bus),
		.data_bus_out(.data_bus_out),
		.addr_bus(addr_bus),
		.data_wen(data_wen),
		.control_reg_out(control_reg_out)
	);

	//Instantiate Sync Generator Module
	vga_sync_generator vga_sync(
		.clock(clock),
		.reset(reset),
		.control_reg(control_reg_out),
		.hblank(hblank),
		.vblank(vblank),
		.hsync(hsync),
		.vsync(vsync)
	);

	//Instantiate VRAM Interface
	vga_vram_interface vram_interface(
		.clock(clock),
		.reset(reset),
		.vram_data(vram_data),
		.vram_addr(vram_addr),
		.control_reg(control_reg_out[(NUM_VGA_CONT_REG * DATA_WIDTH) - 1:(NUM_VGA_CONT_REG - 1) * DATA_WIDTH]),
		.pixel(pixel)
	);

	//Instantiate Interrupt Generator
	vga_interrupt_generator vga_int_gen(
		.clock(clock),
		.reset(reset),
		.hblank(hblank),
		.vblank(vblank),
		.int_hblank(int_hblank),
		.int_vblank(int_vblank)
	);

// the "macro" to dump signals
`ifdef COCOTB_SIM
initial begin
  $dumpfile ("vga.vcd");
  $dumpvars (0, vga);
  #1;
end
`endif
endmodule
