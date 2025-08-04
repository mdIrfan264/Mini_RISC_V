## 📍 What is the **Program Counter (PC)?**

The **Program Counter (PC)** is a hardware register that **stores the address of the current instruction**. Every clock cycle, it tells the processor **where to fetch the next instruction** from.

In RISC-V:

* Instructions are **32-bit (4 bytes)**.
* So PC typically increments by **4** each cycle to go to the next instruction.

---

## 🧠 Why is the PC Important?

| Function                 | Explanation                                                                          |
| ------------------------ | ------------------------------------------------------------------------------------ |
| **Instruction Fetch**    | The PC provides the address to instruction memory.                                   |
| **Sequential Execution** | It keeps the processor moving forward, instruction-by-instruction.                   |
| **Branch/Jump Handling** | When a `beq`, `jal`, etc., is executed, the PC must be **updated** to a new address. |

---

## 🔧 Basic Operation of PC

### 🟢 No Branching (Default case):

```verilog
PC_next = PC + 4;
```

### 🔀 With a Branch:

```verilog
PC_next = branch_target;  // Only if branch is taken
```

---

## 💡 Verilog Implementation Concept

Here’s a simple version of the PC:

```verilog
module pc (
    input wire clk,
    input wire reset,
    input wire [31:0] pc_next,
    output reg [31:0] pc_out
);

always @(posedge clk or posedge reset) begin
    if (reset)
        pc_out <= 32'b0;
    else
        pc_out <= pc_next;
end

endmodule
```

---

### 🔄 How It Connects:

* `pc_out` → Goes to instruction memory as address.
* `pc_next` → Computed in top module (based on branch or pc + 4).
* The `reset` ensures that PC starts at address 0 on boot.

---

## 🧠 How `pc_next` is Computed (in your top-level CPU)

Inside your `cpu_core.v`:

```verilog
assign pc_next = (branch_taken) ? branch_target : pc_out + 4;
```

So:

* If a branch is taken → jump to branch target
* Otherwise → go to next instruction sequentially

---

## 📊 Example Flow (Cycle by Cycle)

| Cycle | PC Value                 | Instruction        |
| ----- | ------------------------ | ------------------ |
| 0     | 0x0000                   | `add x1, x2, x3`   |
| 1     | 0x0004                   | `lw x4, 0(x5)`     |
| 2     | 0x0008                   | `beq x1, x0, loop` |
| 3     | 0x000C or branch\_target |                    |

---

## ✅ Summary: What PC Does

| Signal    | Role                                               |
| --------- | -------------------------------------------------- |
| `pc_out`  | Current PC address (used to fetch instruction)     |
| `pc_next` | Next PC value (determined by branch or default +4) |
| `reset`   | Initializes PC to 0                                |
| `clk`     | On rising edge, PC is updated                      |

---

## 🚀 Why You Need It

* Without PC, the CPU **won’t know where to go next**.
* PC is the **driver of execution flow**.
* It’s essential for both **normal operation and branching/jumping**.

