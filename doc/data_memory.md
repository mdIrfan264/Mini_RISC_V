# 📘 Data Memory – Documentation

## 1. Overview

**Data Memory** (DM) is the block in the CPU responsible for **reading and writing data** during program execution.

In the Mini RISC-V processor:

* It stores **32-bit words**
* Supports **load (read)** and **store (write)** instructions
* Operates in **single-cycle mode**
* Indexed by the **ALU result** (computed memory address)

---

## 2. Role in the Processor

Data Memory performs:

1. **Load operations** (`LW`): Reads a 32-bit word from memory and sends it to the **Register File**
2. **Store operations** (`SW`): Writes a 32-bit word from the **Register File** into memory
3. Provides memory for **stack, heap, and global variables** in real programs

---

## 3. Memory Organization

```verilog
reg [31:0] mem [0:255];
```

* 32-bit word per memory location
* 256 memory locations → **1 KB total**
* Word-aligned addressing
* Addressed using **ALU result divided by 4** (to convert byte address → word index)

---

## 4. Data Memory Interface

### Module Declaration

```verilog
module data_memory (
    input clk,
    input MemRead,
    input MemWrite,
    input [31:0] addr,
    input [31:0] write_data,
    output reg [31:0] read_data
);
```

---

## 5. Signal Description

| Signal       | Width | Direction | Description               |
| ------------ | ----- | --------- | ------------------------- |
| `clk`        | 1     | Input     | System clock              |
| `MemRead`    | 1     | Input     | Enable memory read        |
| `MemWrite`   | 1     | Input     | Enable memory write       |
| `addr`       | 32    | Input     | Memory address (from ALU) |
| `write_data` | 32    | Input     | Data to write to memory   |
| `read_data`  | 32    | Output    | Data read from memory     |

---

## 6. Read / Write Behavior

### Write Operation

```verilog
always @(posedge clk) begin
    if (MemWrite)
        mem[addr[31:2]] <= write_data;
end
```

* Happens on **clock edge**
* Controlled by `MemWrite` signal
* `addr[31:2]` converts byte address → word index
* Writing to memory only occurs if `MemWrite = 1`

---

### Read Operation

```verilog
always @(*) begin
    if (MemRead)
        read_data = mem[addr[31:2]];
    else
        read_data = 0;
end
```

* **Combinational read**
* `MemRead` = 1 → output current memory value
* `MemRead` = 0 → output 0

---

## 7. Word-Aligned Memory Access

* RISC-V uses **32-bit (4-byte) instructions and data words**
* Data addresses must be **multiple of 4**
* Therefore, the **lower 2 bits of addr are ignored**:

```verilog
mem[addr[31:2]]
```

---

## 8. Usage in CPU Datapath

```
ALU computes memory address → addr
Register File → write_data
MemRead/MemWrite → control unit
read_data → written back to Register File (if MemToReg = 1)
```

### Example:

* **LW x1, 0(x2)**:

  * ALU computes address = x2 + 0
  * MemRead = 1
  * read_data → written to x1

* **SW x3, 4(x4)**:

  * ALU computes address = x4 + 4
  * MemWrite = 1
  * write_data = x3

---

## 9. Timing Characteristics

| Property | Value                                            |
| -------- | ------------------------------------------------ |
| Type     | Mixed: sequential (write) + combinational (read) |
| Write    | Edge-triggered (posedge clk)                     |
| Read     | Combinational                                    |
| Latency  | 0 cycles for read, 1 clock for write             |

---

## 10. Limitations

* Only supports **word (32-bit) read/write**
* Fixed memory size (256 words)
* No byte/halfword access
* No memory protection
* No pipelining (single-cycle only)

---

## 11. Possible Extensions

* Support for **byte / half-word load/store** (LB, LH, SB, SH)
* Increase memory size
* Add **reset initialization**
* Implement **memory-mapped I/O**
* Support pipelined memory access in multi-cycle CPU

---

## 12. Summary

> The Data Memory module provides read and write access to a block of 32-bit words for load and store instructions.
> Combined with the ALU and Register File, it enables the CPU to manipulate memory data in a single clock cycle.


