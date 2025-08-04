## 🧠 What Is a Single-Core RISC-V Processor?

It is a **minimal processor** that supports the **RISC-V instruction set architecture (ISA)**, and can execute basic operations like:

* Arithmetic (e.g., `add`, `sub`)
* Logic (`and`, `or`)
* Memory access (`lw`, `sw`)
* Control flow (`beq`, `jal`)

Since it’s **single-core and single-cycle**, it:

* Has **only one processing unit** (no multi-core).
* Completes **one full instruction per clock cycle**.

---

## 🔩 Key Components (Hardware Modules)

### 1. **Program Counter (PC)**

* Keeps track of which instruction to execute.
* Increments by 4 each cycle (since each instruction is 4 bytes).

### 2. **Instruction Memory**

* Stores machine instructions.
* Delivers current instruction based on PC.

### 3. **Control Unit**

* Decodes the instruction.
* Generates control signals to direct other blocks (e.g., ALU, memory).

### 4. **Register File**

* 32 general-purpose registers (x0 to x31).
* Can read 2 registers and write to 1 in each cycle.

### 5. **Immediate Generator**

* Extracts and sign-extends immediate values from instructions.

### 6. **ALU (Arithmetic Logic Unit)**

* Performs arithmetic/logic operations (`add`, `sub`, etc.).
* Outputs result to be written back to the register.

### 7. **Data Memory**

* Accessed during load (`lw`) and store (`sw`) instructions.
* Read/write controlled by control unit.

### 8. **Writeback Path**

* Selects whether ALU result or memory data goes back to the register.

---

## 🕹️ Single-Cycle Execution Flow

In a single clock cycle, the processor does:

```text
Fetch ➝ Decode ➝ Execute ➝ Memory ➝ Writeback
```

All **within one clock pulse**.

> Example: `add x1, x2, x3`
> → Reads x2 & x3 → adds them → stores result in x1
> → All done in 1 cycle.

---

## 📦 Optional Modules (for completeness)

* **Branch Unit**: For handling instructions like `beq`, `jal`, `jalr`
* **MUXes**: For choosing between sources (e.g., immediate vs register)
* **Sign Extender**: For 12/20-bit immediate values

---

## ✅ Benefits of This Design for You

| Feature             | Why It Matters                                        |
| ------------------- | ----------------------------------------------------- |
| Simplicity          | Easy to design and simulate as a student project      |
| Real Verilog Coding | Helps you learn RTL (Register Transfer Level) design  |
| ML Data Source      | Will generate logs for your AI-based clock gating     |
| Industry-Relevant   | RISC‑V is becoming widely adopted in academia & chips |

---

