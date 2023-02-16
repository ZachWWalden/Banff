TOPLEVEL_LANG ?= verilog
WAVES=1
GUI=1

ifeq ($(TOPLEVEL_LANG),verilog)
	VERILOG_SOURCES = $(shell pwd)/<++>.v
endif

MODULE = <++>_tb
TOPLEVEL = <++>
include $(shell cocotb-config --makefiles)/Makefile.sim
