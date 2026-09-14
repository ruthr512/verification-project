# FIFO Specification

## Parameters

DATA_WIDTH:8
DEPTH:4

## Inputs

clk
reset
write_en
read_en
data_in

## Outputs

data_out
full
empty

## Behavior

Write:
    When write_en = 1 and the FIFO is not full, data_in is written to the FIFO on the rising edge of clk.
    After the write, the write pointer advances to the next location.
    If the FIFO becomes full, full is asserted.
    If the FIFO is full, the write operation is ignored.
Read:
    When read_en = 1 and the FIFO is not empty, the data pointed to by the read pointer is transferred to data_out on the rising edge of clk.
    After the read, the read pointer advances to the next location.
    If the FIFO becomes empty, empty is asserted.
    If the FIFO is empty, the read operation is ignored.
Reset:
    When reset is asserted, the FIFO returns to its initial empty state.
    The read pointer and write pointer are reset to the first location.
    empty is asserted and full is deasserted.
Full:
    When full = 1, the FIFO has no free locations available for writing.
    Write operations are ignored while the FIFO is full.
    After a successful read from a full FIFO, a free location becomes available and full is deasserted.
Empty:
    When empty = 1, the FIFO contains no valid data and read operations are ignored.
    A write operation can add data to the FIFO when space is available.
    After a successful write to an empty FIFO, empty is deasserted.