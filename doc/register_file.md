# 📘 Register File – Documentation

## 1. Overview

The **Register File** is a small, fast storage block inside the CPU that holds operands and results for instructions.

In RISC-V:

* There are **32 general-purpose registers**
* Each register is **32 bits wide**
* Registers are named **x0 – x31**

---

## 2. Role in the Processor

The Register File:

* Provides **two source operands** (`rs1`, `rs2`)
* Accepts **one destination register** (`rd`)
* Writes results from:

  * ALU
  * Data Memory
* Supplies operands to the ALU in the **same cycle**

---

## 3. RISC-V Register Set

| Register | Name    | Description               |
| -------- | ------- | ------------------------- |
| x0       | zero    | Always 0                  |
| x1–x31   | general | General-purpose registers |

> **x0 is hard-wired to zero**
> Writes to x0 are ignored.

---

## 4. Register File Interface

### Module Declaration

```verilog
module register_file (
    input clk,
    input RegWrite,
    input [4:0] rs1, rs2, rd,
    input [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2
);
```

---

## 5. Why Registers Use 5-bit Addresses?

```verilog
input [4:0] rs1, rs2, rd;
```

### Reason:

* Total registers = **32**
* `2⁵ = 32`
* Each register index fits in **5 bits**

---

## 6. Register Index Extraction from Instruction

| Field | Bits      |
| ----- | --------- |
| rs1   | `[19:15]` |
| rs2   | `[24:20]` |
| rd    | `[11:7]`  |

Example:

```assembly
add x3, x1, x2
```

| Field | Value |
| ----- | ----- |
| rs1   | 1     |
| rs2   | 2     |
| rd    | 3     |

---

## 7. Internal Register Storage

```verilog
reg [31:0] regs [0:31];
```

* 32 registers
* Each 32 bits wide
* Indexed by register number

---

## 8. Read Operation (Combinational)

```verilog
assign read_data1 = (rs1 == 0) ? 0 : regs[rs1];
assign read_data2 = (rs2 == 0) ? 0 : regs[rs2];
```

### Characteristics:

* No clock required
* Data available immediately
* x0 always returns 0

---

## 9. Write Operation (Sequential)

```verilog
always @(posedge clk) begin
    if (RegWrite && rd != 0)
        regs[rd] <= write_data;
end
```

### Characteristics:

* Happens on **clock edge**
* Controlled by `RegWrite`
* Writes to `x0` are blocked

---

## 10. Why Read is Combinational and Write is Clocked?

| Operation | Type          | Reason                  |
| --------- | ------------- | ----------------------- |
| Read      | Combinational | Fast operand access     |
| Write     | Sequential    | Prevent race conditions |

This matches standard RISC-V register file design.

---

## 11. Write-Back Data Selection

The data written comes from:

```verilog
MemToReg ? mem_data : alu_result
```

| Instruction | Source      |
| ----------- | ----------- |
| ADD / SUB   | ALU         |
| LW          | Data Memory |

---

## 12. Timing in Single-Cycle CPU

```
Instruction Decode
   ↓
Register Read (same cycle)
   ↓
ALU Execution
   ↓
Write Back (clock edge)
```

All in **one clock cycle**.

---

## 13. Full Verilog Implementation

```verilog
module register_file (
    input clk,
    input RegWrite,
    input [4:0] rs1, rs2, rd,
    input [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2
);
    reg [31:0] regs [0:31];

    assign read_data1 = (rs1 == 0) ? 0 : regs[rs1];
    assign read_data2 = (rs2 == 0) ? 0 : regs[rs2];

    always @(posedge clk) begin
        if (RegWrite && rd != 0)
            regs[rd] <= write_data;
    end
endmodule
```

---

## 14. Limitations

* No reset initialization
* No register forwarding
* No hazard handling
* No multi-write support

---

## 15. Possible Enhancements

* Initialize registers on reset
* Add debug read ports
* Support multiple write ports
* Add pipeline forwarding logic

---

## 16. Summary

> The Register File provides fast, dual-read and single-write access to the CPU’s registers, enabling efficient operand access and result storage in a single-cycle RISC-V processor.

