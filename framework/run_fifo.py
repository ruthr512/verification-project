from pathlib import Path

from cocotb_tools.runner import get_runner


PROJECT_ROOT = Path(__file__).resolve().parents[1]

runner = get_runner("icarus")

runner.build(
    hdl_toplevel="fifo",
    sources=[
        PROJECT_ROOT / "rtl" / "fifo.sv",
    ],
)

runner.test(
    hdl_toplevel="fifo",
    test_module="test_fifo_basic",
    test_dir=PROJECT_ROOT / "tests",
)