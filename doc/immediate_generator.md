# 📘 Immediate Generator – Documentation

## 1. Overview

The **Immediate Generator** extracts and constructs **immediate values** from a 32-bit RISC-V instruction.

Because immediate fields are **split across different bit positions** depending on instruction type, the Immediate Generator:

* Rearranges bits
* Performs **sign extension**
* Outputs a **32-bit immediate value**

---

## 2. Why Immediate Generator is Needed

In RISC-V:

* Immediate values are **not stored contiguously**
* Different instruction formats place immediate bits differently
* ALU and PC logic always require **32-bit operands**

➡️ Immediate Generator converts **encoded immediate fields → usable 32-bit value**

---

## 3. Instructions Using Immediate Values

| Instruction Type | Example      | Usage                        |
| ---------------- | ------------ | ---------------------------- |
| I-Type           | `addi`, `lw` | ALU operand / address offset |
| S-Type           | `sw`         | Store address offset         |
| B-Type           | `beq`        | Branch target offset         |
| U-Type           | `lui`        | Upper immediate              |
| J-Type           | `jal`        | Jump target offset           |

---

## 4. Immediate Generator Interface

### Module Declaration

```verilog
module immediate_generator(
    input [31:0] instruction,
    output reg [31:0] imm
);
```

---

## 5. How Instruction Type is Identified

The Immediate Generator uses the **opcode**:

```verilog
instruction[6:0]
```

Each opcode corresponds to a specific instruction format and immediate layout.

---

## 6. Immediate Formats in RISC-V

### 🔹 I-Type (LW, ADDI)

```
| imm[11:0] | rs1 | funct3 | rd | opcode |
| 31   20   |     |        |    |        |
```

**Used for:**

* Load
* Immediate arithmetic

---

### 🔹 S-Type (SW)

```
| imm[11:5] | rs2 | rs1 | funct3 | imm[4:0] | opcode |
| 31   25   |     |     |        | 11   7   |
```

Immediate is **split** → must be reassembled.

---

### 🔹 B-Type (BEQ)

```
| imm[12] | imm[10:5] | rs2 | rs1 | funct3 | imm[4:1] | imm[11] | opcode |
```

* Branch offsets are **PC-relative**
* LSB is always `0` (2-byte alignment)

---

## 7. Sign Extension Explained

### Why Sign Extend?

* Immediate values may be **negative**
* RISC-V uses **two’s complement**
* Highest immediate bit (`instruction[31]`) is sign bit

Example:

```verilog
{{20{instruction[31]}}, instruction[31:20]}
```

➡️ Extends sign to 32 bits

---

## 8. Immediate Generator Implementation

### Verilog Code

```verilog
module immediate_generator(
    input [31:0] instruction,
    output reg [31:0] imm
);
    always @(*) begin
        case (instruction[6:0])

            7'b0000011: // I-Type (LW)
                imm = {{20{instruction[31]}}, instruction[31:20]};

            7'b0100011: // S-Type (SW)
                imm = {{20{instruction[31]}},
                       instruction[31:25],
                       instruction[11:7]};

            7'b1100011: // B-Type (BEQ)
                imm = {{19{instruction[31]}},
                       instruction[31],
                       instruction[7],
                       instruction[30:25],
                       instruction[11:8],
                       1'b0};

            default:
                imm = 32'b0;
        endcase
    end
endmodule
```

---

## 9. Immediate Generator Outputs per Instruction

| Instruction | Immediate Meaning     |
| ----------- | --------------------- |
| LW          | Memory address offset |
| SW          | Memory address offset |
| BEQ         | Branch offset         |
| ADDI        | ALU operand           |
| JAL         | Jump offset           |

---

## 10. Why Immediate is Used in Branch

> “Immediate is only sign extension, right?”

❌ **Not only sign extension**

For branch instructions:

* Immediate represents **PC offset**
* Used to compute:

```verilog
PC_next = PC + imm
```

This allows:

* Forward branches
* Backward loops

---

## 11. Why Branch Immediate Has `1'b0`

```verilog
... , 1'b0
```

### Reason:

* Instructions are **2-byte aligned**
* Branch target must be aligned
* LSB is always `0`

---

## 12. Timing Characteristics

| Property | Value         |
| -------- | ------------- |
| Type     | Combinational |
| Clock    | Not required  |
| Latency  | 0 cycles      |
| Usage    | Same cycle    |

Perfect for **single-cycle CPU**.

---

## 13. Limitations

* No support for:

  * `JAL`
  * `LUI`
  * `AUIPC`
* No compressed instruction support

---

## 14. Possible Extensions

Add:

### U-Type (LUI)

```verilog
7'b0110111:
    imm = {instruction[31:12], 12'b0};
```

### J-Type (JAL)

```verilog
7'b1101111:
    imm = {{11{instruction[31]}},
           instruction[31],
           instruction[19:12],
           instruction[20],
           instruction[30:21],
           1'b0};
```

---

## 15. Summary

> The Immediate Generator extracts, rearranges, and sign-extends immediate values so they can be used by the ALU and PC logic in a single-cycle RISC-V processor.

