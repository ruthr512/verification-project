# Hardware Validation Platform

A modular hardware verification and validation project for digital designs.

## Current DUT

The current Design Under Test (DUT) is an 8-bit FIFO.

The project includes:
- SystemVerilog RTL
- Cocotb-based Python verification
- Directed tests
- Simulation and waveform analysis
- Automated PASS/FAIL checking

## Project Structure

```text
hardware_validation/
├── docs/          # Design specifications and documentation
├── framework/     # Test and simulation infrastructure
├── rtl/           # SystemVerilog RTL designs
├── tests/         # Testbenches and Cocotb tests
├── reports/       # Generated reports
└── results/       # Generated test results