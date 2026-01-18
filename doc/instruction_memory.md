# 📘 Instruction Memory – Documentation

## 1. Overview

The **Instruction Memory** stores the program instructions that the CPU executes.
In this Mini RISC-V processor, it is implemented as a **read-only memory** that outputs a **32-bit instruction** based on the current **Program Counter (PC)** value.

---

## 2. Role in the Processor

Instruction Memory performs the following functions:

* Stores machine instructions
* Receives address from the **Program Counter**
* Outputs the corresponding **32-bit instruction**
* Supports **word-aligned instruction fetch**

---

## 3. Instruction Fetch Flow

```
PC → Instruction Memory → Instruction Register → Decode
```

1. PC provides an address
2. Instruction Memory selects the instruction
3. Instruction is sent to:

   * Control Unit
   * Register File
   * Immediate Generator

---

## 4. Memory Organization

```verilog
reg [31:0] mem [0:255];
```

### Explanation:

* Each memory location stores **one 32-bit instruction**
* Total instructions: **256**
* Total memory size:

  ```
  256 × 4 bytes = 1024 bytes (1 KB)
  ```

---

## 5. Addressing Logic

### Why `pc[31:2]`?

```verilog
assign instruction = mem[pc[31:2]];
```

#### Reason:

* RISC-V instructions are **32-bit (4 bytes)**
* Instructions are **word-aligned**
* Lower 2 bits of PC are always `00`
* Dividing PC by 4 gives the instruction index

| PC Value | Binary | Index |
| -------- | ------ | ----- |
| 0x00     | 000000 | 0     |
| 0x04     | 000100 | 1     |
| 0x08     | 001000 | 2     |

---

## 6. Instruction Memory Module

### Verilog Implementation

```verilog
module instruction_memory (
    input [31:0] pc,
    output [31:0] instruction
);
    reg [31:0] mem [0:255];

    assign instruction = mem[pc[31:2]];
endmodule
```

---

## 7. Signal Description

| Signal Name   | Width | Direction | Description                    |
| ------------- | ----- | --------- | ------------------------------ |
| `pc`          | 32    | Input     | Address of current instruction |
| `instruction` | 32    | Output    | Fetched instruction            |

---

## 8. Read Operation

* Read is **combinational**
* Instruction output changes **immediately** with PC
* No clock required for read

This matches **single-cycle processor behavior**.

---

## 9. Instruction Format Support

Fetched instruction contains fields used by:

| Field  | Bits      |
| ------ | --------- |
| Opcode | `[6:0]`   |
| rd     | `[11:7]`  |
| funct3 | `[14:12]` |
| rs1    | `[19:15]` |
| rs2    | `[24:20]` |
| funct7 | `[31:25]` |

---

## 10. Initialization (Optional)

Instruction memory is usually initialized using a hex file:

```verilog
initial begin
    $readmemh("program.hex", mem);
end
```

* Loads compiled RISC-V instructions
* Enables simulation of real programs

---

## 11. Debugging Support

For simulation, instructions can be displayed:

```verilog
initial begin
    integer i;
    for (i = 0; i < 10; i = i + 1)
        $display("Instruction %0d = %h", i, mem[i]);
end
```

---

## 12. Design Characteristics

| Feature           | Value          |
| ----------------- | -------------- |
| Architecture      | Single-cycle   |
| Access Type       | Read-only      |
| Instruction Width | 32-bit         |
| Alignment         | Word-aligned   |
| Memory Type       | Register array |
| ISA               | RV32I          |

---

## 13. Limitations

* Fixed size (256 instructions)
* No instruction cache
* No protection or privilege modes
* No self-modifying code support

---

## 14. Future Enhancements

* Increase instruction memory size
* Add instruction cache
* Support compressed (16-bit) instructions
* Add ROM initialization via ELF loader

---

## 15. Summary

> Instruction Memory is responsible for delivering the correct instruction to the CPU every cycle.
> By using word-aligned addressing and combinational reads, it enables fast and simple instruction fetch in a single-cycle RISC-V processor.


