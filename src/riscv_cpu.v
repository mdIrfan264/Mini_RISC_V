
module riscv_cpu (
    input clk,
    input reset,
    output [31:0] pc_out
);
    wire [31:0] pc, pc_next, instruction;
    wire [31:0] imm, reg_data1, reg_data2;
    wire [31:0] alu_src_b, alu_result, mem_data;
    wire Zero;

    wire RegWrite, MemRead, MemWrite, MemToReg, ALUSrc, Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUCtrl;

    // PC
    pc PC(clk, reset, pc_next, pc);

    // Instruction Memory
    instruction_memory IM(pc, instruction);

    // Control Unit
    control_unit CU(instruction[6:0], RegWrite, MemRead,
                    MemWrite, MemToReg, ALUSrc, Branch, ALUOp);
                    
                    

    // Register File
    wire[4:0] rs1,rs2,rd;
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rd = instruction[11:7];
    register_file RF(clk, RegWrite,
        rs1, rs2, rd,
        MemToReg ? mem_data : alu_result,
        reg_data1, reg_data2);

    // Immediate Generator
    immediate_generator IG(instruction, imm);

    // ALU Control
    wire [2:0]funct3;
    wire funct730 = instruction [30];
    assign  funct3 = instruction [14:12];
    alu_control AC(ALUOp, funct3, funct730, ALUCtrl);

    // ALU
    assign alu_src_b = ALUSrc ? imm : reg_data2;
    wire [31:0]A,B,Result;
    assign A = reg_data1;
    assign B = alu_src_b;
    assign Result = alu_result;
    alu ALU(A, B, ALUCtrl, Result, Zero);

    // Data Memory
    wire [31:0]addr,write_data,read_data;
    assign addr = alu_result;
    assign write_data = reg_data2;
    assign read_data = mem_data;
    data_memory DM(clk, MemRead, MemWrite,
                   addr, write_data, read_data);

    // PC Update
    assign pc_next = (Branch && Zero) ? pc + imm : pc + 4;
    assign pc_out = pc;


endmodule

