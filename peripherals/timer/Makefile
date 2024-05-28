TOPLEVEL_LANG ?= verilog
WAVES=1
GUI=1

ifeq ($(TOPLEVEL_LANG),verilog)
	VERILOG_SOURCES = $(shell pwd)/timer.v
endif

MODULE = timer_tb
TOPLEVEL = timer
include $(shell cocotb-config --makefiles)/Makefile.sim
