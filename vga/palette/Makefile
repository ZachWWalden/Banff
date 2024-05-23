TOPLEVEL_LANG ?= verilog
WAVES=1
GUI=1

ifeq ($(TOPLEVEL_LANG),verilog)
	VERILOG_SOURCES = $(shell pwd)/palette.v
endif

MODULE = palette_tb
TOPLEVEL = palette
include $(shell cocotb-config --makefiles)/Makefile.sim
