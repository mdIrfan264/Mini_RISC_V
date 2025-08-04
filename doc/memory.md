## 🎯 **What is Instruction Memory?**

Imagine you're building a tiny CPU.

🧠 The CPU needs to **know what to do next** — like adding two numbers, or jumping somewhere.

So, it needs a **list of instructions** (your program).

👉 **That list lives in the *Instruction Memory*** — a box full of instructions.

---

## 🧱 Think of It Like a Book of Instructions

| Page Number (Address) | Instruction         |
| --------------------- | ------------------- |
| Page 0 (`PC=0x00`)    | `add x1, x2, x3`    |
| Page 1 (`PC=0x04`)    | `sub x4, x5, x6`    |
| Page 2 (`PC=0x08`)    | `beq x1, x4, label` |
| ...                   | ...                 |

Each "page" (instruction) is **4 bytes = 32 bits**, and they’re stored **in order**.

---

## 🔧 Your CPU Says:

> “Hey Instruction Memory, I’m at address 0. What should I do?”

📦 Instruction Memory responds:

> “Here’s the instruction at address 0 — `add x1, x2, x3`.”

---

## 💡 Key Point:

### ➕ You give **PC** as input

### 🏁 It gives the **instruction** at that address as output

---

## 🛠️ Inside Instruction Memory (What You Build in Verilog):

It's just a big list of instructions:

```verilog
reg [31:0] memory [0:255];
```

This is like saying:

> “I have 256 places to store 32-bit instructions.”

---

## ❓ Why `addr[9:2]` in the code?

Great question.

RISC-V instructions are **always 4 bytes long** — so the CPU reads:

* Address 0 → instruction 0
* Address 4 → instruction 1
* Address 8 → instruction 2
* And so on…

So instead of dividing by 4, we just shift the address right by 2 bits:

```verilog
memory[addr[9:2]]; // This is addr / 4
```

✅ This gives you the correct instruction index.

---

## 📜 Example Program

Let’s say your `program.mem` file (loaded at start) contains:

```
00000293   // addi x5, x0, 0
00430313   // addi x6, x6, 4
0062A023   // sw x6, 0(x5)
0000006F   // jal x0, 0 (infinite loop)
```

These are machine instructions in **hexadecimal**, written into instruction memory during simulation.

---

## 🔁 Step-by-Step Flow

1. 🧠 CPU has a Program Counter: `PC = 0`
2. 📨 PC is sent to Instruction Memory: `addr = 0`
3. 🧾 Instruction Memory outputs: `instr = 00000293`
4. CPU decodes and executes that instruction
5. PC becomes `PC = 4`
6. Instruction Memory gives next instruction
7. This repeats every cycle

---

## 📦 Simple Verilog Code (Just Like a ROM):

```verilog
module instruction_memory (
    input  wire [31:0] addr,   // PC
    output wire [31:0] instr   // Fetched instruction
);

    reg [31:0] memory [0:255]; // 1KB = 256 instructions

    initial begin
        $readmemh("program.mem", memory); // Load instructions from hex file
    end

    assign instr = memory[addr[9:2]]; // Word-aligned access

endmodule
```

---

## 🧠 Analogy

| Part                 | What it is like                       |
| -------------------- | ------------------------------------- |
| Instruction Memory   | A ROM (like a printed book)           |
| PC (Program Counter) | A bookmark telling which line to read |
| addr\[9:2]           | Skips 4 bytes per instruction         |
| \$readmemh           | Loads your program before starting    |

---

## ✅ You Only Need to Remember:

* Your **program is a list of 32-bit instructions**
* The **PC gives the address**
* The **Instruction Memory gives the instruction**
* You just need to **load instructions using `$readmemh`**

