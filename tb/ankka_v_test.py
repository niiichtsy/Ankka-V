# This file is public domain, it can be freely copied without restrictions.
import os
import random
import sys
from pathlib import Path

import cocotb
from cocotb.runner import get_runner
from cocotb.triggers import Timer, RisingEdge
from cocotb.clock import Clock

CLK_PERIOD = 10


async def setup_clocks(dut):
    clk = Clock(dut.clk, CLK_PERIOD, units="ns")
    cocotb.start_soon(clk.start())


async def reset_dut(dut):
    dut.resetn.value = 1
    await Timer(CLK_PERIOD * 2, units="ns")
    dut.resetn.value = 0
    await Timer(CLK_PERIOD * 2, units="ns")
    dut.resetn.value = 1
    await Timer(CLK_PERIOD * 2, units="ns")


@cocotb.test()
async def ankka_v_test(dut):
    await setup_clocks(dut)
    await Timer(CLK_PERIOD * 4, units="ns")
    await reset_dut(dut)
    await Timer(CLK_PERIOD * 10, units="ns")

    instructions = [
        0b00000000000000000000000010110011,
        0b00000000000100001000000010010011,
        0b00000000000000001010000100000011,
        0b0000000000100010010000000100011,
        0b00000000000100000000000001110011,
    ]

    for instruction in instructions:
        dut.instruction_in.value = instruction
        await RisingEdge(dut.clk)
        dut.read.value = 1
        await RisingEdge(dut.clk)
        dut.read.value = 0
        await Timer(CLK_PERIOD * 10, units="ns")

    assert dut.resetn.value == 1


def ankka_v_test_runner():
    sim = os.getenv("SIM", "icarus")

    proj_path = Path(__file__).resolve().parent.parent
    # equivalent to setting the PYTHONPATH environment variable
    sys.path.append(str(proj_path / "model"))

    verilog_sources = [proj_path / "src" / "ankka_v.sv"]

    # equivalent to setting the PYTHONPATH environment variable
    sys.path.append(str(proj_path / "tests"))

    runner = get_runner(sim)
    runner.build(
        verilog_sources=verilog_sources,
        hdl_toplevel="ankka_v",
        always=True,
    )
    runner.test(
        hdl_toplevel="ankka_v",
        test_module="ankka_v_test",
    )


if __name__ == "__main__":
    ankka_v_test_runner()
