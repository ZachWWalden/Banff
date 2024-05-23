/*==================================================================================
 *Module - Vga Control Registers
 *Author - Zach Walden
 *Created - 7/20/22
 *Last Changed - 7/21/22
 *Description -
 *Parameters -
====================================================================================*/

/*
 * This program source code file is part of Banff
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

module vga_control_registers
#(
	parameter DATA_WIDTH=8,
	parameter ADDR_BUS_WIDTH=19,
	parameter  NUM_VGA_CONT_REG=11
)
(
	input clock,
	input reset,
	input [DATA_WIDTH - 1:0] data_bus,
	output reg [DATA_WIDTH - 1:0] data_bus_out,
	input [ADDR_BUS_WIDTH - 1:0] addr_bus,
	input data_wen,
	output reg mux_sel,
	output [(NUM_VGA_CONT_REG * DATA_WIDTH) - 1:0] control_reg_out //Total Number of 8 bit control registers.
);

	//Define Registers
	reg [7:0] vga_control_registers [NUM_VGA_CONT_REG - 1:0]

	always @ (negedge clock)
	begin
		if(reset == 1'b1)
		begin
			vga_control_registers <= 0;
			data_bus_out <= 0;
			mux_sel <= 0;
		end
		else
		begin
			//If memory bus is addressing this MMIO Bank, check for a read or write. Mapped to 19'h00000
			if(addr_bus[ADDR_BUS_WIDTH - 1] == 1'b1 && addr_bus[ADDR_BUS_WIDTH - 2:4] == 0)
			begin
				if(data_wen == 1'b1)
				begin
					vga_control_registers[addr_bus[3:0]] <= data_bus;
					mux_sel <= 1'b0;
				end
				else
				begin
					data_bus_out <= vga_control_registers[addr_bus[3:0]];
					mux_sel <= 1'b1;
				end
			end
			else
			begin
				mux_sel <= 0;
			end
		end
	end

	//Assign registers to the output
	//TIMR0
	assign control_reg_out[DATA_WIDTH*1 - 1:DATA_WIDTH*0] = vga_control_registers[0];
	//TIMR1
	assign control_reg_out[DATA_WIDTH*2 - 1:DATA_WIDTH*1] = vga_control_registers[1];
	//TIMR2
	assign control_reg_out[DATA_WIDTH*3 - 1:DATA_WIDTH*2] = vga_control_registers[2];
	//TIMR3
	assign control_reg_out[DATA_WIDTH*4 - 1:DATA_WIDTH*3] = vga_control_registers[3];
	//TIMR4
	assign control_reg_out[DATA_WIDTH*5 - 1:DATA_WIDTH*4] = vga_control_registers[4];
	//TIMR5
	assign control_reg_out[DATA_WIDTH*6 - 1:DATA_WIDTH*5] = vga_control_registers[5];
	//TIMR6
	assign control_reg_out[DATA_WIDTH*7 - 1:DATA_WIDTH*6] = vga_control_registers[6];
	//TIMR7
	assign control_reg_out[DATA_WIDTH*8 - 1:DATA_WIDTH*7] = vga_control_registers[7];
	//TIMR8
	assign control_reg_out[DATA_WIDTH*9 - 1:DATA_WIDTH*8] = vga_control_registers[8];
	//TIMR9
	assign control_reg_out[DATA_WIDTH*10 - 1:DATA_WIDTH*9] = vga_control_registers[9];
	//VGACR0
	assign control_reg_out[DATA_WIDTH*11 - 1:DATA_WIDTH*10] = vga_control_registers[10];

// the "macro" to dump signals
`ifdef COCOTB_SIM
initial begin
  $dumpfile ("vga_control_registers.vcd");
  $dumpvars (0,vga_control_registers);
  #1;
end
`endif
endmodule
