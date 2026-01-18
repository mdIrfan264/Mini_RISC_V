# 📘 Control Unit – Documentation

## 1. Overview

The **Control Unit (CU)** is the brain of the processor’s datapath.
It **decodes the instruction opcode** and generates control signals that guide how data flows through the CPU during execution.

In a **single-cycle RISC-V processor**, the Control Unit is **combinational** and produces all control signals in **one clock cycle**.

---

## 2. Role in the Processor

The Control Unit:

* Decodes the **opcode** (`instruction[6:0]`)
* Determines the **instruction type**
* Enables/disables:

  * Register writes
  * Memory reads/writes
  * Branching
* Selects:

  * ALU operation type
  * ALU operand source
  * Write-back data source

---

## 3. Why Opcode is 7 Bits?

```verilog
instruction[6:0]
```

### RISC-V Design Reason:

* RISC-V uses **fixed 32-bit instructions**
* Opcode uniquely identifies the **instruction format**
* 7 bits allow **128 instruction classes**
* Same opcode = same instruction format

| Opcode    | Instruction Type |
| --------- | ---------------- |
| `0110011` | R-type           |
| `0000011` | Load (LW)        |
| `0100011` | Store (SW)       |
| `1100011` | Branch (BEQ)     |
| `0010011` | I-type (ADDI)    |
| `1101111` | J-type (JAL)     |
| `0110111` | U-type (LUI)     |

---

## 4. Control Unit Interface

### Module Declaration

```verilog
module control_unit (
    input  [6:0] instruction,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg MemToReg,
    output reg ALUSrc,
    output reg Branch,
    output reg [1:0] ALUOp
);
```

---

## 5. Control Signals Explained

| Signal     | Purpose                                |
| ---------- | -------------------------------------- |
| `RegWrite` | Enables writing to register file       |
| `MemRead`  | Enables reading from data memory       |
| `MemWrite` | Enables writing to data memory         |
| `MemToReg` | Selects memory data for write-back     |
| `ALUSrc`   | Selects ALU operand (reg or immediate) |
| `Branch`   | Enables branch decision                |
| `ALUOp`    | High-level ALU operation selector      |

---

## 6. Why ALUOp is Only 2 Bits?

The Control Unit does **not** generate exact ALU control signals.

Instead:

* CU → **ALUOp** (instruction class)
* ALU Control → **ALUCtrl** (exact operation)

| ALUOp | Meaning                            |
| ----- | ---------------------------------- |
| `00`  | Load / Store (ADD)                 |
| `01`  | Branch (SUB)                       |
| `10`  | R-type / I-type (use funct fields) |

This simplifies hardware design.

---

## 7. Control Logic Implementation

### Verilog Code

```verilog
always @(*) begin
    case (instruction)
        7'b0110011: begin // R-type
            RegWrite=1; MemRead=0; MemWrite=0;
            MemToReg=0; ALUSrc=0; Branch=0;
            ALUOp=2'b10;
        end

        7'b0000011: begin // LW
            RegWrite=1; MemRead=1; MemWrite=0;
            MemToReg=1; ALUSrc=1; Branch=0;
            ALUOp=2'b00;
        end

        7'b0100011: begin // SW
            RegWrite=0; MemRead=0; MemWrite=1;
            MemToReg=0; ALUSrc=1; Branch=0;
            ALUOp=2'b00;
        end

        7'b1100011: begin // BEQ
            RegWrite=0; MemRead=0; MemWrite=0;
            MemToReg=0; ALUSrc=0; Branch=1;
            ALUOp=2'b01;
        end

        default: begin
            RegWrite=0; MemRead=0; MemWrite=0;
            MemToReg=0; ALUSrc=0; Branch=0;
            ALUOp=2'b00;
        end
    endcase
end
```

---

## 8. Control Signal Behavior per Instruction

| Instruction | RegWrite | MemRead | MemWrite | MemToReg | ALUSrc | Branch | ALUOp |
| ----------- | -------- | ------- | -------- | -------- | ------ | ------ | ----- |
| ADD         | 1        | 0       | 0        | 0        | 0      | 0      | 10    |
| SUB         | 1        | 0       | 0        | 0        | 0      | 0      | 10    |
| LW          | 1        | 1       | 0        | 1        | 1      | 0      | 00    |
| SW          | 0        | 0       | 1        | X        | 1      | 0      | 00    |
| BEQ         | 0        | 0       | 0        | X        | 0      | 1      | 01    |

---

## 9. Branch Handling

For `BEQ`:

* ALU performs subtraction (`rs1 - rs2`)
* Zero flag indicates equality
* Branch target calculated using immediate
* PC updated if:

```verilog
Branch && Zero
```

---

## 10. Why Control Unit is Combinational

```verilog
always @(*)
```

### Reason:

* Single-cycle CPU
* Instruction must complete in one clock
* No pipeline or state storage

---

## 11. Limitations

* Supports only a subset of RV32I
* No JAL, LUI implemented yet (can be extended)
* No hazard detection
* No pipeline control

---

## 12. How to Extend Control Unit

Add support for:

### ADDI

```verilog
7'b0010011: begin
    RegWrite=1; MemRead=0; MemWrite=0;
    MemToReg=0; ALUSrc=1; Branch=0;
    ALUOp=2'b10;
end
```

### JAL

```verilog
7'b1101111: begin
    RegWrite=1;
    Branch=1;
end
```

---

## 13. Summary

> The Control Unit decodes the opcode and generates control signals that coordinate the entire datapath in a single cycle.
> Its clean separation from ALU control keeps the design modular, simple, and scalable.

