
module instruction_memory (
    input [31:0] pc,
    output [31:0] instruction
);
    reg [31:0] mem [0:255];   // 256 instructions
    wire [31:0] addr = pc;

    integer i;
    initial begin
    $readmemh("program.hex", mem);
end

    assign instruction = mem[addr[31:2]]; // PC / 4
endmodule

