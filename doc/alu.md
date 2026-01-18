# 📘 ALU (Arithmetic Logic Unit) – Documentation

## 1. Overview

The **ALU (Arithmetic Logic Unit)** is a core component of the CPU responsible for performing **arithmetic and logic operations** on 32-bit operands.

In the Mini RISC-V CPU, the ALU supports basic operations like:

* Addition (`ADD`)
* Subtraction (`SUB`)
* AND
* OR

The exact operation is determined by the **ALU Control Unit**.

---

## 2. Role in the Processor

The ALU performs:

1. **Arithmetic operations**

   * Addition, subtraction, and potentially multiplication/division
2. **Logic operations**

   * AND, OR, XOR
3. **Comparison for branching**

   * Zero detection (`rs1 - rs2`) for BEQ
4. **Operand combination with immediate values**

   * Used in I-type instructions

---

## 3. ALU Interface

### Module Declaration

```verilog
module alu (
    input [31:0] A,      // Operand 1
    input [31:0] B,      // Operand 2
    input [3:0] ALUCtrl, // ALU operation code
    output reg [31:0] Result, // ALU output
    output Zero          // Zero flag for branch
);
```

---

## 4. Signal Description

| Signal    | Width | Direction | Description                                  |
| --------- | ----- | --------- | -------------------------------------------- |
| `A`       | 32    | Input     | First operand (from rs1)                     |
| `B`       | 32    | Input     | Second operand (from rs2 or immediate)       |
| `ALUCtrl` | 4     | Input     | Operation selector from ALU Control          |
| `Result`  | 32    | Output    | Computed result                              |
| `Zero`    | 1     | Output    | Flag = 1 if Result == 0 (used for branching) |

---

## 5. Supported Operations

| ALUCtrl | Operation | Description                               |
| ------- | --------- | ----------------------------------------- |
| 4'b0010 | ADD       | Adds A + B (used for ADD, ADDI, LW, SW)   |
| 4'b0110 | SUB       | Subtracts A - B (used for BEQ comparison) |
| 4'b0000 | AND       | Bitwise AND                               |
| 4'b0001 | OR        | Bitwise OR                                |

> Additional ALUCtrl codes can be added to support SLT, XOR, SLL, SRL, etc.

---

## 6. ALU Implementation

### Verilog Code

```verilog
module alu (
    input [31:0] A, B,
    input [3:0] ALUCtrl,
    output reg [31:0] Result,
    output Zero
);
    always @(*) begin
        case (ALUCtrl)
            4'b0010: Result = A + B; // ADD
            4'b0110: Result = A - B; // SUB
            4'b0000: Result = A & B; // AND
            4'b0001: Result = A | B; // OR
            default: Result = 0;
        endcase
    end

    assign Zero = (Result == 0); // Used for branch comparison
endmodule
```

---

## 7. How ALU Works in CPU Datapath

```
reg_data1 → A
reg_data2 / immediate → B
ALUCtrl → select operation
Result → write-back or memory address
Zero → branch decision
```

### Example:

* **ADD Instruction:**
  ALUCtrl = `0010` → Result = `rs1 + rs2` → write-back to rd
* **BEQ Instruction:**
  ALUCtrl = `0110` → Result = `rs1 - rs2` → Zero = 1 if equal → branch taken

---

## 8. Zero Flag

* **Purpose:** Detect equality between operands
* **Usage:** Branch instructions (`BEQ`)

```verilog
assign pc_next = (Branch && Zero) ? pc + imm : pc + 4;
```

---

## 9. Timing Characteristics

| Property | Value                         |
| -------- | ----------------------------- |
| Type     | Combinational                 |
| Inputs   | Operand A, Operand B, ALUCtrl |
| Outputs  | Result, Zero                  |
| Latency  | 0 cycles (instant)            |
| Usage    | Single-cycle CPU              |

---

## 10. Limitations

* Only basic R-type and I-type operations supported
* No shift, SLT, XOR, division
* Single-cycle design → no pipelined operations
* Fixed 32-bit width

---

## 11. Future Extensions

* Add operations: `SLT`, `SLL`, `SRL`, `SRA`, `XOR`
* Support for multiplication/division
* Parameterized bit-width ALU (support 64-bit RV64I)
* Pipeline-ready ALU for multi-cycle designs

---

## 12. Summary

> The ALU performs arithmetic and logic operations required by RISC-V instructions.
> Together with ALU Control, it forms the **computational core** of the CPU, providing results to registers, memory, or branch logic in a single cycle.

