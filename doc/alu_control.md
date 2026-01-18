# 📘 ALU Control – Documentation

## 1. Overview

The **ALU Control Unit** is a combinational logic block that determines the **exact operation** the ALU should perform based on:

* Instruction type
* Instruction fields (`funct3`, `funct7`)
* High-level ALU operation (`ALUOp`) from the Control Unit

It acts as an **interface between the Control Unit and the ALU**, translating **generic ALU commands → specific ALU operations**.

---

## 2. Why ALU Control is Needed

* Control Unit only provides **2-bit ALUOp** (high-level operation)
* ALU needs **exact function code** to execute:

  * ADD, SUB, AND, OR
* ALU Control decodes instruction fields to **ALUCtrl** signals

---

## 3. ALU Control Interface

### Module Declaration

```verilog
module alu_control (
    input [1:0] ALUOp,
    input [2:0] funct3,
    input funct7,
    output reg [3:0] ALUCtrl
);
```

---

## 4. Signal Description

| Signal    | Width | Direction | Description                                |
| --------- | ----- | --------- | ------------------------------------------ |
| `ALUOp`   | 2     | Input     | High-level ALU operation from Control Unit |
| `funct3`  | 3     | Input     | Instruction function field                 |
| `funct7`  | 1     | Input     | Instruction function field bit 30          |
| `ALUCtrl` | 4     | Output    | Exact operation to perform in ALU          |

---

## 5. How ALU Control Works

* Takes **ALUOp** from control unit
* Reads **funct3** and **funct7** fields from instruction
* Produces **ALUCtrl** code understood by the ALU

---

## 6. ALU Operations Mapping

### Example Mapping for R-type Instructions

| Instruction | funct7 | funct3 | ALUCtrl (4-bit) | Operation |
| ----------- | ------ | ------ | --------------- | --------- |
| ADD         | 0      | 000    | 0010            | A + B     |
| SUB         | 1      | 000    | 0110            | A - B     |
| AND         | 0      | 111    | 0000            | A & B     |
| OR          | 0      | 110    | 0001            | A | B     |

> 4-bit `ALUCtrl` is used as **ALU select code**.

---

### Example Mapping for I-Type / Load-Store

| Instruction | ALUOp | ALUCtrl | Operation                 |
| ----------- | ----- | ------- | ------------------------- |
| LW / SW     | 00    | 0010    | ADD (address computation) |
| BEQ         | 01    | 0110    | SUB (comparison)          |

---

## 7. ALU Control Implementation

### Verilog Code

```verilog
module alu_control (
    input [1:0] ALUOp,
    input [2:0] funct3,
    input funct7,
    output reg [3:0] ALUCtrl
);
    always @(*) begin
        case(ALUOp)
            2'b00: ALUCtrl = 4'b0010; // LW / SW → ADD
            2'b01: ALUCtrl = 4'b0110; // BEQ → SUB
            2'b10: begin              // R-type
                case(funct3)
                    3'b000: ALUCtrl = (funct7) ? 4'b0110 : 4'b0010; // SUB / ADD
                    3'b111: ALUCtrl = 4'b0000; // AND
                    3'b110: ALUCtrl = 4'b0001; // OR
                    default: ALUCtrl = 4'b0000;
                endcase
            end
            default: ALUCtrl = 4'b0000;
        endcase
    end
endmodule
```

---

## 8. How ALU Control is Connected in CPU

```
Control Unit → ALUOp → ALU Control → ALU → ALU Result
```

1. Control Unit determines **general operation type**
2. ALU Control reads **instruction fields**
3. Generates **exact 4-bit ALUCtrl**
4. ALU performs arithmetic/logic operation

---

## 9. Design Characteristics

| Property | Value                 |
| -------- | --------------------- |
| Type     | Combinational         |
| Inputs   | ALUOp, funct3, funct7 |
| Outputs  | ALUCtrl (4-bit)       |
| Usage    | Single-cycle RISC-V   |

---

## 10. Limitations

* Only supports **subset of RISC-V ALU operations**
* No shift, XOR, SLT instructions (can be added)
* Does not support multi-cycle or pipelined ALU yet

---

## 11. Possible Extensions

* Add support for:

  * XOR, SLT, SRA, SRL, SLL
  * I-type arithmetic instructions
  * Immediate arithmetic instructions
* Pipeline-compatible ALU control

---

## 12. Summary

> The ALU Control unit converts the high-level ALUOp from the Control Unit into a **precise 4-bit signal** that instructs the ALU which arithmetic or logic operation to perform.
> It allows modular separation between instruction decoding and ALU execution.

