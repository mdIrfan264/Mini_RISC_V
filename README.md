# 🧠 Mini RISC-V Processor (RV32I – Single Cycle)

## 📌 Project Overview

This project implements a **Mini RISC-V (RV32I) single-cycle processor** using **Verilog HDL**.
The design follows the standard **Fetch → Decode → Execute → Memory → Writeback** datapath and supports a subset of the RISC-V instruction set.

The goal of this project is to **understand processor architecture**, datapath design, and control logic by building a working CPU from scratch.

---

## 🏗️ Architecture Summary

* **ISA**: RISC-V RV32I (subset)
* **Design style**: Single-cycle CPU
* **Word size**: 32-bit
* **Memory model**: Word-addressed
* **Implementation language**: Verilog HDL

---

## 🧩 Supported Instructions

### ✅ R-Type Instructions

* `add`
* `sub`
* `and`
* `or`

### ✅ I-Type Instructions

* `lw`
* `addi` *(optional / extendable)*

### ✅ S-Type Instructions

* `sw`

### ✅ B-Type Instructions

* `beq`

> ⚠️ Instructions like `jal`, `lui`, `jalr` can be added as extensions.

---

## 🧱 Processor Blocks

### 1️⃣ Program Counter (PC)

* Holds the current instruction address
* Updated every clock cycle
* Supports:

  * `PC + 4`
  * `PC + immediate` (branch)

---

### 2️⃣ Instruction Memory

* Stores program instructions
* Word-aligned (`PC[31:2]`)
* Instruction width: 32-bit

---

### 3️⃣ Control Unit

* Decodes the **opcode (instruction[6:0])**
* Generates control signals:

  * `RegWrite`
  * `MemRead`
  * `MemWrite`
  * `MemToReg`
  * `ALUSrc`
  * `Branch`
  * `ALUOp`

---

### 4️⃣ Register File

* 32 general-purpose registers (`x0–x31`)
* Two read ports (`rs1`, `rs2`)
* One write port (`rd`)
* `x0` is always zero

---

### 5️⃣ Immediate Generator

* Extracts immediate values from instructions
* Rearranges and sign-extends them to 32 bits
* Supports:

  * I-type
  * S-type
  * B-type immediates

---

### 6️⃣ ALU Control

* Uses:

  * `ALUOp`
  * `funct3`
  * `funct7`
* Generates exact ALU operation control signals

---

### 7️⃣ ALU

* Performs arithmetic and logic operations
* Supports:

  * Add
  * Subtract
  * AND
  * OR
* Generates `Zero` flag for branch decisions

---

### 8️⃣ Data Memory

* Used for `lw` and `sw`
* Address calculated by ALU
* Word-aligned access

---

## 🔄 Instruction Flow (Single Cycle)

```
PC
 ↓
Instruction Memory
 ↓
Decode (Control + Register File + Immediate Generator)
 ↓
Execute (ALU)
 ↓
Memory Access
 ↓
Write Back
```

Each instruction completes **in one clock cycle**.

---

## 🧪 Simulation

* Instruction memory can be initialized using:

  ```verilog
  $readmemh("program.hex", mem);
  ```
* `$display` statements are used for debugging in simulation
* Testbench drives:

  * Clock
  * Reset

---

## 📁 Project Structure (Recommended)

```
Mini_RISC_V/
├── src/
│   ├── pc.v
│   ├── instruction_memory.v
│   ├── control_unit.v
│   ├── register_file.v
│   ├── immediate_generator.v
│   ├── alu_control.v
│   ├── alu.v
│   ├── data_memory.v
│   └── riscv_cpu.v
├── tb/
│   └── tb_riscv_cpu.v
├── program.hex
├── README.md
```

---

## 🚀 Future Enhancements

* Add `jal`, `jalr`, `lui`
* Pipeline implementation
* Hazard detection & forwarding
* CSR support
* UART / LED debugging output on FPGA

---

## 📚 Learning Outcomes

* Understanding RISC-V instruction formats
* Datapath and control unit design
* Immediate generation and sign extension
* ALU control logic
* Memory addressing and alignment
* FPGA synthesis considerations

---

## 👤 Author

**MD Irfan**
Mini Project – RISC-V Processor Design

---

## 📜 License

This project is for **educational purposes**.
