import cocotb

from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ReadOnly


@cocotb.test()
async def test_fifo_basic(dut):

    # Start the clock
    cocotb.start_soon(
        Clock(dut.clk, 10, unit="ns").start()
    )

    # --------------------------------------------------
    # Initial values
    # --------------------------------------------------

    dut.reset.value = 1
    dut.write_en.value = 0
    dut.read_en.value = 0
    dut.data_in.value = 0

    # --------------------------------------------------
    # RESET
    # --------------------------------------------------

    await RisingEdge(dut.clk)

    dut.reset.value = 0

    # --------------------------------------------------
    # WRITE
    # --------------------------------------------------

    dut.data_in.value = 0xAA
    dut.write_en.value = 1

    await RisingEdge(dut.clk)

    dut.write_en.value = 0

    # --------------------------------------------------
    # READ
    # --------------------------------------------------

    dut.read_en.value = 1

    await RisingEdge(dut.clk)

    dut.read_en.value = 0

    # Wait until the DUT has finished updating
    await ReadOnly()

    # --------------------------------------------------
    # CHECK
    # --------------------------------------------------

    assert dut.data_out.value == 0xAA