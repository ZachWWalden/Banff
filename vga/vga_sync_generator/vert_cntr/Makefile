TOPLEVEL_LANG ?= verilog
WAVES=1
GUI=1

ifeq ($(TOPLEVEL_LANG),verilog)
	VERILOG_SOURCES = $(shell pwd)/CHANGE.v
endif

MODULE = CHANGE_tb
TOPLEVEL = CHANGE
include $(shell cocotb-config --makefiles)/Makefile.sim
