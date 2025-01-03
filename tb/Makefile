TOPLEVEL_LANG ?= verilog

TOPLEVEL := ankka_v
MODULE   := ankka_v_test
VERILOG_SOURCES += ../src/ankka_v.sv
VERILOG_SOURCES += ../src/instruction_fetch_unit.sv
VERILOG_SOURCES += ../src/instruction_decode_unit.sv
VERILOG_INCLUDE_DIRS += ../src/include/

include $(shell cocotb-config --makefiles)/Makefile.sim
