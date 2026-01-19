module data_memory (
    input clk,
    input MemRead,
    input MemWrite,
    input [31:0] addr,
    input [31:0] write_data,
    output reg [31:0] read_data
);
    reg [31:0] mem [0:255];

    always @(posedge clk) begin
        if (MemWrite)
            mem[addr[31:2]] <= write_data;
    end

    always @(*) begin
        if (MemRead)
            read_data = mem[addr[31:2]];
        else
            read_data = 0;
    end
endmodule
